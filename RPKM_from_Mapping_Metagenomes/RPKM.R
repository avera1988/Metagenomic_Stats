#########################################################################
#Script to obtain RPKM from raw metagenomic counts
#Autor Arturo Vera
#Obtober 2018
#It needs the cds.bed.raw_counts.tab from adding.length.to.cds.pl
#########################################################################


raw_counts <- read.table("counts_to_rpkm.tab",sep="\t",header=TRUE)
countToRpkm <- function(counts, Len){
    N <- sum(counts)
    exp( log(counts) + log(1e9) - log(Len) - log(N) )
}
countDf <- data.frame(count=raw_counts$counts, length=raw_counts$length)
countDf$rpkm <- with(countDf, countToRpkm(count,length))
rownames(countDf) <- raw_counts$gene_ID
write.table(countDf,"ccounts.rpkm.tab", sep="\t", quote=F)
avegRpkm <- sum(countDf$rpkm)/dim(countDf)[1]
sum_mil <- sum(countDf$rpkm)/1000000
print (c("Average RPKM", avegRpkm))
print (c("Total RPKM/1e6", sum_mil))

