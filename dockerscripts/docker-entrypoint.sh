#!/bin/sh

# If command starts with an option, prepend iperf3
if [ "${1}" != "minio" ]; then
	if [ -n "${1}" ]; then
		set -- minio "$@"
	fi
fi

# Limit incoming network to 200 mbps
tc qdisc add dev eth0 handle ffff: ingress
tc filter add dev eth0 parent ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 200mbit burst 4m drop flowid :1
# limit outgoing network to 8 mbps
tc qdisc add dev eth0 root tbf rate 8mbit latency 5ms burst 10k

exec "$@"
