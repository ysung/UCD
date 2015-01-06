setwd("/Users/sung/Desktop/Research")

library(ggplot2)
library(reshape2)
library(RColorBrewer)
source("CommentGraph.R")
filenames = list.files(path = "./data", pattern = ".csv")
files = lapply(1:length(filenames), function(x) read_data(filenames[x]))

# experiment


for(i in 1:length(files)) {
  results = CommentGraph$new(rawdata = files[[i]], filename = filenames[i])
  results$chiHeatmap(50, 10, m = 5, c = 1, out.w = 7, out.h = 5)
  #results$simpleGraph()
}







# normalized data func
# experiment
# ouptut graph function, directory and files
# with the same xlim and ylim
# ML skill to see pattern


# sumdiff = sapply(seq(1, nrow(cross.table), 2), function(x)
# sum(cross.table[x, 6:11])/sum(cross.table[x, ]) - sum(cross.table[(x+1), 6:11])/sum(cross.table[(x+1), ])
# )
# plot(sumdiff)
# total = sapply(seq(1, nrow(cross.table), 2), function(x)
#   sum(cross.table[x, ], cross.table[(x+1), ])
# )
# sumdiff_t = matrix(sumdiff, nrow = 500, ncol = 30)
# sumdiff.m = melt(sumdiff_t)
# names(sumdiff.m)
# ggplot(sumdiff.m, aes(Var1, Var2)) + geom_line(value)


