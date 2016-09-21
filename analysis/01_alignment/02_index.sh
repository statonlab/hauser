#!/bin/bash
module load star
STAR \
--runThreadN 20 \
--runMode genomeGenerate \
--genomeDir ./ \
--genomeFastaFiles yeast.fasta \
--sjdbGTFfile yeast.gtf \
--sjdbOverhang 75 
