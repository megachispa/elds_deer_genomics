#!/bin/bash
#SBATCH --job-name=haplotypecaller
#SBATCH --output=haplotypecaller_%j.out
#SBATCH --error=haplotypecaller_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

SAMPLE=$1

export PATH=/mnt/tank/scratch/ebarabanova/gatk_tools:$PATH

REF=/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna
BAM_DIR=/mnt/tank/scratch/ebarabanova/marked_duplicates
OUT_DIR=/mnt/tank/scratch/ebarabanova/gatk_output

mkdir -p "$OUT_DIR"

gatk --java-options "-Xmx4G" HaplotypeCaller \
    -R "$REF" \
    -I "$BAM_DIR/${SAMPLE}.marked_duplicates.bam" \
    -O "$OUT_DIR/${SAMPLE}.g.vcf" \
    -ERC GVCF
