#!/bin/bash
#SBATCH --job-name=heterozygosity
#SBATCH --output=heterozygosity_%j.out
#SBATCH --error=heterozygosity_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

set -euo pipefail

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

VCF=/mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz

REFERENCE=/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna.fai

OUTDIR=/mnt/tank/scratch/ebarabanova/heterozygosity
mkdir -p "$OUTDIR"

echo "Running vcftools heterozygosity calculation..."

vcftools \
    --gzvcf "$VCF" \
    --het \
    --out "$OUTDIR/heterozygosity"

########################################
# Genome size (bp)
########################################

GENOME_BP=$(awk '{sum+=$2} END{print sum}' "$REFERENCE")

echo "Genome size (bp): $GENOME_BP"

########################################
# Calculate observed heterozygosity
########################################

awk -v GENOME="$GENOME_BP" '
BEGIN{
    OFS="\t"
    print "INDV","O_HOM","N_SITES","O_HET","HET_PER_BP","HET_PERCENT"
}
NR>1{
    O_HOM=$2
    N_SITES=$4

    O_HET=N_SITES-O_HOM

    HET=O_HET/GENOME

    print $1,
          O_HOM,
          N_SITES,
          O_HET,
          HET,
          HET*100
}
' "$OUTDIR/heterozygosity.het" \
> "$OUTDIR/heterozygosity_per_bp.tsv"

echo "Results written to:"
echo "$OUTDIR/heterozygosity_per_bp.tsv"
