#!/bin/sh

temp=$(sensors -u 2> /dev/null| sed -n 's/_input//p' | head -n 1 | awk '{print int($2)}')
echo "$temp "
