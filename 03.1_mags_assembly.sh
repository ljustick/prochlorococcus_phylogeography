#!/bin/bash

# activate conda environment with spades
conda activate mags

# sample name to assemble
sample="sample_name"

# forward and reverse read files
forward=${sample}_R1.fastq.gz
reverse=${sample}_R2.fastq.gz

#make output directory for the file
mkdir ${sample}_spades

# run the assembly using metaspades
metaspades.py -t 20 -m 200 -1 $forward -2 $reverse -o ${sample}_spades