library(plyr)
library(dplyr)
library(pheatmap)
library(ggplot2)
library(plotly)
library(vegan)
library(viridis)


#read CSV file containing list of sample/species names
specieslist = read.csv("specieslist.csv", header = F)
numberofspecies = nrow(specieslist)

#read kallisto output files as a list
abundancelist = paste0("abundance", 1:numberofspecies, ".tsv")
abundancefiles = lapply(abundancelist, read.delim)

#read InterProScan output files as a list
annotationlist = paste0("annotation", 1:numberofspecies, ".tsv")
annotationfiles = lapply(annotationlist, read.delim, header=F)



#Part A

for (i in seq(1:numberofspecies)) {
  
  justGeneGo<-annotationfiles[[i]][,c(1,14)]
  justGeneTPM<-abundancefiles[[i]][,c(1,5)]
  
  #empty character vectors
  go_id=character()
  gene_id=character()

  #collect all GO terms associated with each scaffold
  go_split <- strsplit(as.character(justGeneGo[,2]), "|", fixed = TRUE)
  
  Data <- data.frame(
    go_id = unlist(go_split),
    gene_id = rep(justGeneGo[,1], lengths(go_split)),
    stringsAsFactors = FALSE
  )
  
  go_id = as.factor(go_id)
  Data = data.frame(go_id, gene_id)
  
  #remove tail end of transcript label
  a<-gsub("(.*)_.*","\\1",Data$gene_id)
  Data$gene_id <- a
  
  colnames(Data)[colnames(Data)=="gene_id"] <- "target_id"
  Data2 = merge(Data, justGeneTPM)
  #just GO and TPM
  Data2 <- Data2[c(2,3)]
  #sum TPM values
  Data2 = ddply(Data2, "go_id", numcolwise(sum))

  Data3 = Data2
  
  colnames(Data3)[colnames(Data3)=="tpm"] <- as.character(specieslist[i,1])
  #label
  Data2$species <- specieslist[i,]

  if (i==1) {
    #initialize data
    new2 = Data3
    new = Data2
  }
  else {
    #combine all data
    new2 = merge.data.frame(new2, Data3, all = TRUE)
    new = rbind(new, Data2)
  }
  rm(a, eachgene, eachgo, gene, go, gene_id, go_id, simple_counter, justGeneGo, justGeneTPM, Data, Data2, Data3)
}

#table of pooled GO terms per species
save(new, new2, file = "go.RData")
#clean environment
load("go.RData")

new$tpm <- signif(new$tpm, 4)

#preview plot
ggplot(new, aes(species, go_id)) +
  geom_point(aes(color = go_id, size = tpm), alpha = 0.3, show.legend = FALSE) +
  theme_classic() +
  labs(title = "Derived GO term distributions across species", x = "Species", y = "GO") +
  scale_fill_gradientn(colours = rainbow(nrow(new2))) +
  theme(axis.text.y=element_blank(), axis.ticks.y=element_blank())

#plot of pooled GO terms per species
p1 = plot_ly(x = new$species, y = new$go_id, type = "scattergl", mode = "markers", color = new$species, size = new$tpm, fill = ~'', colors = "Spectral")
p1 <- p1 %>% layout(title = "InterProScan x kallisto",
                    xaxis = list(title = "Species"),
                    yaxis = list(title = "GO", showticklabels = FALSE),
                    showlegend = FALSE)
#color by species
p1 <- partial_bundle(p1)
p1


p2 = plot_ly(x = new$species, y = new$go_id, type = "scattergl", mode = "markers", color = new$species, size = new$tpm, fill = ~'', colors = "Spectral")
p2 <- p2 %>% layout(title = "InterProScan x kallisto",
                    xaxis = list(title = "Species", showticklabels = FALSE),
                    yaxis = list(title = "GO", showticklabels = FALSE))
#color by species
p2 <- partial_bundle(p2)
p2


p3 = plot_ly(x = new$species, y = new$go_id, type = "scattergl", mode = "markers", color = new$go_id, size = new$tpm, fill = ~'', colors = viridis(nrow(new2), direction = -1))
p3 <- p3 %>% layout(title = "InterProScan x kallisto",
                    xaxis = list(title = "Species"),
                    yaxis = list(title = "GO", showticklabels = FALSE),
                    showlegend = FALSE)
#color by annotation
p3 <- partial_bundle(p3)
p3



#Part B

#clean environment
load("go.RData")

uniqueGO = setNames(
  lapply(names(new2[,-1]), \(x)
         filter(new2, if_all(setdiff(names(new2[,-1]), x), ~is.na(.)))),
  names(new2[,-1]))

for (i in seq(1:numberofspecies)) {
  #remove NA columns
  uniqueGO[[i]] <- uniqueGO[[i]][,c(1,1+i)]
}

#unique GO terms per species with pooled TPM
#cycle species by changing the number within double brackets
uniqueGO[[1]]

#to generate output files
ssannotations <- list()
ssisoforms <- list()
sstranscripts <- list()

for (i in seq(1:numberofspecies)) {
  
  trinity = c()
  
  for (j in seq(1:dim(uniqueGO[[i]])[1])) {
    a1 = uniqueGO[[i]][j,1]
    #grab first unique GO term entry
    a2 = grepl(a1, annotationfiles[[i]]$V14)
    #locate position of unique GO term
    a3 = which(a2)
    #extract transcript ID
    a4 = as.character(annotationfiles[[i]][a3,1])
    #build data frame of transcripts with unique GO terms
    trinity = c(trinity, a4)
  }
  
  annotation = uniqueGO[[i]][,1]
  annotation = as.data.frame(annotation)
  #label species
  colnames(annotation) = specieslist[i,]

  trinity = as.data.frame(trinity)
  #label species
  colnames(trinity) = specieslist[i,]
  #remove tail end of transcript label
  clean <- gsub("(.*)_.*","\\1",trinity[,1])
  trinity[,1] <- clean
  #unique transcripts
  trinity = unique(trinity)
  
  #make a copy
  trinity2 = trinity
  #remove isoform tag
  clean2 <- gsub("(.*)_.*","\\1",trinity2[,1])
  trinity2[,1] <- clean2
  #unique isoforms
  trinity2 = unique(trinity2)
  
  #create a list of annotations and transcripts for each species
  ssannotations[specieslist[i,]] <- list(annotation)
  ssisoforms[specieslist[i,]] <- list(trinity)
  sstranscripts[specieslist[i,]] <- list(trinity2)
  
  
  rm(a1, a2, a3, a4, clean, clean2, annotation, trinity, trinity2)
}


#species-specific information
#cycle species by changing the number within double brackets

#unique GO terms
ssannotations[[1]]

#transcript isoforms with unique GO terms
ssisoforms[[1]]

#source genes of transcript isoforms with unique GO terms
sstranscripts[[1]]


#set working directory to new folder

#save
for (i in seq(1:numberofspecies)) {
  #species-specific GO terms
  write.table(ssannotations[[i]], file = paste0(specieslist[i,], "_go.txt"), col.names = FALSE)
  #species-specific transcript isoforms
  write.table(ssisoforms[[i]], file = paste0(specieslist[i,], "_i.txt"), col.names = FALSE)
  #species-specific genes
  write.table(sstranscripts[[i]], file = paste0(specieslist[i,], "_g.txt"), col.names = FALSE)
}



#Part C

#clean environment
load("go.RData")

#1
#cluster by species
new3 = new2
rownames(new3) = new3[,1]
new3 = new3[,-1]
pheatmap(new3, scale = "row", treeheight_row = 0, cluster_cols = TRUE, cluster_rows = FALSE, show_rownames = FALSE, na_col = "black")

#2
#cluster by species and annotation
new3 = new2
rownames(new3) = new3[,1]
new3 = new3[,-1]
#only complete cases
new3 = new3[complete.cases(new3), ]
pheatmap(new3, scale = "row", treeheight_row = 0, cluster_cols = TRUE, cluster_rows = TRUE, show_rownames = FALSE)

#3
#cluster by species
new3 = new2
rownames(new3) = new3[,1]
new3 = new3[,-1]
#set NA to 0
new3[is.na(new3)] = 0
#calculate distance matrix
d = vegdist(t(new3), method = "bray")
#cluster
hc = hclust(d, method = "average")
order = hc$labels[hc$order]
#build visualization matrix separately
new4 = new2
rownames(new4) = new4[,1]
new4 = new4[,-1]
#reorder columns using clustering
new4 = new4[, order]
#plot NA values as NA
pheatmap(new4, scale = "row", treeheight_row = 0, cluster_cols = FALSE, cluster_rows = FALSE, show_rownames = FALSE, na_col = "black")
