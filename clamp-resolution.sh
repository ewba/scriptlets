#!/bin/bash
# find all jpegs in specified folder (recursively) and resizes the oversized ones
# WARNING: cannot tell which are deliberately huge (like responsive headers etc.)
dir=$1
width=${2:-1024}
height=${3:-786}
fsize=${4:-300k}
if [[ -z $dir || ! -d $dir ]]; then
  cat<<JEJE
  Usage: $0 dir-to-search [width=1024] [height=768] [minimum filesize=300k]
  Will resize any jpeg with bigger dimensions and filesize than specified
  IN PLACE! NO BACKUPS!
  (if jpegtran is available, the images will also be optimised)
JEJE
  exit 1
fi
if ! which mogrify &> /dev/null; then
  echo You need to have imagemagick installed for this to work!
  exit 2
fi
if which jpegtran &> /dev/null; then
  hasJT=yes
fi

function search() {
  find "$dir" -type f -size +$fsize \( -iname "*.jpeg" -o -iname "*.jpg" \) "$@"
}
if ! search | grep -iq "\.jpe\?g$"; then
  echo No file found, exiting
  exit 0
fi

# but also report size difference
function printSizes() {
  echo $1 size of images in K and M
  search -printf "%s %p\n" | awk '{a+=$1} END{a/=1024; print a, a/1024}'
}

printSizes Current
read -p "If you don't want to continue, press n within 10 seconds (and enter): " -t 10 reply
[[ $reply == n ]] && exit

search |
while read file; do
  size=( $(identify -format "%w %h" "$file" || continue) )
  if (( ${size[0]} > $width || ${size[1]} > $height )); then
		mogrify -scale ${height}x$width "$file"
		[[ $hasJT ]] && jpegtran -copy none -optimize -progressive -outfile "$file" "$file"
	fi
done

printSizes Final
