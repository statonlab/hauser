#!/bin/bash
# remove old links if they exist
rm -f *.fastq.gz
# link raw files
ln -s ../../raw/*.gz ./
# rename for clarity and ordering
rename _L001_ _ *
rename _001. . *
rename - _ *
rename control CO *
rename T0_ T000_ *
rename T30_ T030_ *
rename T60_ T060_ *
for f in `ls *.gz`
do
e="$(echo $f | cut -d "_" -f 1,2,4)"
mv $f $e
done
# link yeast genome
ln -s ../../raw/yeast.fasta ./
ln -s ../../raw/yeast.gff ./
ln -s ../../raw/yeast.gtf ./
#sed 's/Saccharomyces cerevisiae.*//' yeast.fasta > yeast_fix.fasta
#rm -f yeast.fasta
#mv yeast_fix.fasta yeast.fasta
