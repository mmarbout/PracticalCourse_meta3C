#!/usr/bin/env Rscript


args <- commandArgs(trailingOnly = TRUE)

#input1
file1 <- args[1]
#input2
file2 <- args[2]
#input3
file3 <- args[3]
#fig1
file4 <- args[4]
#fig2
file5 <- args[5]
#fig3
file6 <- args[6]
#fig4
file7 <- args[7]

d1=read.table(file1)
d2=read.table(file2)
d3=read.table(file3)

######## Figure pie chart of MAGs repartition ##############

slices_labels <- round(d1$V1/sum(d1$V1) * 100, 1)
slices_labels <- paste(slices_labels, "%", sep="")

colors <- c("darkorchid4","blue4","blue3","blue2","blue1","darkslategray3","darkslategray1","orange","grey")

pdf(file4, height=10,width=10)
pie(d1$V1, main = "MAGs quality repartition in size", col=colors,labels=slices_labels, cex=0.8)
legend(.8, .2, c("compl>90;conta<5","compl>90;conta<10","compl>80;conta<10","compl>70;conta<10","compl>60;conta<10","compl>50;conta<10","compl<50;conta<10","NA;conta>10","other bins"), cex = 0.7, fill = colors)
dev.off()

######## Figure barplot of MAGs quality ##############

pdf(file5, height=10,width=10)
barplot(d2$V3,col="darkolivegreen3",main = "MAGs quality completion and contamination",)
points(d2$V4,col="coral",pch=20)
dev.off()

######### Figure coverage and GC boxplot ##################

bindata=read.table(file2)
contigdata=read.table(file3)

colnames(bindata) <- c("bin ID", "Marker lineage", "Completeness", "Contamination", "Bin size")
colnames(contigdata) <- c("Contig ID", "Size", "Coverage", "GC%", "bin ID", "bin size")

bindata <- bindata[order(bindata[,1]),]
mycolors <- ifelse(bindata$Completeness >= 90 & bindata$Contamination <= 10, "darkolivegreen4", 
				ifelse(bindata$Completeness >= 70 & bindata$Completeness < 90 & bindata$Contamination <= 10 ,"darkolivegreen3",
					ifelse(bindata$Completeness >= 50 & bindata$Completeness < 70 & bindata$Contamination <= 10 ,"darkolivegreen2", 
						ifelse(bindata$Completeness < 50 & bindata$Contamination <= 10 ,"darkolivegreen1", 
							ifelse(bindata$Contamination < 20 & bindata$Contamination > 10 ,"coral",  
								ifelse(bindata$Contamination < 50 & bindata$Contamination > 20 ,"brown1", 
									ifelse(bindata$Contamination > 50 ,"brown3","grey")))))))

pdf(file6, height=10,width=10)
boxplot(log(contigdata$`Coverage`)~contigdata$`bin ID`,
        xlab = "Bin ID",
        ylab = "log(coverage)", 
        main = "coverage distribution among MAGs", 
        outline=F, 
        col=mycolors)
legend(x=10, y = 10, legend=c(">90;<10", ">70;<10", ">50;<10", "<50;<10", "10<conta<20",  "20<conta<50",  "50<conta"), 
      pch=15, col=c("darkolivegreen4","darkolivegreen3", "darkolivegreen2", "darkolivegreen1","coral","brown1","brown3"), cex = 0.7, title = "completion/contamination")
dev.off()

pdf(file7, height=10,width=10)
boxplot(contigdata$`GC%`~contigdata$`bin ID`,
        xlab = "Bin ID",
        ylab = "GC content", 
        main = "GC content distribution among MAGs",
        outline=F, 
        col=mycolors)
legend(x=10, y =10,
      legend=c(">90;<10", ">70;<10", ">50;<10", "<50;<10", "10<conta<20",  "20<conta<50",  "50<conta"), 
      pch=15, col=c("darkolivegreen4","darkolivegreen3", "darkolivegreen2", "darkolivegreen1","coral","brown1","brown3"), cex = 0.7, title = "completion/contamination")
dev.off()
