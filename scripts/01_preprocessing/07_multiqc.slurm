#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --output=multiqc_%j.out
#SBATCH --error=multiqc_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate qc

OUTDIR=/mnt/tank/scratch/ebarabanova/multiqc_alignment_qc

mkdir -p "$OUTDIR"

multiqc \
    /mnt/tank/scratch/ebarabanova/flagstat_reports \
    /mnt/tank/scratch/ebarabanova/wgs_metrics \
    --outdir "$OUTDIR"
