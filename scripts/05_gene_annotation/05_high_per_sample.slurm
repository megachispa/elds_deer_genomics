#!/bin/bash
#SBATCH --job-name=high_impact_counts
#SBATCH --output=high_impact_counts%j.out
#SBATCH --error=high_impact_counts_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

VCF=high_impact_genomewide.vcf.gz

echo -e "Sample\tHIGH_TOTAL\tHIGH_HOM\tHIGH_HET" \
> high_impact_per_sample.tsv

for sample in $(bcftools query -l "$VCF")
do
    HET=$(bcftools query -s "$sample" -f '[%GT\n]' "$VCF" |
        awk '$1=="0/1" || $1=="1/0" || $1=="0|1" || $1=="1|0" {c++}
             END{print c+0}')

    HOM=$(bcftools query -s "$sample" -f '[%GT\n]' "$VCF" |
        awk '$1=="1/1" || $1=="1|1" {c++}
             END{print c+0}')

    TOTAL=$((HET + HOM))

    echo -e "${sample}\t${TOTAL}\t${HOM}\t${HET}" \
        >> high_impact_per_sample.tsv
done
