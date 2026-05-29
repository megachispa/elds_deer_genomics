#!/bin/bash
#SBATCH --job-name=density
#SBATCH --output=density_%j.out
#SBATCH --error=density_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

# initialize conda
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

# Merge overlapping genomic intervals

bedtools sort -i cds.bed | \
bedtools merge -i - > cds_merged.bed

bedtools sort -i genes.bed | \
bedtools merge -i - > genes_merged.bed

# Calculate genomic region lengths

GENE_LENGTH=$(awk '{sum += $3-$2} END {print sum}' genes_merged.bed)

CDS_LENGTH=$(awk '{sum += $3-$2} END {print sum}' cds_merged.bed)

INTRON_LENGTH=$((GENE_LENGTH - CDS_LENGTH))

GENOME_LENGTH=$(awk '
!/^>/ {sum += length($0)}
END {print sum}
' /nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna)

INTERGENIC_LENGTH=$((GENOME_LENGTH - GENE_LENGTH))

# Count variants in each category

VAR_TOTAL=$(wc -l < variants.bed)

VAR_IN_GENES=$(wc -l < variants_in_genes.bed)

VAR_IN_CDS=$(wc -l < variants_in_cds.bed)

VAR_IN_INTRONS=$((VAR_IN_GENES - VAR_IN_CDS))

VAR_INTERGENIC=$(wc -l < variants_outside_genes.bed)

# Calculate SNP densities (SNPs/Mb)

DENS_IN_GENES=$(echo "scale=2; $VAR_IN_GENES / ($GENE_LENGTH / 1000000)" | bc)

DENS_IN_CDS=$(echo "scale=2; $VAR_IN_CDS / ($CDS_LENGTH / 1000000)" | bc)

DENS_IN_INTRONS=$(echo "scale=2; $VAR_IN_INTRONS / ($INTRON_LENGTH / 1000000)" | bc)

DENS_INTERGENIC=$(echo "scale=2; $VAR_INTERGENIC / ($INTERGENIC_LENGTH / 1000000)" | bc)

DENS_GENOME=$(echo "scale=2; $VAR_TOTAL / ($GENOME_LENGTH / 1000000)" | bc)


# Create summary table - densities only

cat <<EOF > snp_density_table.txt
Region	SNPs_per_Mb
CDS	$DENS_IN_CDS
Introns	$DENS_IN_INTRONS
Genic_regions	$DENS_IN_GENES
Intergenic_regions	$DENS_INTERGENIC
Genome-wide	$DENS_GENOME
EOF

echo "SNP density calculations complete."
