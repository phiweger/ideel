#! /usr/bin/env Rscript

# library(readr)
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
# data <- read_tsv(filein, col_names=c('qlen', 'slen'))
data <- read.table(filein, header=FALSE, sep='\t')
names(data) <- c('qlen', 'slen')


pseudogenes <- sum(data$qlen / data$slen < 0.9)
print(paste0('Encountered genes < 0.9 reference length: ', pseudogenes))


theme_min = function (
    size=10, font=NA, face='plain', 
    panelColor=backgroundColor, axisColor='#999999', 
    gridColor=gridLinesColor, textColor='black') 
{   
theme_text = function(...)
    ggplot2::theme_text(family=font, face=face, colour=textColor, size=size, ...)

opts(
    axis.text.x = theme_text(),
    axis.text.y = theme_text(),
    #axis.line = theme_blank(),
    axis.ticks = theme_segment(colour=axisColor, size=0.25),
    
    panel.border = theme_rect(colour=backgroundColor),
    # panel.border = theme_blank(),

    legend.background = theme_blank(),
    legend.key = theme_blank(),
    legend.key.size = unit(1.5, 'lines'),
    legend.text = theme_text(hjust=0),
    legend.title = theme_text(hjust=0),
    
    # panel.background = theme_rect(fill=panelColor, colour=NA),
    panel.background = element_blank(),

    # panel.grid.major = theme_line(colour=gridColor, size=0.33),
    panel.grid.major = element_blank(),
    
    # panel.grid.minor = theme_blank(),
    panel.grid.minor = element_blank(),

    strip.background = theme_rect(fill=NA, colour=NA),
    strip.text.x = theme_text(hjust=0),
    strip.text.y = theme_text(angle=-90),
    plot.title = theme_text(hjust=0),
    plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), 'lines'))
}


p <- ggplot(data, aes(x=qlen/slen)) + 
		geom_histogram(fill='white', color='grey25', bins=20) +
		xlab('query length / hit length') +
		ylab('frequency') +
		# scale_y_log10() +
        scale_x_continuous(limits=c(0, 1.3)) +
        theme_minimal()



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

ggsave(fileout, p, height=7, width=7, units='cm')

