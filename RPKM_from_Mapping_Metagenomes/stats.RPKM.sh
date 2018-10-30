#!/bin/bash
#############################################################################################
#Script to obtain all statics from mappings
#Dependencies: STATS.RPKM.R
#Author Arturo Vera
#############################################################################################
scripts='/home/veraponcedeleon.1/scripts/RPKM_from_Mapping_Metagenomes'
workdir=$(pwd);
echo "Parsing RPKM Tables";
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
