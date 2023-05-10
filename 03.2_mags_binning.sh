#!/bin/bash

#get the paths to data and desired output directories
path="path_to_unassembled_reads"
output="desired_output_directory"
assembly="path_to_assembly_from_03.1_script"
sample="sample_name"
forward=${path}${sample}_R1.fastq.gz
reverse=${path}${sample}_R2.fastq.gz

cd $output
mkdir $sample
cd $output/$sample


# 1 map the reads to the assembly
module purge
module load samtools/1.10
module load bowtie2/2.4.1
# build reference of assembled contigs for mapping
bowtie2-build $assembly/$sample/contigs.fasta ${sample}_contig_ref
# do the bowtie mapping to get the SAM file:
bowtie2 --threads 20 \
        -x ${sample}_contig_ref \
        -1 $forward \
        -2 $reverse \
        --no-unal \
        -S $sample.sam
# covert the resulting SAM file to a BAM file:
samtools view -F 4 -bS $sample.sam > $sample-RAW.bam
# sort and index the BAM file:
samtools sort $sample-RAW.bam -o $sample.bam
samtools index $sample.bam
# remove temporary files:
rm $sample.sam $sample-RAW.bam


# 2 bin the assembly, and activate anaconda environment with metabat2
conda activate metabat2_env
#bin samples
mkdir bins_dir
jgi_summarize_bam_contig_depths --outputDepth depth.txt $sample.bam
metabat2 -t 20 -i ${assembly}/${sample}/contigs.fasta -a depth.txt -o bins_dir/bin
conda deactivate


# 3 evaluate bins, and activate anaconda environment with checkm
conda activate checkm
checkm lineage_wf -t 20 -x fa bins_dir checkm
conda deactivate
