# Analyze Movement by Raspberry Pi
# Avalon Owens & Jacob Dayton


#Please try the following in R/4.0.0:
#MAKE SURE THE LOAD R-INTERACTIVE SESSION WITH BELOW MODULES
#imagemagick/7.1.0 R/4.0.0 libpng


LIB = '/cluster/tufts/hpc/tools/R/4.0.0'
LIB2 = '/cluster/tufts/dopmanlab/Jacob/packages_r_4.0.0/'
.libPaths(c("",LIB, LIB2)) #adds specific directories to .libPath

#Load required packages
library(imager)
#library(tidyverse)
library(tibble)
library(reshape2)
library(dplyr)
library(plyr)
library(lubridate)
library(readr)
library(stringr)
library(plotrix)

setwd("/cluster/tufts/dopmanlabpi/iLAM_Onub_fhlbnd_202308/")

#read in iLAM functions
for (f in list.files("../scripts", pattern="*.R",
                     full.names = TRUE)) {
  source(f)
}

###
#change following values for every cage
pi_sub_folder <- "p1"
sex <- "unknown" #cage/project-specific
x_left <- 400 #cage-specific, depending on camera arrangement
x_right <- 2200 #cage-specific, depending on camera arrangement
y_bot <- 0 #cage-specific, depending on camera arrangement
y_top <- 1800 #cage-specific, depending on camera arrangement

#change following values for every experiment
#for ECB, I like 99.9% and 10, I think
out_file_name = "Onub_fhlbnd_202308" #project-specific
n_thr = 0.999 #species-specific, depending on IR reflectance/contrast with background
n_cln = 10 #species-specific, depending on IR reflectance
n_max = 75000 #species-specific, pixel differences above this value will be considered as noise
start_photophase = 2 #project-specific
end_photophase = 18 #project-specific
genus = "ostrinia"
species = "nubilalis"
animal = "white"
###
#creates a vector of .jpg image file names
file_names <- list.files(pi_sub_folder,
                         pattern= "*.jpg",
                         full.names = TRUE)[500:550]

#finds all movements by image subtraction, global thresholding, and blob detection
system.time({
out <- find_movements(files = file_names, # list of file names 
                      n_thr = n_thr,      # threshold value (0.992 == "0.8%")
                      n_cln = n_cln,      # value for cleaning (number of pixels)
                      n_grw = 1.5,      # multiplier for n_cln (shrink vs. grow)
                      n_blr = 3,          # let user select blur radius?
                      n_max = 75000,      # upper cut-off for # pixel differences
                      x_left = x_left,    # value for crop on x min
                      x_right = x_right,  # value for crop on x max
                      y_bot = y_bot,      # value for crop on y min
                      y_top = y_top,      # value for crop on y max
                      find_thr = T, # make this part optional? ***
                      type_thr = "absolute",
                      p_sample = 0.75,    # percent of images to sample ***
                      channel = "grayscale",
                      animal = "white")
})

#adds additional columns to dataframe
out$ID <- paste0(n_thr*100,"%_", "s", n_cln, "g", 1.5*n_cln)
out$sex <- sex
out$genus <- genus
out$species <- species

#saves output containing all identified blobs, their size and location, into .csv in current wd
if (file.exists(paste0(out_file_name,".csv"))){
  write.table(out, file = paste0(out_file_name,".csv"),
              append = TRUE, quote = TRUE, sep = ",",
              row.names = FALSE, col.names = FALSE)
} else{
  write.csv(out, file = paste0(out_file_name,".csv"),
            col.names = TRUE, row.names = FALSE)
  
}
rm(out)

#parses output .csv 
by_change <- parse_movements(file_mvmnts = paste0(out_file_name,".csv"),
                             start_photophase = start_photophase,
                             end_photophase = end_photophase)

#plots a detected blobs onto a subset of images
#circles in bottom left corner denote standards of sizes: 12.8k px, 3.2k px, 800 px, 200 px, 50 px
plot_movements(pi_sub_folder,
               by_change,
               x_left, x_right,
               y_bot, y_top)

# Make a gif from plotted image jpegs
# make_gif(out_file_name,
#          pi_sub_folder)
