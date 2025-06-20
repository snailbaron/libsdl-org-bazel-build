#!/bin/sh -x

output_file="$1"
shift

"$@" 2>/dev/null

if [ $? -eq 0 ]; then
    echo 1 > "${output_file}"
else
    echo 0 > "${output_file}"
fi
