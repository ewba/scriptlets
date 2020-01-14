#!/bin/bash

for f in "$@"; do
  pdftotext "$f" -
done | grep Doseg
