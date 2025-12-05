#!/bin/sh -xe

# Update package repository
pkg update -q

# Install build dependencies
pkg install -y git gmake

mkdir -p /var/lib/lavinmq

# Check if NVMe SSD data disk is present (FreeBSD uses nvd* for NVMe drives)
# Also check for da* devices (AWS may present EBS as da*)
if geom disk list | grep -q nvd1; then
  # Format and mount NVMe drive
  gpart create -s GPT nvd1 || true
  gpart add -t freebsd-ufs nvd1 || true
  newfs /dev/nvd1p1
  mount /dev/nvd1p1 /var/lib/lavinmq
elif geom disk list | grep -q da1; then
  # Format and mount additional EBS volume
  gpart create -s GPT da1 || true
  gpart add -t freebsd-ufs da1 || true
  newfs /dev/da1p1
  mount /dev/da1p1 /var/lib/lavinmq
fi

# Clone and build LavinMQ from source
cd /tmp
if [ -n "${LAVINMQ_VERSION}" ]; then
  git clone --branch "v${LAVINMQ_VERSION}" --depth 1 https://github.com/cloudamqp/lavinmq.git
else
  git clone --depth 1 https://github.com/cloudamqp/lavinmq.git
fi

cd lavinmq
gmake -j$(sysctl -n hw.ncpu)

# Install binaries
install -m 755 bin/lavinmq /usr/local/bin/
install -m 755 bin/lavinmqctl /usr/local/bin/
install -m 755 bin/lavinmq-perf /usr/local/bin/

# Create lavinmq user if it doesn't exist
pw user show lavinmq > /dev/null 2>&1 || pw useradd lavinmq -d /var/lib/lavinmq -s /usr/sbin/nologin

# Set ownership
chown -R lavinmq:lavinmq /var/lib/lavinmq

# Create rc.d service script
cat > /usr/local/etc/rc.d/lavinmq << 'EOF'
#!/bin/sh

# PROVIDE: lavinmq
# REQUIRE: NETWORKING
# KEYWORD: shutdown

. /etc/rc.subr

name="lavinmq"
rcvar="lavinmq_enable"
command="/usr/local/bin/lavinmq"
command_args="-d /var/lib/lavinmq"
pidfile="/var/run/${name}.pid"
lavinmq_user="lavinmq"

start_cmd="${name}_start"
stop_cmd="${name}_stop"
status_cmd="${name}_status"

lavinmq_start()
{
    echo "Starting ${name}."
    /usr/sbin/daemon -p ${pidfile} -u ${lavinmq_user} ${command} ${command_args}
}

lavinmq_stop()
{
    if [ -f ${pidfile} ]; then
        echo "Stopping ${name}."
        kill $(cat ${pidfile})
        rm -f ${pidfile}
    else
        echo "${name} is not running."
    fi
}

lavinmq_status()
{
    if [ -f ${pidfile} ]; then
        echo "${name} is running as pid $(cat ${pidfile})."
    else
        echo "${name} is not running."
        return 1
    fi
}

load_rc_config $name
run_rc_command "$1"
EOF

chmod +x /usr/local/etc/rc.d/lavinmq

# Enable and start the service
sysrc lavinmq_enable=YES
service lavinmq start

# Clean up
rm -rf /tmp/lavinmq
