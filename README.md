# prochlorococcus_phylogeography
Global scale phylogeography of functional traits and microdiversity in Prochlorococcus

# Code for CH.2 publication

Identify rpoC1 reads from metagenomes using anvi'o
- 01_anvio_script.sh

Calculate consensus sequence for each sample of the *rpoC1* gene using samtools, bowtie2, and bcftools.
- 02_rpoC1_consensus.sh

Create metagenome assembled geonomes (MAGs) using spades, bowtie2, samtools, metabat2, and checkm
- 03.1_mags_assembly.sh
- 03.2_mags_binning.sh

## Citations
- **Anvi'o**: Eren AM, Esen OC, Quince C, Vineis JH, Morrison HG, Sogin ML, et al. Anvi’o: An advanced analysis and visualization platform for ’omics data. PeerJ. 2015;3.
- **bowtie2**: Langmead B, Salzberg SL. Fast gapped-read alignment with Bowtie 2. Nat Methods. 2012;9:357–9.
- **samtools** / **bcftools**: Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, et al. The Sequence Alignment/Map format and SAMtools. Bioinformatics. 2009;25:2078–9.
- **spades**: Bankevich A, Nurk S, Antipov D, Gurevich AA, Dvorkin M, Kulikov AS, et al. SPAdes: A New Genome Assembly Algorithm and Its Applications to Single-Cell Sequencing. Journal of Computational Biology. 2012 May;19(5):455–77.
- **metabat2**: Kang DD, Li F, Kirton E, Thomas A, Egan R, An H, et al. MetaBAT 2: an adaptive binning algorithm for robust and efficient genome reconstruction from metagenome assemblies. PeerJ. 2019 Jul 26;7:e7359.
- **checkm**: Parks DH, Imelfort M, Skennerton CT, Hugenholtz P, Tyson GW. CheckM: assessing the quality of microbial genomes recovered from isolates, single cells, and metagenomes. Genome Res. 2015 Jul;25(7):1043–55.