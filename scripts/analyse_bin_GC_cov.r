#!/usr/bin/env Rscript


args <- commandArgs(trailingOnly = TRUE)

file1 <- args[1]
file2 <- args[2]


rm(args)

library(MASS)

data1=read.table(file1)

######## Figure density plot ##############

pdf(file2, height=10,width=10)

density<-kde2d(data1$V2,data1$V1,n=100)

colour_flow <- colorRampPalette(c('white', 'blue', 'yellow', 'red', 'darkred'))
filled.contour(density, color.palette=colour_flow)

dev.off()
