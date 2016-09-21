#!/bin/bash
for f in `ls *R1.fastq.gz`
do
e="$(echo $f | cut -d "_" -f 1,2)"
echo "#$ -N $e
#$ -q medium*
#$ -cwd
#$ -o ogs_${e}_output.txt
#$ -e ogs_${e}_errror.txt
module load star
STAR \
--runThreadN 1 \
--genomeDir ./ \
--readFilesIn ${e}_R1.fastq.gz ${e}_R2.fastq.gz \
--readFilesCommand gunzip -c \
--outTmpDir _STARTMP_$e \
--outFileNamePrefix $e \
>& ${e}.STAR.out.txt" > job.ogs
qsub job.ogs
rm -f job.ogs
done
