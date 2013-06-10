# Background

On Optus cable network, all `*.akamaihd.net` addresses get resolved to an overseas address, causing very slow performance - 1-2 Kbps is not unusual.

The root cause, IMHO, is intentionally or accidentally misconfigured akamai resolver since Optus does have an akamai farm (at least a /24 subnet)

Interestingly, trailers.apple.com always resolves to an Optus hosted akamai mirror, so we use that to get a non-hardcoded IP address of an akamai host.

# dns_check.sh

This script is intended for use on OpenWRT routers that use dnsmasq as their DNS resolver. It works by resolving `trailers.apple.com` to an IP address and using that IP address for `*.akamaihd.net` which is used for things like Facebook images and ABC iView. It is best to schedule this script to run every day to make sure that it uses up to date IP address.

# Setup
* Copy dns_check folder onto the router, eg into /root/dns_check
* If you modified dnsmasq.conf on your router, make sure to copy those changes into dnsmasq.base.conf
* Make sure that the script has executable flag set:
    $ chmod +x /root/dns_check
* Edit the file `/etc/crontabs/root` to have the below line (22 is the hour when this scripts gets run, change at your disgression):
    0 22 * * * /root/dns_check/dns_check.sh
