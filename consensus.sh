#1) Map short reads against reference gene sequence
# Create bowtie2 database
bowtie2-build REFERENCE.fasta REF_DB

# bowtie2 mapping
bowtie2 -x REF_DB -U SAMPLE.fastq --no-unal -S SAMPLE.sam

# samtools:  sort .sam file and convert to .bam file
samtools view -bS SAMPLE.sam | samtools sort - -o SAMPLE.bam

#2) Get consensus sequence from .bam file
# Get consensus fastq file
samtools mpileup -uf REFERENCE.fasta SAMPLE.bam | bcftools call -c | vcfutils.pl vcf2fq > SAMPLE_cns.fastq

# vcfutils.pl is part of bcftools
# Convert .fastq to .fasta and set bases of quality lower than 20 to N
seqtk seq -aQ64 -q20 -n N SAMPLE_cns.fastq > SAMPLE_cns.fasta