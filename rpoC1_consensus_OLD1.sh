#!/bin/bash
#$ -N tara_rpoC1_1
#$ -q abio,bio
#$ -pe openmp 64
#$ -m beas
#$ -ckpt blcr

module purge
module load samtools/1.3
module load bowtie2/2.2.7
module load bcftools/1.10.2

    #bowtie2-build HLII_ref.fa REF_DB
    bowtie2-build HLII_MIT9322.fa REF_MIT9322

while IFS= read -r file; do

    UNPAIRED="Tara_HLII_FA/Pro_HLII_rpoC1_${file}.fa"

    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads $CORES \
            -x REF_MIT9322 \
            -f $UNPAIRED \
            --no-unal \
            -S $file.sam \
            --local -D 15 -R 2 -L 9 -N 1 --gbar 1 --mp 2,1

    # samtools: sort .sam file and convert to .bam file
    samtools view -bS $file.sam | samtools sort - -o $file.bam

    #2) Get consensus sequence from .bam file
    # Get consensus fastq file
    samtools mpileup -uf HLII_MIT9322.fa $file.bam | bcftools call -c | vcfutils.pl vcf2fq > $file_cns.fastq

    # vcfutils.pl is part of bcftools
    # Convert .fastq to .fasta and set bases of quality lower than 20 to N
    seqtk seq -aQ64 -q20 -n N $file_cns.fastq > $file_cns.fasta

done < "/dfs3/amartiny-lab/global_oceans/tara/tara_grp1.txt"