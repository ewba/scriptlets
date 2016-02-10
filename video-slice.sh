#!/bin/bash
# cut out, no recoding
input=$1
start=$2 # in seconds
duration=$3 # in seconds
out=${4:piece}
[[ -z $3 ]] && exit 111

ffmpeg -i "$input" -c copy -ss $start -t $duration "$out.avi"
