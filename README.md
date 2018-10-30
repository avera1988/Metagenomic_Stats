# Metagenomic_Stats

-This repository contains all scripts and commands to obtain statistics of mapped metagenomic reads to reference genomes.

*Dependecies

    Samtools 1.5 or higher https://github.com/samtools/samtools
    Bowtie2 http://bowtie-bio.sourceforge.net/bowtie2/index.shtml
    Bedtools https://bedtools.readthedocs.io/en/latest/
    Prodigal https://github.com/hyattpd/Prodigal

The main script Mapping_and_RPKM.total.sh runs Bowtie2 for indexing and mapping metagenomic reads to a reference genome. It produces all sorted and idexed BAM files for basic Stats calculations with Samtools stats command. gff and CDS files are predicted with Prodigal. It uses CDS and gff for RPKM calculation obtaining the counts (mapped reads) for each CDS wiht multicov from Bedtools.

        For running in a directory with fasta files from Refence genome and reads (paired) from metagenomes type:
        ./Mapping_and_RPKM.total.sh <Genomes_suffix_fasta_files> <Read_1.fq> <Read_2.fq> <cpu> <path_to_Metagenomic_scripts>
 
    
    


