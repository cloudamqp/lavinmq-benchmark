package main

import (
	"fmt"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

// Minimal MQTT CONNECT packet (v3.1.1, clean session, with username/password)
func buildConnectPacket(clientID, username, password string) []byte {
	protocolName := []byte{0x00, 0x04, 'M', 'Q', 'T', 'T'}
	protocolLevel := byte(0x04)
	connectFlags := byte(0xC2) // username + password + clean session
	keepAlive := []byte{0x01, 0x2C} // 300 seconds

	clientIDBytes := encodeString(clientID)
	usernameBytes := encodeString(username)
	passwordBytes := encodeString(password)

	variableHeader := append(protocolName, protocolLevel)
	variableHeader = append(variableHeader, connectFlags)
	variableHeader = append(variableHeader, keepAlive...)

	payload := append(clientIDBytes, usernameBytes...)
	payload = append(payload, passwordBytes...)

	remainingLength := len(variableHeader) + len(payload)

	packet := []byte{0x10}
	packet = append(packet, encodeRemainingLength(remainingLength)...)
	packet = append(packet, variableHeader...)
	packet = append(packet, payload...)

	return packet
}

func encodeString(s string) []byte {
	length := len(s)
	return append([]byte{byte(length >> 8), byte(length & 0xFF)}, []byte(s)...)
}

func encodeRemainingLength(length int) []byte {
	var encoded []byte
	for {
		digit := byte(length % 128)
		length /= 128
		if length > 0 {
			digit |= 0x80
		}
		encoded = append(encoded, digit)
		if length == 0 {
			break
		}
	}
	return encoded
}

func connectFromIP(brokerAddr, localIP, prefix, username, password string, count int, conns *[]net.Conn, mu *sync.Mutex, connected, failed *int64) {
	var wg sync.WaitGroup
	batchSize := 500

	localAddr, err := net.ResolveTCPAddr("tcp", localIP+":0")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to resolve local addr %s: %v\n", localIP, err)
		return
	}

	for i := 0; i < count; i += batchSize {
		end := i + batchSize
		if end > count {
			end = count
		}

		for j := i; j < end; j++ {
			wg.Add(1)
			go func(id int) {
				defer wg.Done()
				clientID := fmt.Sprintf("%s_%s_%d", prefix, localIP, id)
				packet := buildConnectPacket(clientID, username, password)

				dialer := net.Dialer{
					Timeout:   10 * time.Second,
					LocalAddr: localAddr,
				}
				conn, err := dialer.Dial("tcp", brokerAddr)
				if err != nil {
					atomic.AddInt64(failed, 1)
					return
				}

				_, err = conn.Write(packet)
				if err != nil {
					conn.Close()
					atomic.AddInt64(failed, 1)
					return
				}

				buf := make([]byte, 4)
				conn.SetReadDeadline(time.Now().Add(10 * time.Second))
				_, err = conn.Read(buf)
				if err != nil || buf[3] != 0x00 {
					conn.Close()
					atomic.AddInt64(failed, 1)
					return
				}

				mu.Lock()
				*conns = append(*conns, conn)
				mu.Unlock()
				atomic.AddInt64(connected, 1)
			}(j)
		}
		wg.Wait()
		time.Sleep(100 * time.Millisecond)
	}
}

func main() {
	if len(os.Args) < 4 {
		fmt.Fprintf(os.Stderr, "Usage: %s <broker_ip:port> <count> <local_ips> [username] [password] [prefix]\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  local_ips: comma-separated list of local IPs to bind to\n")
		os.Exit(1)
	}

	brokerAddr := os.Args[1]
	count, err := strconv.Atoi(os.Args[2])
	if err != nil {
		fmt.Fprintf(os.Stderr, "Invalid count: %s\n", os.Args[2])
		os.Exit(1)
	}
	localIPs := strings.Split(os.Args[3], ",")

	username := "perftest"
	password := "perftest"
	prefix := "conn"
	if len(os.Args) > 4 {
		username = os.Args[4]
	}
	if len(os.Args) > 5 {
		password = os.Args[5]
	}
	if len(os.Args) > 6 {
		prefix = os.Args[6]
	}

	var connected int64
	var failed int64
	conns := make([]net.Conn, 0, count)
	var mu sync.Mutex

	// Distribute connections across local IPs
	maxPerIP := 30000
	remaining := count
	fmt.Fprintf(os.Stderr, "Distributing %d connections across %d IPs (max %d per IP)\n", count, len(localIPs), maxPerIP)

	var ipWg sync.WaitGroup
	for _, ip := range localIPs {
		if remaining <= 0 {
			break
		}
		chunk := remaining
		if chunk > maxPerIP {
			chunk = maxPerIP
		}
		remaining -= chunk

		fmt.Fprintf(os.Stderr, "Starting %d connections on %s\n", chunk, ip)
		ipWg.Add(1)
		go func(localIP string, n int) {
			defer ipWg.Done()
			connectFromIP(brokerAddr, localIP, prefix, username, password, n, &conns, &mu, &connected, &failed)
			fmt.Fprintf(os.Stderr, "IP %s done: %d connected total so far\n", localIP, atomic.LoadInt64(&connected))
		}(ip, chunk)
	}
	ipWg.Wait()

	total := atomic.LoadInt64(&connected)
	totalFailed := atomic.LoadInt64(&failed)
	fmt.Printf("Connected: %d\n", total)
	fmt.Printf("Failed: %d\n", totalFailed)

	// Send PINGREQ to all connections every 60 seconds
	fmt.Fprintf(os.Stderr, "Holding %d connections. Sending keepalives...\n", total)
	pingPacket := []byte{0xC0, 0x00}
	for {
		time.Sleep(60 * time.Second)
		mu.Lock()
		alive := 0
		for _, c := range conns {
			c.SetWriteDeadline(time.Now().Add(5 * time.Second))
			_, err := c.Write(pingPacket)
			if err == nil {
				alive++
			}
		}
		mu.Unlock()
		fmt.Fprintf(os.Stderr, "Keepalive: %d/%d connections alive\n", alive, total)
	}
}
