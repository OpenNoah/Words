#!/bin/bash -e
echo "Converting $1"
iconv -f GB2312 -t UTF8 -o /tmp/enc.tmp "$1"
cat /tmp/enc.tmp > "$1"
