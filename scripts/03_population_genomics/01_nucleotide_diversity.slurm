#!/bin/bash
#SBATCH --job-name=pi_calc
#SBATCH --output=pi_calc_%j.out
#SBATCH --error=pi_calc_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/heterozygosity
cd "$WORKDIR" || exit 1

#Calculate π in windows

vcftools \
    --gzvcf /mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz \
    --window-pi 100000 \
    --out eld_pi_100kb

# Mean pi
MEAN_PI=$(awk 'NR>1 {sum+=$6; n++} END{print sum/n}' \
    eld_pi_100kb.windowed.pi)

# Median pi
MEDIAN_PI=$(awk 'NR>1 {print $6}' eld_pi_100kb.windowed.pi | sort -n | \
    awk '
    {
        a[NR]=$1
    }
    END{
        if (NR%2)
            print a[(NR+1)/2]
        else
            print (a[NR/2]+a[NR/2+1])/2
    }')

# Write summary
cat > pi_summary.txt << EOF
Mean_pi	${MEAN_PI}
Median_pi	${MEDIAN_PI}
EOF
