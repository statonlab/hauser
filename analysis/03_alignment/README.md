####remove old links if they exist
```
rm -f *.fastq.gz
```
####link raw files
```
ln -s ../../raw/*.gz ./
```
####rename for clarity and ordering
```
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
```
####link yeast genome
```
ln -s ../../raw/yeast.fasta ./
ln -s ../../raw/yeast.gff ./
ln -s ../../raw/yeast.gtf ./
#sed 's/Saccharomyces cerevisiae.*//' yeast.fasta > yeast_fix.fasta
#rm -f yeast.fasta
#mv yeast_fix.fasta yeast.fasta
```
---
module load star
STAR \
--runThreadN 20 \
--runMode genomeGenerate \
--genomeDir ./ \
--genomeFastaFiles yeast.fasta \
--sjdbGTFfile yeast.gtf \
--sjdbOverhang 75 
```
---
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
--quantMode GeneCounts \
--readFilesIn ${e}_R1.fastq.gz ${e}_R2.fastq.gz \
--readFilesCommand gunzip -c \
--outTmpDir _STARTMP_$e \
--outFileNamePrefix $e \
>& ${e}.STAR.out.txt" > job.ogs
qsub job.ogs
rm -f job.ogs
done
```
---
####sort sam
```
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
```
---
####count aligned reads to mRNAs (genes) using htseq
```
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
```
---
####short script to clean htseq file output
```
for f in `ls *.htseq.txt`
do
grep -v "processed" $f |\
grep -v "Warning" | grep -v "__" > $f.clean
done
```
---
