remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

setwd("/Users/harrocyranka/Desktop/")
source("/Users/harrocyranka/Desktop/code/twitter_info_analysis_3.R")
source("/Users/harrocyranka/Desktop/code/estimate_audience.R")
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")

p <- estimate_audience("sesamestreet")