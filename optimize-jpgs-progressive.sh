#!/bin/bash
# find all jpegs in specified folder (recursively) and optimise them with jpegtran
dir=$1
if [[ -z $dir || ! -d $dir ]]; then
  echo Usage: $0 dir-to-search [no-progressive]
  exit 1
fi
if ! which jpegtran &> /dev/null; then
  echo You need to have jpegtran installed for this to work!
  exit 2
fi
[[ -z $2 ]] && prog="-progressive"

function search() {
  find "$dir" -type f \( -iname "*.jpeg" -o -iname "*.jpg" \)  $@
}
if ! search | grep -iq "\.jpe\?g$"; then
  echo No file found, exiting
  exit 0
fi

# but also report size difference
function printSizes() {
  echo $1 size of images in K and M
  search -print0 |
    xargs -0 du -k | awk '{a+=$1} END{print a, a/1024}'
}

printSizes Current

search -print0 |
  xargs -0 -I "{}" jpegtran -copy none -optimize $prog -outfile {} {}

printSizes Final
