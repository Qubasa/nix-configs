#!/bin/sh

temp=$(sensors -u 2> /dev/null| grep -A 5 gpu | grep temp1_input | awk '{ print $2 }' | cut -d '.' -f1)
echo "$temp "
