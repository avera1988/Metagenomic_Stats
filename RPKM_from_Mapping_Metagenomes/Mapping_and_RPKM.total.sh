#!/bin/bash
##########################################################################################################################
#Script for mapping and generate bam, stats, RPKM from genomes
#Author Arturo Vera
#October 2018
#Dependency:
#	Bowtie2, Samtools 1.5 or higher,Bedtools, cambia_seqs_unalinea.pl, adding.length.to.cds.pl,RPKM.R,STATS.RPKM.R
#
############################################################################################################################

if [ $# -eq 0 ]; then
        echo "usage: $0 <Genomes_suffix_fasta_files> <Read_1.fq> <Read_2.fq> <cpu> <path_to_Metagenomic_scripts>";
        exit 1;
        fi



dir=$5
workdir=$(pwd)
#If samtools, bedtools are not in PATH variable define here
#bin='/data/veraponcedeleon.1/bin/bin'
scripts=$5

term=$1
read1=$2
read2=$3
cpu=$4

echo "starting pipeline samtools at"
date
#Generating Bam using Bowtie2 and stats with samtools satats
for i in *$term
	do
        mkdir $i.dir
        cd $i.dir
        ln -s $workdir/$i .
        ln -s $workdir/$read1
        ln -s $workdir/$read2
        echo "indexing"
        bowtie2-build $i $i.index
        echo "bowtie2"
        time bowtie2 -p $cpu --very-sensitive -x $i.index -1 $read1 -2 $read2 -S $i.sam
        echo "samtools view"
        time $dir/samtools view -@ $cpu -bS $i.sam > $i.bam
        rm *.sam
        echo "haciendo stats"
        time $dir/samtools stats $i.bam > $i.bam.stats
        echo "mapeadas"
        time $dir/samtools view -@ $cpu -b -F 4 $i.bam > $i.mapped.bam
        echo "removing sam files"
        cd $workdir

done
echo "Finishing mapping"
echo "Obtaining Relative abundance from stats"
#Relative abundance from Stats
for i in *.dir ;
        do
        a=$(echo $i|cut -d . -f 1);
        echo $a;
        cat $i/*.stats|grep ^SN | cut -f 2- |grep -E 'raw total sequences|reads mapped:'; done|perl -e 'print "Genome\tTotal_mapped_reads\tPercentage\n",;while(<>){chomp;if($_ =~ /^PA/){$name=$_;}elsif($_ =~ /^raw/){@raw=split(/\t/,$_);}elsif($_ =~ /^reads/){@map=split(/\t/,$_); $p=$map[1]*100; $perc=$p/$raw[1]; print "$name\t$map[1]\t$perc\n";}}' > Relative_abundance.tab
echo "Sorting and Prodigal and Raw_counts and RPKM"
#Generating Raw counts with Bedtools multicov and RPKM with RPKM.R
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
echo "Parsing RPKM Tables";
#stats form RPKM
for i in *dir ;
        do
        a=$(echo $i|cut -d . -f1);
        cd $i;
        echo "STATS of " $a
        Rscript $scripts/STATS.RPKM.R
        mv rpkm.high.1000.tab $a.rpkm.high.1000.tab
        mv rpkm.high.900.tab $a.rpkm.high.900.tab
        cd $workdir
done
echo "finished at"
date

