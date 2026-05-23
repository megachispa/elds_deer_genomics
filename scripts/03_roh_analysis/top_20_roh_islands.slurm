#!/bin/bash
#SBATCH --job-name=top
#SBATCH --output=top_%j.out
#SBATCH --error=top_%j.err
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

WORKDIR=/mnt/tank/scratch/ebarabanova/roh
cd "$WORKDIR"

echo -e "Rank\tScaffold\tStart\tEnd\tFrequency\tLength_Mb" \
> top20_roh_islands.txt

sort -k5,5nr roh_islands_final.txt | \
head -n 20 | \
awk '{
printf "%d\t%s\t%s\t%s\t%.3f\t%.2f\n",
NR, $1, $2, $3, $4, $5
}' >> top20_roh_islands.txt

echo "Top 20 ROH islands written to:"
echo "top20_roh_islands.txt"
