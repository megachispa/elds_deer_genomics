#!/bin/bash
#SBATCH --job-name=invsout
#SBATCH --output=invsout_%j.out
#SBATCH --error=invsout_%j.err
#SBATCH --time=01:00:00          # adjust depending on file sizes
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# initialize conda and activate the environment where bedtools are installed
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

VCF=/mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz
GFF=/mnt/tank/scratch/ebarabanova/annotation/gemoma_output/final_annotation.gff

#Convert the VCF to BED format
zcat "$VCF" | 
 grep -v "^#" | awk '{print $1"\t"$2-1"\t"$2}' > variants.bed

# Count total SNPs
wc -l < variants.bed > total_snps.txt

#Extract gene coordinates from the GFF
grep -P "\tgene\t" "$GFF" > genes.gff

#Convert to BED:
awk '$3=="gene" {print $1"\t"$4-1"\t"$5}' genes.gff > genes.bed

#Count variants inside genes

bedtools intersect -a variants.bed -b genes.bed > variants_in_genes.bed
wc -l < variants_in_genes.bed > variants_in_genes.txt

#Count variants outside genes

bedtools intersect -a variants.bed -b genes.bed -v > variants_outside_genes.bed
wc -l < variants_outside_genes.bed > variants_outside_genes.txt


#Count variants specifically in CDS (coding regions)
# Extract CDS from your GFF
grep -P "\tCDS\t" "$GFF"  > cds.gff
#Convert to BED:
awk '$3=="CDS" {print $1"\t"$4-1"\t"$5}' cds.gff > cds.bed

#Count variants inside CDS

bedtools intersect -a variants.bed -b cds.bed > variants_in_cds.bed
wc -l < variants_in_cds.bed > variants_in_cds.txt


# Calculate intronic SNPs
GENIC=$(cat variants_in_genes.txt)
CDS=$(cat variants_in_cds.txt)

INTRONIC=$((GENIC - CDS))

echo $INTRONIC > variants_in_introns.txt

#Create a summary table and caluculate percentages

GENIC=$(cat variants_in_genes.txt)
CDS=$(cat variants_in_cds.txt)
INTRONIC=$(cat variants_in_introns.txt)
INTERGENIC=$(cat variants_outside_genes.txt)
TOTAL=$(cat total_snps.txt)

printf "Region\tSNPs\tPercent\n" > snp_summary_table.tsv

printf "CDS\t%d\t%.2f%%\n" \
$CDS $(awk "BEGIN {print ($CDS/$TOTAL)*100}") \
>> snp_summary_table.tsv

printf "Introns\t%d\t%.2f%%\n" \
$INTRONIC $(awk "BEGIN {print ($INTRONIC/$TOTAL)*100}") \
>> snp_summary_table.tsv

printf "Genic regions\t%d\t%.2f%%\n" \
$GENIC $(awk "BEGIN {print ($GENIC/$TOTAL)*100}") \
>> snp_summary_table.tsv

printf "Intergenic regions\t%d\t%.2f%%\n" \
$INTERGENIC $(awk "BEGIN {print ($INTERGENIC/$TOTAL)*100}") \
>> snp_summary_table.tsv

printf "Total SNPs\t%d\t100%%\n" \
$TOTAL \
>> snp_summary_table.tsv
