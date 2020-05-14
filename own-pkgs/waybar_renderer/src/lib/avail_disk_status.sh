#!/bin/sh

avail=$(df / -h | tail -n1| awk '{print $(NF-2) }')
echo "$avail "
