#!/bin/bash
# simple textual diff-er that outputs html to stdout
# NB: if the text can't be extracted, it won't show up, eg. text in pics or garbled pdfs
pdf1=$1
pdf1n=$(basename $1)
pdf2=$2
pdf2n=$(basename $2)
params=$3
encoding=${4:-UTF-8}
[[ -z $2 ]] && exit 111

cat <<HTMLHEAD
<html>
<head>
  <meta charset="UTF-8"/>
  <title>Spremembe med $pdf1n in $pdf2n</title>
</head>
<style>
  body { max-width: 1000px; background: burlywood; }
  pre { white-space: pre-wrap; }
  .added  { color: green; background: #e3f3c5; }
  .removed { color: red; background: #fedfdf; text-decoration: line-through; }
</style>
<body>
  <h1>Besedilne spremembe med:
    <ul>
      <li> <span class="removed">$pdf1n</span></li>
      <li> <span class="added">$pdf2n</span></li>
    </ul>
  </h1>
  <pre>
HTMLHEAD

dwdiff -i -A best -P $params \
  --start-delete='<span class="removed">' --stop-delete='</span>' \
  --start-insert='<span class="added" >' --stop-insert='</span>' \
  <(pdftotext -enc $encoding -layout "$pdf1" -) \
  <(pdftotext -enc $encoding -layout "$pdf2" -)

cat <<-HTMLTAIL
</pre></body></html>
HTMLTAIL
