#!/bin/bash
if [ ! -f /var/tmp/varnishReloadCount ]; then
    echo 0 > /var/tmp/varnishReloadCount
fi
RELOAD_COUNT="$(cat /var/tmp/reloadCount)"
RELOAD_COUNT=$((RELOAD_COUNT +1))
echo $RELOAD_COUNT > /var/tmp/varnishReloadCount


chmod 755 "/usr/local/etc/varnish/$VCL.vcl"
echo "Varnish - Reloading Config $VCL - ReloadCount: $RELOAD_COUNT"
/usr/local/bin/varnishadm "vcl.load reload_$RELOAD_COUNT /usr/local/etc/varnish/$VCL.vcl"