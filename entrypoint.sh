#!/bin/bash
set -e

if [ "$1" = 'freeswitch' ]; then
  shift

sed -i -e "s/name=\"listen-ip\" value=\".*\"/name=\"listen-ip\" value=\"0.0.0.0\"/g" /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
while :; do
  case $1 in 
  -s|--sip-port)
    if [ -n "$2" ]; then
      sed -i -e "s/sip_port=[[:digit:]]\+/sip_port=$2/g" /usr/local/freeswitch/conf/vars_diff.xml
    fi
    ;;

  -t|--tls-port)
    if [ -n "$2" ]; then
      sed -i -e "s/tls_port=[[:digit:]]\+/tls_port=$2/g" /usr/local/freeswitch/conf/vars_diff.xml
    fi
    ;;

  -e|--event-socket-port)
    if [ -n "$2" ]; then
      sed -i -e "s/name=\"listen-port\" value=\"8021\"/name=\"listen-port\" value=\"$2\"/g" /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
    fi
    ;;

  -a|--rtp-range-start)
    if [ -n "$2" ]; then
      sed -i -e "s/name=\"rtp-start-port\" value=\"16384\"/name=\"rtp-start-port\" value=\"$2\"/g" /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml
    fi
    ;;

  -z|--rtp-range-end)
    if [ -n "$2" ]; then
      sed -i -e "s/name=\"rtp-end-port\" value=\"32768\"/name=\"rtp-end-port\" value=\"$2\"/g" /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml
    fi
    ;;

  --ext-rtp-ip)
    if [ -n "$2" ]; then
      sed -i -e "s/ext_rtp_ip=.*\"/ext_rtp_ip=$2\"/g" /usr/local/freeswitch/conf/vars_diff.xml
    fi
    ;;

  --ext-sip-ip)
    if [ -n "$2" ]; then
      sed -i -e "s/ext_sip_ip=.*\"/ext_sip_ip=$2\"/g" /usr/local/freeswitch/conf/vars_diff.xml
    fi
    ;;

  -p|--password)
    if [ -n "$2" ]; then
      sed -i -e "s/name=\"password\" value=\"ClueCon\"/name=\"password\" value=\"$2\"/g" /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
    fi
    ;;

  --)
    shift
    break
    ;;

  *)
    break
  esac

  shift
  shift

done
    exec freeswitch "$@"
fi

exec "$@"