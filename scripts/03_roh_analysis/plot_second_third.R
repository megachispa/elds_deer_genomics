library(ggplot2)

WORKDIR <- "/mnt/tank/scratch/ebarabanova/roh"
setwd(WORKDIR)

library(ggplot2)

#Plot second largest island

roh <- read.table(
  "second_island_rohs.txt",
  header = FALSE
)

plot_df <- data.frame(
  Individual = roh[,4],      # Column 4 is Individual
  Start = roh[,2] / 1e6,     # Column 2 is Start (convert to Mb)
  End = roh[,3] / 1e6,       # Column 3 is End (convert to Mb)
  Length = (roh[,3] - roh[,2]) / 1000  # Calculate Length in kb
)

plot_df <- plot_df[order(plot_df$Length, decreasing = TRUE), ]

plot_df$Individual <- factor(
  plot_df$Individual,
  levels = unique(plot_df$Individual)
)

p <- ggplot(
  plot_df,
  aes(
    x = Start,
    xend = End,
    y = Individual,
    yend = Individual
  )
) +
  geom_segment(linewidth = 2.5, color = "orange") +
  xlab("Position on scaffold (Mb)") +
  ylab("Individual") +
  ggtitle("Second largest ROH island across individuals") +
  theme_bw()

ggsave(
  "second_roh_island_plot.png",
  p,
  width = 9,
  height = 5,
  dpi = 300
)


#Plot third largest island

roh <- read.table(
  "third_island_rohs.txt",
  header = FALSE
)

plot_df <- data.frame(
  Individual = roh[,4],      # Column 4 is Individual
  Start = roh[,2] / 1e6,     # Column 2 is Start (convert to Mb)
  End = roh[,3] / 1e6,       # Column 3 is End (convert to Mb)
  Length = (roh[,3] - roh[,2]) / 1000  # Calculate Length in kb
)

plot_df <- plot_df[order(plot_df$Length, decreasing = TRUE), ]

plot_df$Individual <- factor(
  plot_df$Individual,
  levels = unique(plot_df$Individual)
)

p <- ggplot(
  plot_df,
  aes(
    x = Start,
    xend = End,
    y = Individual,
    yend = Individual
  )
) +
  geom_segment(linewidth = 2.5, color = "orange") +
  xlab("Position on scaffold (Mb)") +
  ylab("Individual") +
  ggtitle("Third largest ROH island across individuals") +
  theme_bw()

ggsave(
  "third_roh_island_plot.png",
  p,
  width = 9,
  height = 5,
  dpi = 300
)
