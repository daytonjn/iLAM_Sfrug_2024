LIB = '/cluster/tufts/hpc/tools/R/4.0.0'
LIB2 = '/cluster/tufts/dopmanlab/Jacob/packages_r_4.0.0/'
.libPaths(c("",LIB, LIB2)) #adds specific directories to .libPath

library('magick')
library('imager')
library('devtools')
library('withr')
library('curl')

withr::with_libpaths(new = "/cluster/tufts/dopmanlab/Jacob/packages_r_4.0.0/",
              devtools::install_github("iLAMtools/iLAMtools", force=TRUE))

install.packages("imager", lib='/cluster/tufts/dopmanlab/Jacob/packages_r_4.0.0/')
library(magick, lib.loc = '/cluster/tufts/hpc/tools/R/4.0.0')
devtools::install_github("iLAMtools/iLAMtools", force=TRUE)