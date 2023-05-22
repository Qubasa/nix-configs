#!/usr/bin/env bash
set -ep

easylist_ads=$(curl https://justdomains.github.io/blocklists/lists/easylist-justdomains.txt)
easylist_ads=$(echo "$easylist_ads" | awk '{print "local-zone: \""$1"\" redirect\nlocal-data: \""$1" A 0.0.0.0\""}')

echo "==== Easylist ads ===="
echo "$easylist_ads" | tail -n2

easylist_privacy=$(curl https://justdomains.github.io/blocklists/lists/easyprivacy-justdomains.txt)
easylist_privacy=$(echo "$easylist_privacy" | awk '{print "local-zone: \""$1"\" redirect\nlocal-data: \""$1" A 0.0.0.0\""}')

echo "==== Easylist privacy ===="
echo "$easylist_privacy" | tail -n2

peter_lowe=$(curl "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=1&mimetype=plaintext")

echo "==== Peter lowe ===="
echo "$easylist_privacy" | tail -n2

adguard=$(curl https://justdomains.github.io/blocklists/lists/adguarddns-justdomains.txt)
adguard=$(echo "$adguard" | awk '{print "local-zone: \""$1"\" redirect\nlocal-data: \""$1" A 0.0.0.0\""}')

echo "==== Adguard ===="
echo "$adguard" | tail -n2


#spotify=$(curl https://raw.githubusercontent.com/x0uid/SpotifyAdBlock/master/hosts)
#spotify=$(echo "$spotify" | grep -v "#" | grep . | awk '{print "local-zone: \""$2"\" redirect\nlocal-data: \""$2" A 0.0.0.0\""}')
#
#echo "==== Spotify ===="
#echo "$spotify" | tail -n2

cp /etc/nixos/local_deny.unbound /var/lib/unbound

echo "$easylist_ads" "$easylist_privacy" "$adguard" "$peter_lowe" | sort -u > ads.txt

echo "==== Restarting unbound ===="
systemctl restart unbound.service
