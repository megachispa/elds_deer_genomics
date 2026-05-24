#!/bin/bash
set -euo pipefail

SNPEFF_HOME=/nfs/home/ebarabanova/miniconda3_new/envs/snpeff_env/share/snpeff-5.4.0c-0
GENOME=deer

mkdir -p "$SNPEFF_HOME/data/$GENOME"

# Copy genome FASTA
cp -f /nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna \
   "$SNPEFF_HOME/data/$GENOME/sequences.fa"

# Copy annotation GFF3
cp -f /mnt/tank/scratch/ebarabanova/annotation/gemoma_output/final_annotation.gff \
   "$SNPEFF_HOME/data/$GENOME/genes.gff"

# Register genome in config (if not already there)
grep -q "deer.genome" "$SNPEFF_HOME/snpEff.config" || \
echo "deer.genome : Elds_deer" >> "$SNPEFF_HOME/snpEff.config"
