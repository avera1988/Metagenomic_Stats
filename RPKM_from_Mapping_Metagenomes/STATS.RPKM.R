###############################################################################
#Script for obtain statistics from RPKM tables
#Author Arturo Vera
#October 2018
#It needs the ccounts.rpkm.tab
############################################################################### 

pk <- read.table("ccounts.rpkm.tab", header=T, sep="\t", row.names=1)
#Parsing Tables and obtainign genes greather than 900 and 1000 bp
pk_thou <- subset(pk, pk$length >= 1000 & pk$rpkm > 0)
pk_nine <- subset(pk, pk$length >= 900 & pk$rpkm > 0)
#some Stats
suma_thou <- sum(pk_thou$rpkm)/1000000
suma_nine <- sum(pk_nine$rpkm)/1000000
average_thou <- mean(pk_thou$rpkm)
average_nine <- mean(pk_nine$rpkm)
SEM_thou <- sd(pk_thou$rpkm)/sqrt(length(pk_thou$rpkm))
SEM_nine <- sd(pk_thou$rpkm)/sqrt(length(pk_thou$rpkm))
#Function for abundance acording to https://www.nature.com/articles/ncomms3151#s1 RNum_Gi=Num_Gi/∑i=1nNum_Gi
abundance <- function(RPKM){
	N <- sum(RPKM)
	exp(log(RPKM) - log(N))
}

#obtaing abundance from parsed tables
pk_thou$abundance <- with(pk_thou, abundance(pk_thou$rpkm))
sum_abundanceThou <- sum(pk_thou$abundance)
meanAbundanceThou <- mean(pk_thou$abundance)
porcienMeanAbundanceTho <- 100*mean(pk_thou$abundance)
pk_nine$abundance <- with(pk_nine, abundance(pk_nine$rpkm))
sum_abundanceNine <- sum(pk_nine$abundance)
meanAbundanceNine <- mean(pk_nine$abundance)
porcienMeanAbundanceNine <- 100*mean(pk_nine$abundance)
#Stats
SD_thou <- sd(pk_thou$rpkm)
SD_nine <- sd(pk_nine$rpkm)
SEM_thou <- SD_thou/sqrt(length(pk_thou$rpkm))
SEM_nine <- SD_nine/sqrt(length(pk_nine$rpkm))

STATS <- data.frame(suma_thou,suma_nine,average_thou,average_nine,sum_abundanceThou,sum_abundanceNine,meanAbundanceThou,meanAbundanceNine,porcienMeanAbundanceTho,porcienMeanAbundanceNine)

#Printing Results
print (c("Number of genes RPKM >0 > 1000 nt",dim(pk_thou)[1]))
print (c("Number of genes RPKM >0 > 900 nt",dim(pk_nine)[1]))
print (c("Mean RPKM_1000 +/- SEM", average_thou, SEM_thou))
print (c("Mean RPKM_900 +/- SEM", average_nine, SEM_nine))
print(str(STATS))
write.table(pk_thou, "rpkm.high.1000.tab", sep="\t", quote=F)
write.table(pk_nine, "rpkm.high.900.tab", sep="\t", quote=F)
