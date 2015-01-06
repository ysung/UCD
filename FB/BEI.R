setwd("/Users/sung/Desktop/Research/data")

library(ggplot2)
library(reshape2) # change data.frame the the table with ggplot format

getBEI <- function(myList, comment) {
  # comment from 1 to 10
  
  # delete the rows of ID, over24
  ID = myList[1]
  over24 = myList[1442]
  myList= as.numeric(myList[-c(1, 1442)])
  
  # find which index is the comment allocates in 
  cumList = cumsum(myList)
  firstIndex = which(cumList >= comment)[1] # find index
  firstValue = comment
   
  # check if firstIndex equals to NA, 0 list or sum of value less than comment
  if (is.na(firstIndex))
    return (-1)
  
  # check if timeSlot over limit
  if (firstIndex >= 720)
    return (0)

  if (firstIndex <= 1) {
    timeSlot = comment/myList[firstIndex]
  } else {
    partialV = comment - sum(myList[1:(firstIndex - 1)]) # partial value
    timeSlot = partialV / myList[firstIndex] + firstIndex
  } 
  
  secIndex = ceiling(2*timeSlot)
  
  if (secIndex <= 1) {
    secValue = 2*timeSlot*myList[firstIndex] - firstValue
  } else {
    partialI = 2*timeSlot - floor(2*timeSlot)
    secValue = sum(myList[1:(secIndex-1)]) + partialI * myList[secIndex] - firstValue
  }
  
  BEI = secValue/firstValue
  result = c(firstValue, timeSlot, BEI)
  return (result)
}

args <- commandArgs(TRUE)
postData <- read.csv(args, header = FALSE)

# Caculate BEI
postBEI = data.frame()
for (x in 1:dim(postData)[1]){
  for (y in 1:50){
    value = getBEI(postData[x, ], y)
    if (value[1] == -1)
      next
    if (value[1] == 0)
      break
    postBEI = rbind(postBEI, value)
  }
}

names(postBEI) = c("Comment", "Time", "BEI")
postBEIlog <- postBEI
postBEIlog[ ,3] <- log10(postBEIlog[ ,3]) # log BEI





# Graph
cmtStat <- data.frame()
# boundry for x-axis
bMax <- ceiling(max(postBEIlog[, 3]))
bMin <- floor(min(postBEIlog[, 3]))
for (i in 1:50) {
  cmtBEI = postBEIlog[postBEIlog$Comment == i, ]
  if (dim(cmtBEI)[1] == 0)
    break
  
  BEIm = round(mean(cmtBEI[, 3]), 2)
  BEIsd = round(sd(cmtBEI[, 3]), 2)
  timem = round(mean(cmtBEI[, 2]), 2)
  timesd = round(sd(cmtBEI[, 2]), 2)
  sample = dim(cmtBEI)[1]
  cmtStat = rbind(cmtStat, c(sample, BEIm, BEIsd, timem, timesd))
  
  ggplot(cmtBEI, aes(x=BEI)) + 
    geom_density(fill = "#0072B2", alpha=0.3) + 
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    scale_x_continuous(limits = c(bMin, bMax), breaks = seq(bMin, bMax, 1)) +
    ggtitle(paste0("cmt=", i, ", sample=", sample, ", m=", BEIm, ", sd=", BEIsd)) +
    ggsave(filename = paste0("OccupyLA_1_", "BEI_", i, ".pdf"), width = 8, height = 6)
  
  ggplot(cmtBEI, aes(x=Time)) + 
    geom_density(fill = "#D55E00", alpha=0.3) + 
    scale_y_continuous(limits = c(0, 0.1), breaks = seq(0, 0.1, 0.01)) +
    scale_x_continuous(limits = c(0, 720), breaks = seq(0, 720, 60)) +
    ggtitle(paste0("cmt=", i, ", sample=", sample, ", m=", timem, ", sd=", timesd)) +
    ggsave(filename = paste0("OccupyLA_1_", "time_", i, ".pdf"), width = 8, height = 6)  
}

names(cmtStat) <- c("Sample", "BEI Mean", "BEI sd", "Time Mean", "Time sd")
cmtStat <- cbind(Comment = c(1:50) ,cmtStat)
write.csv(cmtStat, paste0("OccupyLA_1.csv"))

