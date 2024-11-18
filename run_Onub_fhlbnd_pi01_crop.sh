#!/bin/bash
#SBATCH -J Onub_fhlbnd_pi01 #job name
#SBATCH --time=0-12:00:00 
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=10g
#SBATCH --output=Onub_fhlbnd_pi01_crop.%j.out
#SBATCH --error=Onub_fhlbnd_pi01_crop.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jacob.dayton@tufts.edu

module load imagemagick/7.1.0 R/4.0.0 libpng

Rscript --no-save Onub_fhlbnd_pi01_crop.R
