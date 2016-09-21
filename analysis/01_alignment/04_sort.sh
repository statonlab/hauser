#!/bin/bash
# sort sam
for f in `ls *.sam`
do
e="$(echo $f | cut -d '.' -f 1)"
echo "#$ -N ${e}_samtools
#$ -q medium*
#$ -cwd
#$ -o ogs_${e}_samtools_output.txt
#$ -e ogs_${e}_samtools_error.txt
/lustre/projects/staton/software/samtools-1.3/samtools \
sort -O sam $f > $e.sorted.sam" > job.ogs
qsub job.ogs
rm -f job.ogs
done
