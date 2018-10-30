#!/bin/bash

scripts='/home/veraponcedeleon.1/scripts'
workdir=$(pwd);
echo "Parsing RPKM Tables";
for i in *dir ; 
	do 
	a=$(echo $i|cut -d . -f1);
	cd $i; 
	echo "Sum of " $a
	Rscript $scripts/sum.R;
	perl -e '($tabla,$id)=@ARGV; open(TABLA,$tabla); print "genid\tcount\tlength\trpkm\tgenome\n";while(<TABLA>){chomp;if($_ =~ /^ID/){@col=split(/\t/); print "$col[0]\t$col[1]\t$col[2]\t$col[3]\t$id\n";}}close(TABLA);' rpkm.high.900.tab $a > $a.rpkm.high.900.tab;
	perl -e '($tabla,$id)=@ARGV; open(TABLA,$tabla); print "genid\tcount\tlength\trpkm\tgenome\n";while(<TABLA>){chomp;if($_ =~ /^ID/){@col=split(/\t/); print "$col[0]\t$col[1]\t$col[2]\t$col[3]\t$id\n";}}close(TABLA);' rpkm.high.1000.tab $a > $a.rpkm.high.1000.tab;  
	cd $workdir ; 
done
