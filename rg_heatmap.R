### import rg results and fdr q values
r_df <- read.csv("/rg_results/rg_matrix.csv", header = TRUE, row.names = 1)
q_df <- read.csv("/rg_results/fdr_matrix.csv", header = TRUE, row.names = 1)


### Convert r dataframe to matrix
r_mat <- as.matrix(r_df)
### Replace values out of bounds with 1
r_mat[r_mat > 1] <- 1
r_mat[r_mat < -1] <- -1
### melt matrices into df
melted_r <- melt(r_mat)
melted_r$value <- as.numeric(as.character(melted_r$value))

fdr <- as.matrix(q_df)

#########################################
############# MAKE HEAT MAP #############
#########################################

### Assign statistical significance ###
y <- as.vector(fdr) ### vector of p-values
y <- replace(y, y<0.05, "*")
y <- replace(y, y>0.05, "")

### Create heat map ###
pdf("/rg_results/rg_heatmap.pdf", width = 10, height = 10)
ggplot(data = melted_r, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile(color = "white") + ### creates lines inbetween squares
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", ### change colors
                       midpoint = 0, limit = c(-1,1), space = "Lab", name = "Correlation Coefficient") + ### name legend
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                   size = 10, hjust = 1)) + ### make axis labels readable
  coord_fixed() + ### keeps all blocks same size
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +  ### remove axis titles
  geom_text(aes(label=y))
dev.off()
