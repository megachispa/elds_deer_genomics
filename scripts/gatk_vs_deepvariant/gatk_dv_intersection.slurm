#!/bin/bash
#SBATCH --job-name=vcf_compare
#SBATCH --output=vcf_compare_%j.out
#SBATCH --error=vcf_compare_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

set -euo pipefail

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

REF=/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna

GATK_IN=/mnt/tank/scratch/ebarabanova/vcf_filtering_qc/filtered_vcfs/geno20Filtered.vcf.gz
DV_IN=/mnt/tank/scratch/tsizova/vcf/filtered/SNPs_only.recode.vcf.gz

OUTDIR=isec_output
mkdir -p "$OUTDIR"

########################################
# 1. Normalize both datasets
########################################

echo "Normalizing VCFs..."

bcftools norm -m-any -f "$REF" "$GATK_IN" -Oz -o gatk.norm.vcf.gz
bcftools norm -m-any -f "$REF" "$DV_IN"   -Oz -o dv.norm.vcf.gz

########################################
# 2. SNP + biallelic filtering
########################################

echo "Filtering SNPs and biallelic sites..."

bcftools view -v snps -m2 -M2 gatk.norm.vcf.gz -Oz -o gatk.snps.bi.vcf.gz
bcftools view -v snps -m2 -M2 dv.norm.vcf.gz   -Oz -o dv.snps.bi.vcf.gz

########################################
# 3. Missingness filtering (consistent)
########################################

echo "Applying missingness filter..."

vcftools --gzvcf gatk.snps.bi.vcf.gz \
         --max-missing 0.8 \
         --recode --recode-INFO-all \
         --stdout | bgzip -c > gatk.final.vcf.gz

vcftools --gzvcf dv.snps.bi.vcf.gz \
         --max-missing 0.8 \
         --recode --recode-INFO-all \
         --stdout | bgzip -c > dv.final.vcf.gz

tabix -p vcf gatk.final.vcf.gz
tabix -p vcf dv.final.vcf.gz

########################################
# 4. Index
########################################

bcftools index gatk.final.vcf.gz
bcftools index dv.final.vcf.gz

A=gatk.final.vcf.gz
B=dv.final.vcf.gz

########################################
# 5. Intersection
########################################

echo "Running intersection..."

rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

bcftools isec -p "$OUTDIR" "$A" "$B"

PRIVATE_A=$OUTDIR/0000.vcf
PRIVATE_B=$OUTDIR/0001.vcf
SHARED=$OUTDIR/0002.vcf

########################################
# 6. Statistics
########################################

echo "Computing statistics..."

count_A=$(bcftools view -H "$A" | wc -l)
count_B=$(bcftools view -H "$B" | wc -l)
count_shared=$(bcftools view -H "$SHARED" | wc -l)
count_private_A=$(bcftools view -H "$PRIVATE_A" | wc -l)
count_private_B=$(bcftools view -H "$PRIVATE_B" | wc -l)

jaccard=$(echo "scale=5; $count_shared / ($count_A + $count_B - $count_shared)" | bc)

private_prop_A=$(echo "scale=5; $count_private_A / $count_A" | bc)
private_prop_B=$(echo "scale=5; $count_private_B / $count_B" | bc)

shared_prop_A=$(echo "scale=5; $count_shared / $count_A" | bc)
shared_prop_B=$(echo "scale=5; $count_shared / $count_B" | bc)

tstv_A=$(bcftools stats "$A" | grep ^TSTV | awk '{print $5}')
tstv_B=$(bcftools stats "$B" | grep ^TSTV | awk '{print $5}')
tstv_shared=$(bcftools stats "$SHARED" | grep ^TSTV | awk '{print $5}')

########################################
# 7. Report
########################################

REPORT=vcf_comparison_report.txt

{
echo "VCF comparison report"
echo "====================="
echo "Run date: $(date)"
echo ""
echo "Total variants:"
echo "GATK: $count_A"
echo "DeepVariant: $count_B"
echo ""
echo "Intersection:"
echo "Shared: $count_shared"
echo "Jaccard: $jaccard"
echo ""
echo "Private:"
echo "GATK private: $count_private_A"
echo "DeepVariant private: $count_private_B"
echo ""
echo "Proportions:"
echo "GATK shared: $shared_prop_A"
echo "DeepVariant shared: $shared_prop_B"
echo ""
echo "Ts/Tv:"
echo "GATK: $tstv_A"
echo "DeepVariant: $tstv_B"
echo "Shared: $tstv_shared"
} > "$REPORT"

echo "Done. Report saved to $REPORT"
