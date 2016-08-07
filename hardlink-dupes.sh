#!/bin/bash
# find all identical images and hardlink them to save space
dir=$1
mask=${2:-jpg jpeg png pdf gif}
if [[ -z $dir || ! -d $dir ]]; then
  echo Usage: $0 dir-to-search [filename extensions to search for as a list]
  echo "The default is to look for: 'jpg jpeg png pdf gif'"
  exit 1
fi

function search() {
  local ext=$1
  shift
  find "$dir" -type f -iname "*.$ext" $@
}

# but also report size difference
function printSizes() {
  echo $1 size of duplicates in K and M
  search $2 "-exec md5sum {} +" | sort | uniq -D -w32 |
    awk '{print $2}' | xargs du | awk '{a+=$1}END{print a}'
}


for ext in $mask; do
  if ! search $ext | grep -iq "\.$ext$"; then
    echo No file found, skipping
    continue
  fi

  printSizes Current $ext

  search $ext "-exec md5sum {} +" |
  while read md file; do
    [[ -n $omd && $md == $omd ]] && ln -f $ofile $file
    omd=$md
    ofile=$file
  done

  printSizes Final $ext
done
