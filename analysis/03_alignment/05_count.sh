#!/bin/bash
# count aligned reads to mRNAs (genes) using htseq
for f in `ls *sorted.sam`
do
e="$(echo $f | cut -d '.' -f 1)"
echo "#$ -N ${e}_htseq
#$ -q medium*
#$ -cwd
#$ -o ogs_${e}_htseq_output.txt
#$ -e ogs_${e}_htseq_error.txt
/lustre/projects/staton/software/htseq-count \
-t exon \
-i gene_id \
./$f \
./yeast.gtf \
>& ${e}.htseq.txt" > job.ogs
qsub job.ogs
rm -f job.ogs
done
