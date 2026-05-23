#!/bin/bash
#SBATCH --job-name=roh_stats
#SBATCH --output=roh_stats_%j.out
#SBATCH --error=roh_stats_%j.err
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G

set -euo pipefail

WORKDIR=/mnt/tank/scratch/ebarabanova/roh
cd "$WORKDIR"

INPUT=roh_islands_final.txt
OUTPUT=roh_island_statistics.tsv

########################################
# Calculate statistics
########################################

TOTAL=$(wc -l < "$INPUT")

MEAN_LEN=$(awk '{sum+=$5} END{printf "%.2f", sum/NR}' "$INPUT")

MEDIAN_LEN=$(awk '{print $5}' "$INPUT" | sort -n | awk '
{
a[NR]=$1
}
END{
if(NR%2){
print a[(NR+1)/2]
}
else{
print (a[NR/2] + a[NR/2+1]) / 2
}
}')

MAX_LEN=$(awk 'BEGIN{max=0} {if($5>max) max=$5} END{print max}' "$INPUT")

MEAN_FREQ=$(awk '{sum+=$4} END{printf "%.3f", sum/NR}' "$INPUT")

MAX_FREQ=$(awk 'BEGIN{max=0} {if($4>max) max=$4} END{print max}' "$INPUT")

GT1MB=$(awk '$5>=1' "$INPUT" | wc -l)

########################################
# Write summary table
########################################

echo -e "Statistic\tValue" > "$OUTPUT"

echo -e "Total ROH islands\t$TOTAL" >> "$OUTPUT"
echo -e "Mean ROH length (Mb)\t$MEAN_LEN" >> "$OUTPUT"
echo -e "Median ROH length (Mb)\t$MEDIAN_LEN" >> "$OUTPUT"
echo -e "Maximum ROH length (Mb)\t$MAX_LEN" >> "$OUTPUT"
echo -e "Mean ROH frequency\t$MEAN_FREQ" >> "$OUTPUT"
echo -e "Maximum ROH frequency\t$MAX_FREQ" >> "$OUTPUT"
echo -e "ROH islands > 1 Mb\t$GT1MB" >> "$OUTPUT"

echo "ROH island statistics complete."
