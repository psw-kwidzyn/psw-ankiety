#!/bin/bash
XLS="$1"
TMP="${XLS%.*}.xlsx"

if [ ! -f "$XLS" ] ; then  echo "Podaj nazwę pliku";  exit ; fi

libreoffice --headless --convert-to xlsx "$XLS" --outdir .
echo perl ./xslx2csv.pl "$TMP" "$OUTFILE"
