#!/bin/bash
# find all pngs in specified folder (recursively) and optimise them with optipng
dir=$1
if [[ -z $dir || ! -d $dir ]]; then
  echo Usage: $0 dir-to-search
  exit 1
fi
if ! which optipng &> /dev/null; then
  echo You need to have optipng installed for this to work!
  exit 2
fi

function search() {
  find "$dir" -type f -iname "*.png" $@
}
if ! search | grep -iq "\.png$"; then
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
  xargs -0 optipng -o7 -strip all -clobber

printSizes Final
