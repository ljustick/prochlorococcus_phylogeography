#!/bin/bash

# You can fine anvio tutorials at https://anvio.org
# Script to profile all samples and summarize

conda activate anvio

for sample in $(ls *.bam);
do
    echo "$sample"

    anvi-profile -c /home/lustick/data_bases/ProSynSAR_GDB_reformat.db \
        -i $sample.bam \
        --min-contig-length 1000\
        --skip-SNV-profiling \
        --num-threads 26 \
        -o $sample

    anvi-import-collection /home/lustick/data_bases/ProSynSAR-GENOME-COLLECTION.txt \
        -c /home/lustick/data_bases/ProSynSAR_GDB_reformat.db \
        -p $sample/PROFILE.db \
        -C Genomes

    anvi-summarize -c /home/lustick/data_bases/ProSynSAR_GDB_reformat.db \
        -p $sample/PROFILE.db \
        -C Genomes \
        --init-gene-coverages \
        -o $sample-SUMMARY

done

anvi-gen-genomes-storage -i internal-genomes.txt -o ProSynSar-PAN-GENOMES.db

anvi-pan-genome -g ProSynSar-PAN-GENOMES.db \
    --project-name "Global_Pan" \
    --num-threads 26 \
    --minbit 0.5 \
    --mcl-inflation 10 \
    --use-ncbi-blast

anvi-script-add-default-collection -p Global_Pan/Global_Pan-PAN.db

# Summarize metapangenome 
anvi-summarize -p Global_Pan/Global_Pan-PAN.db -g ProSynSar-PAN-GENOMES.db -C DEFAULT -o ProSynSar-PAN-SUMMARY

# Isolate reads that mapped to rpoC1
gcid="gene_ID_of_rpoC1"
file="output_file_name"

# Get the unassembled reads used
anvi-get-short-reads-mapping-to-a-gene \
    -i /home/lustick/redo/*.bam \
    -c /home/lustick/data_bases/ProSynSAR_GDB_reformat.db \
    --gene-caller-id $gcid \
    --leeway 35 \
    -o /home/lustick/redo_rpoC1/redo_${file}_rpoc1.fa