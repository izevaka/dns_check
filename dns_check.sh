#!/bin/sh
############################################################################
# dns_check.sh - Updates dnsmasq.conf with a hardcoded IP address for
# a specified host by resolving another host.
############################################################################

BASE_FILE=`dirname $0`/dnsmasq.base.conf
TARGET_FILE=/etc/dnsmasq.conf
FALLBACK_IP=125.56.205.24
LOG="logger -t `basename $0`"

# This is the host we want to resolve to an IP address of $SOURCE_HOST
RESOLVE_HOST=akamaihd.net
# This is the host whose IP address we want to use for misbehaving hosts
SOURCE_HOST=trailers.apple.com

# Pick the first server out of nslookup for $SOURCE_HOST
new_ip=`nslookup $SOURCE_HOST | grep "Address 1:" | grep -v localhost | cut -d' ' -f3 | head -n 1`
# Sometimes nslookup fails, fall back onto a hardocded IP then
if [ "$new_ip" == "" ]; then
    $LOG "Failed to look up IP for $SOURCE_HOST using $FALLBACK_IP"
    new_ip=$FALLBACK_IP
fi
$LOG "Changing $RESOLVE_HOST address to $new_ip"
# Overwrite the config file and append the new IP address to the end of the file
cp $BASE_FILE $TARGET_FILE
echo "address=/$RESOLVE_HOST/$new_ip" >> $TARGET_FILE
# Restart dnsmasq for config to take effect
/etc/init.d/dnsmasq restart

