library(ggplot2)
library(reshape2)

WORKDIR <- "/mnt/tank/scratch/ebarabanova/roh"
setwd(WORKDIR)

# read matrix
mat <- read.table("exact_overlap_matrix.tsv", header=TRUE, row.names=1)

# convert to long format
mat_long <- melt(as.matrix(mat))

colnames(mat_long) <- c("Deer1","Deer2","Shared_ROH_Mb")

# plot heatmap
p <- ggplot(mat_long, aes(x=Deer1, y=Deer2, fill=Shared_ROH_Mb)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white", high="red") +
  theme_minimal() +
  labs(fill="Shared ROH (Mb)",
       x="Individual",
       y="Individual") +
  theme(axis.text.x = element_text(angle=45, hjust=1))

# display
p

# save figure
ggsave("roh_shared_heatmap.png", p, width=6, height=5, dpi=300)
