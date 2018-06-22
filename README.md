# lsyncd for check_mk

## Description

This is a check_mk local check for use with check_mk on nagios.
https://mathias-kettner.de/checkmk_localchecks.html

The following tests are implemented:

- Is an lsyncd process running? If not, CRITICAL status is returned.

- Does an lsyncd status file exist? If not, CRITICAL status is returned.

- Compare the total number of delays to warning and critical thresholds.

The plugin requires a `statusFile` to be configured. The path defaults to
`/var/run/lsyncd.status`.

## Install

On the machine to be monitored:
- Put lsynd.sh inside of /usr/share/check-mk-agent/local
- chmod +x /usr/share/check-mk-agent/local/lsynd.sh

On the nagios/check_mk server:
- check_mk -I --checks local HOSTNAME_OF_MACHINE
- check_mk -O

Now browse to your service status details for the host, and you should see a service for lsyncd.
