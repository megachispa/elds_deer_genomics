library(ggplot2)

WORKDIR <- "/mnt/tank/scratch/ebarabanova/var_in_genes"
setwd(WORKDIR)

# Read the data
dat <- read.table(
    "stop_gained_summary_named_roh.tsv",
    header = FALSE,
    sep = "\t",
    stringsAsFactors = FALSE
)

# Assign column names
colnames(dat) <- c(
    "N_HOM_ALT", "CHROM", "POS", "GENE_ID",
    "CONSEQUENCE", "PROTEIN", "GENE_NAME", "ROH"
)

# ---- Remove the unwanted "IN_ROH" caption row ----
dat <- dat[dat$ROH != "IN_ROH", ]

# Count variants by sharing level (N_HOM_ALT) and ROH status (YES/NO)
counts <- as.data.frame(table(dat$N_HOM_ALT, dat$ROH))
colnames(counts) <- c("N_HOM_ALT", "ROH", "N_VARIANTS")

# Create the plot
ggplot(counts,
       aes(x = factor(N_HOM_ALT),
           y = N_VARIANTS,
           fill = ROH)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(
        values = c(
            "YES" = "#cc6600",   # darker = inside ROH
            "NO"  = "#fdb863"    # lighter = outside ROH
        ),
        name = "In ROH?"         # legend title
    ) +
    labs(
        x = "Number of individuals",
        y = "Number of stop-gained variants",
        title = "Sharing of homozygous stop-gained variants"
    ) +
    theme_bw()

# Save the plot
ggsave(
    "stop_gained_roh_stacked.png",
    width = 8,
    height = 5,
    dpi = 300
)
