library(ggplot2)
library(ggrepel)

pca <- read.table(
  "/mnt/tank/scratch/ebarabanova/heterozygosity/elds_deer_pca.eigenvec",
  header=FALSE
)

colnames(pca) <- c(
  "FID", "IID",
  "PC1", "PC2", "PC3", "PC4", "PC5",
  "PC6", "PC7", "PC8"
)

plot <- ggplot(pca, aes(x=PC1, y=PC2, label=IID)) +
  geom_point(size=4) +
  ggrepel::geom_text_repel() +
  theme_bw() +
  labs(
    title="PCA of Eld's Deer Individuals",
    x="PC1",
    y="PC2"
  )

print(plot)

# Save figure

ggsave(
  "elds_deer_PCA.png",
  plot=plot,
  width=7,
  height=5,
  dpi=300
)
