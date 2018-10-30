#!/bin/bash

#############################################################################################################################
# This script Sort and idex a bam files from mapping; also predict CDS with Prodigal and calculates RPKM for each gene
#Dependencies : Samtools 1.5 or higher; bedtools; prodigal; cambia_seqs_unalinea.pl; adding.length.toc.ds.pl, RPKM.R
#Author Arturo Vera
#October 2018
##############################################################################################################################

if [ $# -eq 0 ]; then
        echo "usage: $0 ./sam.sort.prodigal.bed.sh cpu";
        exit 1;
        fi

workdir=$(pwd)
bin='/data/veraponcedeleon.1/bin/bin'
scripts='/home/veraponcedeleon.1/scripts'
cpu=$1

echo "Starting sorting bed covering at:";
date
for i in *.dir ;
	do
	a=$(echo $i|sed 's/.dir//g');
	cd $i
	echo "Sorting"
	time $bin/samtools sort -@ $cpu $a.bam > $a.bam.sorted
	echo "Indexing"
	time $bin/samtools index -@ $cpu -b $a.bam.sorted > $a.bam.sorted.bai	
	echo "Running Prodigal"
	prodigal -a $a.protein.faa -d $a.cds.fna -o $a.prodigal.gff -f gff -i $a
	echo "Bed covering"	
	bedtools multicov -bams $a.bam.sorted -bed $a.prodigal.gff > $a.bed
	echo "Merging and parsing tables for Raw Counts"
	$scripts/cambia_seqs_unalinea.pl $a.cds.fna > $a.cds.fna.one	
	$scripts/adding.length.to.cds.pl $a.cds.fna.one $a.bed
	echo "Obtaining RPKM from" $a	
	Rscript $scripts/RPKM.R
	cd $workdir
done
	

	


		
	
