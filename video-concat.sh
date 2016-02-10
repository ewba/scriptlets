#!/bin/bash
# plain concatenation
input1=$1
input2=$2
out=${3:cat}
[[ -z $2 ]] && exit 111

ffmpeg -i "concat:$input1|$input2" -c copy "$out.avi"
