#!/bin/sh

brightness=$(light | cut -d '.' -f 1)
echo "$brightness% "
