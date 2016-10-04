#!/bin/bash
# short script to clean htseq file output
for f in `ls *.htseq.txt`
do
grep -v "processed" $f |\
grep -v "Warning" | grep -v "__" > $f.clean
done
