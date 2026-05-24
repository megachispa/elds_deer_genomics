#!/bin/bash
#SBATCH --job-name=top_island_genes
#SBATCH --output=top_island_genes_%j.out
#SBATCH --error=top_island_genes_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

# Activate conda
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

# Input annotation
GFF=/mnt/tank/scratch/ebarabanova/annotation/gemoma_output/final_annotation.gff

# Detect genes overlapping the top 10 ROH islands

bedtools intersect \
-a genes.gff \
-b roh_islands_top10.bed \
> top_roh_island_genes.gff

# Count genes per ROH island

bedtools intersect \
-a roh_islands_top10.bed \
-b top_roh_island_genes.gff \
-c > selected_islands_gene_counts.txt

# Create detailed island-gene overlap table

bedtools intersect \
-a roh_islands_top10.bed \
-b genes.gff \
-wa -wb \
> top_roh_island_gene_overlap.txt

# Extract unique GeMoMa gene IDs

awk '$3=="gene"' top_roh_island_genes.gff | \
grep -o 'ID=[^;]*' | \
cut -d= -f2 | \
sort -u > roh_island_gene_ids.txt

# Extract full annotation entries for overlapping genes

grep -Fwf roh_island_gene_ids.txt "$GFF" \
> top_roh_gene_annotation.gff

echo "Top ROH island gene annotation complete."
