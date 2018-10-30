#!/usr/bin/perl -w

####################################################################################
#Script for parsing gff after bed and cds for FPKM in metagenomics		   #
#Author Arturo Vera								   #
#October 2018									   #
#It needs the cds file from Prodigal and the bed file from bedtools multicov	   #
#										   #
####################################################################################

($cds,$bed)=@ARGV;
open (CDS,$cds);
open (BED, $bed);
open (PARS1, '>cds.pars.tab');
open (PARS2, '>bed_counts.tab');
$cds_pars='cds.pars.tab';
$bed_pars='bed_counts.tab';
open (TMP1, $cds_pars);
open (TMP2, $bed_pars);
open (FINAL, '>counts_to_rpkm.tab');

print "Starting cds and bed Parsing\n";
#Parsing cds from genome to generate cds_pars.tab with ID and length
while(<CDS>){
	chomp;
	if($_ =~ /^>/){
	@header=split(/\s+/, $_);
	@id=grep(/^ID/, @header);
	#print "$id[0]\n";
	foreach($id[0]){
		@gene=split(/\;/);
	}
	#print "$gene[0]\n"; 
  }else{
	$len=length($_);
	print PARS1 "$gene[0]\t$len\n";
  }
}
close(CDS);
close(PARS1);
#Parsing coverage and read counts ID and counts
while(<BED>){
	chomp;
	@col=split(/\t/, $_);
	@id_1=grep(/^ID/, @col);
	#print "$id_1[0]\n";
	foreach($id_1[0]){
	@gene_1=split(/\;/);
	}
	print PARS2 "$gene_1[0]\t$col[-1]\n";
}
close(PARS2);
close(BED);
while(<TMP1>){
	chomp;
	($id_tmp,$l)=split(/\t/);
	$fil{$id_tmp}=$l;
}
print FINAL "gene_ID\tlength\tcounts\n";
while(<TMP2>){
	chomp;
	($id_tmp2,$counts)=split(/\t/);
	if(exists $fil{$id_tmp2}){
	     print FINAL "$id_tmp2\t$fil{$id_tmp2}\t$counts\n";
	}
}

print "Finishing\n";
close(TMP1);
close(TMP2);
close(FINAL);








