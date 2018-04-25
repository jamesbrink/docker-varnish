#!/bin/bash

DOCKER_GEN_PID="/var/run/docker-gen.pid"
VARNISH_PID="/var/run/varnish.pid"

cleanup() {
	if [ -f $DOCKER_GEN_PID ]; then
		echo "Stopping Docker-Gen"
		pid="$(cat $DOCKER_GEN_PID)"
		if [ "$(kill -0 $pid)" ]; then
			kill -SIGTERM "$pid"
		fi
	fi
	if [ -f $VARNISH_PID ]; then
		echo "Stopping Varnish"
		pid="$(cat $VARNISH_PID)"
		if [ "$(kill -0 $pid)" ]; then
			kill -SIGTERM "$pid"
		fi
	fi
}

if [ "$#" -eq 0 ]; then
	trap cleanup SIGINT SIGTERM
	echo "Starting Docker-Gen"
	docker-gen -config "/usr/local/etc/docker-gen/varnish/$VCL.conf" -endpoint "unix:///tmp/docker.sock" &
	echo $! >$DOCKER_GEN_PID
	while [ ! -f "/usr/local/etc/varnish/$VCL.vcl" ]; do
		sleep 1
	done
	chmod 755 "/usr/local/etc/varnish/$VCL.vcl"
	echo "Starting Varnish"
	varnishd -F -a 0.0.0.0:80 -T localhost:6082 -s malloc,256m -f "/usr/local/etc/varnish/$VCL.vcl" &
	echo $! >$VARNISH_PID
	wait
	echo "Exiting"
else
	exec "$@"
fi
