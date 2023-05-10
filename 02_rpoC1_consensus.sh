#!/bin/bash

module purge
module load samtools/1.3
module load bowtie2/2.2.7
module load bcftools/1.10.2

#build reference database of reference rpoC1 sequence
bowtie2-build rpoC1_ref.fa REF_DB

sample="sample_name"

# do the bowtie mapping to get the SAM file:
bowtie2 --threads 4 \
    -x REF_DB \
    -f $sample.fa \
    --no-unal \
    -S $sample.sam \
    --local -D 15 -R 2 -L 9 -N 1 --gbar 1 --mp 2,1

# samtools: sort .sam file and convert to .bam file
samtools view -bS $sample.sam | samtools sort - -o $sample.bam

#2) Get consensus sequence from .bam file
# Get consensus fastq file
samtools mpileup -uf rpoC1_ref.fa $sample.bam | bcftools call -c | vcfutils.pl vcf2fq > ${sample}_cns.fastq

# vcfutils.pl is part of bcftools
# Convert .fastq to .fasta and set bases of quality lower than 20 to N
seqtk seq -aQ64 -q20 -n N ${sample}_cns.fastq > ${sample}_cns.fasta

# remove temporary files:
rm $sample.sam $sample.bam ${sample}_cns.fastq