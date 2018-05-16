#! /usr/bin/env Rscript

library(readr)
library(ggplot2)

# get command line arguments as an array
# args <- commandArgs(trailingOnly = TRUE)

# files
# filein <- args[1]
# fileout <- args[2]
filein <- snakemake@input[[1]]
fileout <- snakemake@output[[1]]

# http://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#external-scripts
# In the R script, an S4 object named snakemake analog to the Python case
# above is available and allows access to input and output files and other
# parameters. Here the syntax follows that of S4 classes with attributes
# that are R lists, e.g. we can access the first input file with snakemake@input[[1]]


# data
data <- read_tsv(filein, col_names=c('qlen', 'slen'))

p <- ggplot(data, aes(x=qlen/slen)) + 
		geom_histogram(bins=50) +
		xlab('query len / hit len') +
		ylab('frequency') +
		scale_y_log10()


# breaks
# bks <- seq(0,max(data$V1/data$V2)+1,by=0.05)

# main hist
# png(fileout, width=800, height=800, type='cairo')
# hist(data$V1/data$V2, breaks=bks, col='red', xlim=c(0,2), xlab='query len / hit len', ylab='frequency', main=filein)
# dev.off() 

# scaled hist
# fileout <- gsub('.png','.500.png', fileout)
# png(fileout, width=800, height=800, type='cairo')
# hist(data$V1/data$V2, ylim=c(0,500), breaks=bks, col='purple', xlim=c(0,2), xlab='query len / hit len', ylab='frequency', main=filein)
# dev.off()

ggsave(fileout, p, height=10, width=10, units='cm')