#!/bin/bash
#SBATCH --job-name=top
#SBATCH --output=top_%j.out
#SBATCH --error=top_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

sort -k5,5nr -k4,4nr \
/mnt/tank/scratch/ebarabanova/roh/roh_islands_final.txt | \
head -n 10 | \
awk 'BEGIN{OFS="\t"}{
print $1,$2,$3,"ROH_island_"NR,$4,$5
}' > roh_islands_top10.bed
