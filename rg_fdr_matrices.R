### load necessary packages
library(tidyr)
library(reshape2)
library(ggplot2)

### read in rg results table
df <- read.table("/rg_results/rg_table.txt", header = TRUE)

### create dataframe with results columns relevant to creating the heat map
results <- df[,1:6]
### calculate q value so that we can use FDR to assess significance
results$q <- p.adjust(results$p, method = "fdr")

#################################################
########## RG CORRELATION MATRIX TABLE ##########
#################################################

### Create df with just traits and genetic correlation results
r_res <- results[,1:3]
### Since we didn't run repeat jobs, Trait A is missing from column p2 and Trait E is missing from column p1
### We have to insert dummy data so that these traits are considered factor levels in both columns
r_comp <- rbind(data.frame(p1 = "A", p2 = "A", rg = 1), r_res, data.frame(p1 = "E", p2 = "E", rg = 1))

### spread rg data into matrix
r_spread <- spread(r_comp, p2, rg)
### create row names
r_spread1 <- r_spread[,-1]
rownames(r_spread1) <- r_spread[,1]
### reorder columns and rows so that matrix can be symmetrical
phenos <- as.character(r_comp$p1)
col.order <- unique(phenos)
r_colorder <- r_spread1[,col.order]
r_df <- r_colorder[col.order,]

### flip upper triangle onto lower triangle
r_df[lower.tri(r_df)] <- t(r_df)[lower.tri(r_df)]
### replace diagonal NAs with 1
r_df[is.na(r_df)] <- 1

### save as csv table
write.csv(r_df, file="/rg_results/rg_matrix.csv", row.names = TRUE)


#################################################
############### FDR MATRIX TABLE ################
#################################################

### create dataframe with just traits and FDR q values
q_res <- results[,1:7]
q_res[,3:6] <- NULL
### add row to top and bottom so that all traits are factor levels
q_comp <- rbind(data.frame(p1 = "A", p2 = "A", q = 1), q_res, data.frame(p1 = "E", p2 = "E", q = 1))

### spread rg data into matrix
q_spread <- spread(q_comp, p2, q)
### create row names
q_spread1 <- q_spread[,-1]
rownames(q_spread1) <- q_spread[,1]
### reorder columns and rows so that matrix can be symmetrical
q_colorder <- q_spread1[,col.order]
q_df <- q_colorder[col.order,]

### flip upper triangle onto lower triangle
q_df[lower.tri(q_df)] <- t(q_df)[lower.tri(q_df)]
### replace diagonal NAs with 1 (don't need to test significance of these, so just make large for later use)
q_df[is.na(q_df)] <- 1

write.csv(q_df, file="/rg_results/fdr_matrix.csv", row.names = TRUE)
