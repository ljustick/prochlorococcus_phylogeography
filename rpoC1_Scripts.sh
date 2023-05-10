
%concatinate files together
cat *.HLII_* > Pro_HLII_rpoC1.fa
cat * > I09_ALL_Pro_HLII.fa


mafft --retree 1 input_file > output_file 
mafft --retree 1 --thread 4 t_GC_Pro.HLII_13062_rpoc1.fa > test.fa

samtools mpileup -uf HLII_ref.fa ERR598942.bam | bcftools call -c | vcfutils.pl vcf2fq > ERR598942_cns.fastq

scp lustick@hpc.oit.uci.edu:/dfs5/bio/lustick/global_oceans_rpoC1/*.bam /Users/lucasustick/Desktop/Global_RPOC1/Tests/Consensus_Test
scp lustick@hpc.oit.uci.edu:/dfs5/bio/lustick/global_oceans_rpoC1/HLII_ref.fa /Users/lucasustick/Desktop/Global_RPOC1/Tests/Consensus_Test

scp lustick@martinyserver.ess.uci.edu:/home/lustick/tara2/*-SUMMARY /Volumes/Ustick_Data/Global_Nutrient_Stress_Copy

# consensus step after alignment
bcftools mpileup -uf HLII_ref.fa ERR598972.bam | bcftools call -c | vcfutils.pl vcf2fq > ERR598972_cns.fastq

seqtk seq -aQ64 -q20 -n N ERR598972_cns.fastq > ERR598972_cns.fasta

# Replaces fasta headers with file names & make numeric CSV
awk '/^>/ {gsub(/.fa(sta)?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' *.fasta > I09_ALL_HLII_CNS.fa
sed '/^>/!{s/[^ATCG]/N/g;}' I09_ALL_HLII_CNS.fa > temp0.fa
sed '/^>/!{s/[0-4]/,&/g;}' temp0.fa > temp1.fa
awk 'ORS=NR%2?" ":"\n"' temp1.fa > I09_ALL_HLII_CNS.csv
rm temp*.fa

#sed '/^>/!{s/[^ATCG]/-/g;}' I09_ALL_HLII_CNS.fa > temp0.fa
#awk '/^>/ {gsub(/.fa(sta)?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' *.fasta > I09_ALL_HLII_CNS.fa
sed '/^>/!{s/A/1/g; s/T/2/g; s/C/3/g ; s/G/4/g; s/[^1-4]/0/g; }' I09_ALL_HLII_CNS.fa > temp0.fa
sed '/^>/!{s/[0-4]/,&/g; s/,$//; }' temp0.fa > temp1.fa
awk 'ORS=NR%2?" ":"\n"' temp1.fa > I09_ALL_HLII_CNS_numeric.csv
rm temp*.fa

awk '/^>/ {gsub(/.fa(sta)?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' *.fasta > ALL_HLII_CNS.fa
sed '/^>/!{s/A/1/g; s/T/2/g; s/C/3/g ; s/G/4/g; s/[^1-4]/0/g; }' ALL_HLII_CNS.fa > temp0.fa
sed '/^>/!{s/[0-4]/,&/g; s/,$//; }' temp0.fa > temp1.fa
awk 'ORS=NR%2?" ":"\n"' temp1.fa > ALL_HLII_CNS_numeric.csv
rm temp*.fa

conda env list
conda activate SNP_analysis
conda deactivate
conda update --update-all


#Test Scripts

bowtie2-build HLII_ref.fa REF_DB
bowtie2-build I09_cns.fasta I09_cns_REF

bowtie2-build HLII_ref_plussurround.fa REF_DB_PL

bowtie2-build HLII_MIT9322.fa REF_MIT9322

bowtie2-build HLII_ref_plussurround_new.fa REF_DB_NEW


bowtie2 --threads 4 \
            -x REF_DB_NEW \
            -f Pro_HLII_rpoC1_ERR598942.fa \
            --no-unal \
            -S FRC_ERR598942.sam \
            --local -D 15 -R 2 -L 15 -N 1 --gbar 1 --mp 3
            

bowtie2 --threads 4 \
            -x REF_MIT9322 \
            -f Pro_HLII_rpoC1_ERR598942.fa \
            --no-unal \
            -S ERR598942.sam \
            --local -D 15 -R 2 -L 9 -N 1 --gbar 1 --mp 2,1
            
                        
bowtie2 --threads 4 \
            -x REF_MIT9322 \
            -f Pro_HLII_rpoC1_ERR598972.fa \
            --no-unal \
            -S ERR598972.sam \
            --local -D 15 -R 2 -L 9 -N 1 --gbar 1 --mp 2,1