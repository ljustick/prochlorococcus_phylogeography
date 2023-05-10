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

while IFS= read -r file; do

    UNPAIRED="Pro_HLII_rpoC1_${file}.fa"

    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads $CORES \
            -x REF_DB \
            -f $UNPAIRED \
            --no-unal \
            -S $file.sam \
            --local -D 15 -R 2 -L 15 -N 1 --gbar 1 --mp 3

    #1) Map short reads against reference gene sequence
    # Create bowtie2 database
    #bowtie2-build HLII_ref.fasta REF_DB

    # bowtie2 mapping
    #bowtie2 -x REF_DB -U $file.fastq --no-unal -S $file.sam

    # samtools: sort .sam file and convert to .bam file
    samtools view -bS $file.sam | samtools sort - -o $file.bam

    #2) Get consensus sequence from .bam file
    # Get consensus fastq file
    samtools mpileup -uf HLII_ref.fa $file.bam | bcftools call -c | vcfutils.pl vcf2fq > $file_cns.fastq

    # vcfutils.pl is part of bcftools
    # Convert .fastq to .fasta and set bases of quality lower than 20 to N
    seqtk seq -aQ64 -q20 -n N $file_cns.fastq > $file_cns.fasta


    # covert the resulting SAM file to a BAM file:
    #samtools view -F 4 -bS $file.sam > $file-RAW.bam
    # sort and index the BAM file:
    #samtools sort $file-RAW.bam -o $file.bam
    #samtools index $file.bam
    # remove temporary files:
    #rm $file.sam $file-RAW.bam

done < "/dfs3/amartiny-lab/global_oceans/tara/tara_grp1.txt"