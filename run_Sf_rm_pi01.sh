#!/bin/bash
#SBATCH -J rm_pi01 #job name
#SBATCH --time=0-14:00:00 
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=12g
#SBATCH --output=rm_pi01.%j.out
#SBATCH --error=rm_pi01.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jacob.dayton@tufts.edu
#SBATCH --constraint=rhel7

module load R/4.0.0
module load imagemagick/7.1.0

Rscript --no-save Sfrug_rm_pi01.R
