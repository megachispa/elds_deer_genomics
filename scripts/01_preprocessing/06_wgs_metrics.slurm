#!/bin/bash
#SBATCH --job-name=wgsmetrics
#SBATCH --output=wgsmetrics_%j.out
#SBATCH --error=wgsmetrics_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

SAMPLE=$1

source /nfs/home/ebarabanova/miniconda3/etc/profile.d/conda.sh
conda activate /nfs/home/ebarabanova/miniconda3/envs/picard_new

REF=/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna

BAM_DIR=/mnt/tank/scratch/ebarabanova/marked_duplicates
OUT_DIR=/mnt/tank/scratch/ebarabanova/wgs_metrics

mkdir -p "$OUT_DIR"

java -jar /nfs/home/ebarabanova/miniconda3/envs/picard_new/share/picard-3.3.0-0/picard.jar CollectWgsMetrics \
    I="$BAM_DIR/${SAMPLE}.marked_duplicates.bam" \
    O="$OUT_DIR/${SAMPLE}.wgs_metrics.txt" \
    R="$REF"
