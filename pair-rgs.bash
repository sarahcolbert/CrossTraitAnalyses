#!/bin/bash

#SBATCH --job-name=pair-rgs
#SBATCH --time=00:30:00
#SBATCH --nodes=1-1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --qos=preemptable
#SBATCH --mem=10gb
#SBATCH --output=pair-rgs.out
#SBATCH --error=pair-rgs.err
#SBATCH --array=1-4,7-9,13-14,19 # only jobs that aren't repeated pairs

# Select which traits to process, based on array ID
firsttraits=(A B C D E)
secondtraits=(A B C D E)


job_id=$SLURM_ARRAY_TASK_ID
for i in {0..4}; do
    if [[ "$i" = "$job_id" ]]; then
       firsttrait=${firsttraits[0]}
        secondtrait=${secondtraits[$job_id]}
        break
    fi
done
for i in {5..9}; do
    if [[ "$i" = "$job_id" ]]; then
        firsttrait=${firsttraits[1]}
        secondtrait=${secondtraits[$(( $job_id - 5 ))]}
        break
    fi
done
for i in {10..14}; do
    if [[ "$i" = "$job_id" ]]; then
        firsttrait=${firsttraits[2]}
        secondtrait=${secondtraits[$(( $job_id - 10 ))]}
        break
    fi
done
for i in {15..19}; do
    if [[ "$i" = "$job_id" ]]; then
        firsttrait=${firsttraits[3]}
        secondtrait=${secondtraits[$(( $job_id - 15 ))]}
        break
    fi
done

# Inputs -----------------------------------------------------------------------
in_dir=/munged_sumstats/
ld_score_dir=/directory/with/ld/score/files/
# ------------------------------------------------------------------------------

# Outputs ----------------------------------------------------------------------
out_dir=/rg_results/
if [ ! -d $out_dir ]; then
    mkdir -p $out_dir
fi
# ------------------------------------------------------------------------------


# Run LDSC regression
python 2.7 ldsc.py \
--rg ${in_dir}${firsttrait}.sumstats.gz,${in_dir}${secondtrait}.sumstats.gz \
--ref-ld-chr ${ld_score_dir}eur_w_ld_chr/ \
--w-ld-chr ${ld_score_dir}eur_w_ld_chr/ \
--print-coefficients \
--out ${out_dir}${firsttrait}_${secondtrait}_rg
