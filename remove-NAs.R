### Load Packages
library(data.table)

### create a vector with trait names, as they are named for files
f <- c("A", "B", "C", "D", "E")


### create a for loop that reads in the sumstat file, removes NAs, then outputs the cleaned file
for (i in 1:length(f)){
old <- read.table(file = paste("/munge_sumstats/",f[i],".sumstats.gz",sep=""), sep = '', fill = TRUE, header = TRUE)
new <- na.omit(old)
write.table(new,paste("/gnova_sumstats/",f[i],".sumstats.txt",sep=""),quote=FALSE,sep="\t",col.names=TRUE,row.names=FALSE)
}
