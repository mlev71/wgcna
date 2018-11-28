#!/usr/bin/env Rscript

library(optparse)

option_list = list(
  make_option(
    c("-i", "--input"),
    type="character",
    default=NULL,
    metavar="input"
  ),

  make_option(
    c("-p", "--plot_name"),
    type="character",
    default=NULL,
    metavar="plot_name"
  ),

   make_option(
      c("--power"),
      type="integer",
      default=NULL,
      metavar="power"

   )

)

opt <- parse_args(OptionParser(option_list=option_list))

if(is.null(opt$input)|is.null(opt$plot_name)){
 stop("Usage: Rscript wgcna_dendrogram.R -i <input_expression_data> -o <plot_name>") 
}

if(!file.exists(opt$input)){
 stop("Usage: Rscript wgcna_dendrogram.R -i <input_expression_data> -o <plot_name>") 
}


raw_counts <- read.table(opt$input)

#WARNING: REMOVE INPRODUCTION (filter because I'm impatient)
raw_counts <- raw_counts[1:1000,]

# normalze counts
log_rpkm <- t(edgeR::cpm.default(raw_counts, log= TRUE))

# enable threads for calculations
WGCNA::allowWGCNAThreads()

# calculate a soft threshold
#powers = c(c(1:10), seq(from = 12, to=20, by=2))
#log_sft = WGCNA::pickSoftThreshold( log_rpkm, 
#                                   dataIsExpr = TRUE,
#                                   RsquaredCut = 0.8,
#                                   powerVector = powers, 
#                                   #corOptions = list(use='p', method='spearman'),
#                                   verbose = 5, 
#                                   networkType = "signed"
#                                   )


# calculate adjacency matrix

print("Computing Adjacency Matrix")

adjacency = WGCNA::adjacency(
  log_rpkm,
  #corOptions = list(use = 'p', method= 'spearman'),
  type="signed", 
  power = opt$power
)


# calculate similarity TOM
print("Computing TOM")
TOM <- WGCNA::TOMsimilarity(adjacency, 
                            TOMType = "signed", 
                            suppressTOMForZeroAdjacencies=TRUE
)


# remove old objects no longer used in pipelin
rm(adjacency, log_rpkm)

# average linkage hierarchical clustering was used to group genes based on their topological overlap
print("Computing Dendrogram")
geneTree= hclust(as.dist(1-TOM), method="average")


print("Cutting Dendrogram")
dynamicMods = dynamicTreeCut::cutreeDynamic(
                           geneTree,
                            distM = 1-TOM,
                            minClusterSize = 100,
                            cutHeight = 0.999
                            #deepSplit = FALSE
                            )
assigned_colors = WGCNA::labels2colors(dynamicMods)


print("Plotting Dendrogram")

png(
  filename = paste(opt$plot_name, '.png', sep="" )
    )


WGCNA::plotDendroAndColors(geneTree, assigned_colors,
                           dendroLabels = FALSE, hang = 0.03,
                           addGuide = TRUE, guideHang = 0.05
                           )
 

dev.off()
