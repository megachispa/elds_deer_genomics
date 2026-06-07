#!/bin/bash
#SBATCH --job-name=flagstat
#SBATCH --output=flagstat_%j.out
#SBATCH --error=flagstat_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G

SAMPLE=$1

BAM_DIR=/mnt/tank/scratch/ebarabanova/marked_duplicates
OUT_DIR=/mnt/tank/scratch/ebarabanova/flagstat_reports

mkdir -p "$OUT_DIR"

samtools flagstat \
    "$BAM_DIR/${SAMPLE}.marked_duplicates.bam" \
    > "$OUT_DIR/${SAMPLE}.flagstat.txt"
