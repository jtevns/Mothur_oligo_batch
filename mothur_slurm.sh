#!/bin/bash
#SBATCH --job-name=zip-temp
#SBATCH --nodes=1
#SBATCH --cpus-per-task=36
#SBATCH --mem=180g
#SBATCH --time=5-36:00:00
#SBATCH --account=vdenef1
#SBATCH --partition=standard
#SBATCH --mail-user=jtevans@umich.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL

#  Show list of CPUs you ran on, if you're running under PBS
echo $SLURM_JOB_NODELIST

#  Change to the directory you submitted from
if [ -n "$SLURM_SUBMIT_DIR" ]; then cd $SLURM_SUBMIT_DIR; fi
pwd

source ~/.bashrc
module load Bioinformatics mothur ncbi-blast
conda activate /nfs/turbo/lsa-dudelabs/conda_envs/miniconda/envs/oligotyping/

#run mothur with oligotyping
mothur /nfs/turbo/lsa-dudelabs/pipelines/Mothur_oligo_batch/mothur.batch.taxass

#run mothur without oligotyping
# mothur /nfs/turbo/lsa-dudelabs/pipelines/Mothur_oligo_batch/mothur.batch.taxass.no_oligo:

