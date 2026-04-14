#!/bin/bash -xe

# Raise file descriptor limits for high-connection benchmarks
# Applied to both broker and load generator instances

# Kernel-level limits
sysctl -w fs.file-max=2097152
sysctl -w fs.nr_open=2097152
sysctl -w vm.max_map_count=2097152
sysctl -w net.core.somaxconn=65535
sysctl -w net.ipv4.tcp_max_syn_backlog=65535
sysctl -w net.core.netdev_max_backlog=65535
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.ipv4.tcp_abort_on_overflow=0
sysctl -w net.ipv4.tcp_max_tw_buckets=2000000
sysctl -w net.ipv4.ip_local_port_range="1024 65535"

# Persist across reboots
cat >> /etc/sysctl.conf <<EOF
fs.file-max=2097152
fs.nr_open=2097152
vm.max_map_count=2097152
net.core.somaxconn=65535
net.ipv4.tcp_max_syn_backlog=65535
net.core.netdev_max_backlog=65535
net.ipv4.tcp_syncookies=0
net.ipv4.tcp_abort_on_overflow=0
net.ipv4.tcp_max_tw_buckets=2000000
net.ipv4.ip_local_port_range=1024 65535
EOF

# User-level limits
cat >> /etc/security/limits.conf <<EOF
* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
EOF

# Apply to current session via PAM
cat >> /etc/pam.d/common-session <<EOF
session required pam_limits.so
EOF

# Also raise for systemd services (e.g., lavinmq)
mkdir -p /etc/systemd/system.conf.d
cat > /etc/systemd/system.conf.d/limits.conf <<EOF
[Manager]
DefaultLimitNOFILE=1048576
EOF

systemctl daemon-reload
