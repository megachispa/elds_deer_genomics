#!/bin/bash
#SBATCH --job-name=markdup
#SBATCH --output=markdup_%j.out
#SBATCH --error=markdup_%j.err
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

SAMPLE=$1

source /nfs/home/ebarabanova/miniconda3/etc/profile.d/conda.sh

conda activate /nfs/home/ebarabanova/miniconda3/envs/picard_new

BAM_DIR=/mnt/tank/scratch/ebarabanova/deer_bam_files
OUT_DIR=/mnt/tank/scratch/ebarabanova/marked_duplicates

mkdir -p "$OUT_DIR"

java -jar /nfs/home/ebarabanova/miniconda3/envs/picard_new/share/picard-3.3.0-0/picard.jar MarkDuplicates \
    I="$BAM_DIR/${SAMPLE}.bam" \
    O="$OUT_DIR/${SAMPLE}.marked_duplicates.bam" \
    M="$OUT_DIR/${SAMPLE}.marked_dup_metrics.txt"
