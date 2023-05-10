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
    #bowtie2-build AMT_cns.fasta REF_AMT
    bowtie2-build I09_cns.fasta I09_cns_REF


while IFS= read -r file; do
	#file="AMT125"
	#string1="AMT_HLII_FA/Pro_HLII_rpoC1_"
	#int1=$string1$file
    #string2="."
    #file="AMT059"
    unpaired="I09_HLII_FA/Pro_HLII_rpoC1_${file}.fa"
    #echo $UNPAIRED
    
    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads 4 \
            -x REF_MIT9322 \
            -f $unpaired \
            --no-unal \
            -S $file.sam \
            --local -D 15 -R 2 -L 9 -N 1 --gbar 1 --mp 2,1

    # samtools: sort .sam file and convert to .bam file
    samtools view -bS $file.sam | samtools sort - -o $file.bam

    #2) Get consensus sequence from .bam file
    # Get consensus fastq file
    #samtools mpileup -uf HLII_MIT9322.fa ERR598956.bam | bcftools call -c | vcfutils.pl vcf2fq > ERR598956_cns.fastq
    samtools mpileup -uf HLII_MIT9322.fa $file.bam | bcftools call -c | vcfutils.pl vcf2fq > ${file}_cns.fastq


    # vcfutils.pl is part of bcftools
    # Convert .fastq to .fasta and set bases of quality lower than 20 to N
    seqtk seq -aQ64 -q20 -n N ${file}_cns.fastq > ${file}_cns.fasta
    
    # remove temporary files:
    rm $file.sam $file.bam ${file}_cns.fastq

done < "I09_Sra.txt"