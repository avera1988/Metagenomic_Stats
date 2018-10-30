#!/bin/bash

dir=/data/veraponcedeleon.1/bin/bin
dir_idba='/data/veraponcedeleon.1/bin/idba-master/bin'
workdir=$(pwd)

term=$1
read1=$2
read2=$3
cpu=$4

echo "starting pipeline samtools at"
date 

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
for i in *.dir ; 
	do 
	a=$(echo $i|cut -d . -f 1);
	echo $a; 
	cat $i/*.stats|grep ^SN | cut -f 2- |grep -E 'raw total sequences|reads mapped:'; done|perl -e 'print "Genome\tTotal_mapped_reads\tPercentage\n",;while(<>){chomp;if($_ =~ /^B/){$name=$_;}elsif($_ =~ /^raw/){@raw=split(/\t/,$_);}elsif($_ =~ /^reads/){@map=split(/\t/,$_); $p=$map[1]*100; $perc=$p/$raw[1]; print "$name\t$map[1]\t$perc\n";}}' > Relative_abundance.tab
echo "finished at"
date
