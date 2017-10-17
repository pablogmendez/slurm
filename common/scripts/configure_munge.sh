#!/bin/bash
echo "In9LBtuTZrugWYyIeN6s1bgdg0c3yqfd" >/etc/munge/munge.key
chown munge: /etc/munge/munge.key
chmod 400 /etc/munge/munge.key