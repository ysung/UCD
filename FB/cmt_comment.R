setwd("/Users/sung/Desktop/Research/data")

library(ggplot2)
library(reshape2) # change data.frame the the table with ggplot format
library(RColorBrewer) # Color
library(ROCR) # Caculate Recall, Precision, F1


dataList <- c("Bing", "CBS", "cnnstudentnews", "Daily", "Global", "MLS", "OccupyLA", "Rockets", "Susan", "UNICEF") # 10 datasets

colData2 <- function(input, a, b){
  # a unique IDs, from 1 - 10
  # b mins, from 1 - 50
  
  if ( a < 1 | a > 10 | b < 1 | b > 50)
    stop("inputs beyond the range")
  
  input <- paste0(input, "_ID.csv")
  data <- read.csv(pipe(paste0("cut -f1-3 -d',' ", input)), header = FALSE)[-51001, ]
  names(data) = paste0("V", seq_len(3))
  data$V2 <- rep(c(0:50) , 10*2*50)
  pattern <- paste0("^.?", a," (<=|>)",b ," mins")
  data <- data[grep(pattern, data$V1), ]
  return(data)
}

f1Result <- function(input, uniqID){
  # Calculate F1 score
  # uniqID from 1-50
  if (uniqID < 1 | uniqID > 50)
    stop("inputs beyond the range")
  
  tp <- sum(input[(uniqID+1):51])
  fp <- sum(input[1:(uniqID)])
  tn <- sum(input[52:(52+uniqID-1)])
  fn <- sum(input[(52+uniqID):102])
  
  if(tp+fp == 0){
    precision <- 0
  }
  else{
    precision <- tp/(tp+fp)
  }
  
  if(tp+fn == 0){
    recall <- 0 
  }
  else{
    recall <- tp/(tp+fn) 
  }
  
  if (precision == 0 & recall == 0){
    F1 <- 0
  }
  else{
    F1 <- 2*precision*recall/(precision+recall)
  }
  
  return (F1)
  
}

f1Plot = function(num, mydata, resultType = "graph") {
  # resultType = "data" or "graph
  # num from 1 to 10
  # my data from dataList[1] to dataList[10]
  
  f1Dist = sapply(1:10, function(y){
    # 1 to 50 mins
    result = sapply(seq(5, 50, 5), function(x){
      # 5 to 50 Uniq IDs, the interval is 5
      data =  colData2(mydata, y , num)
      output = f1Result(data[, 3], x)
    })
  })
  f1Dist.m = melt(f1Dist, value.name = "F1")
  names(f1Dist.m)[1:2] = c("UniqID", "Comments")
  f1Dist.m$UniqID = rep(seq(5, 50, 5), 10)
  f1Dist.m = f1Dist.m[order(f1Dist.m$UniqID), ]
  # write.csv(f1Dist.m, file = paste0(mydata, "_", num, "u.csv"))
  # return (f1Dist.m)
  
  if (resultType == "graph") {
    myPlot = ggplot(f1Dist.m, aes(UniqID, F1, group = Comments, colour = factor(Comments))) + geom_line() + 
      xlab("Response") + ylab("F1 Value") + ggtitle(paste0(mydata, " Response in 10 Mins")) +
      scale_x_continuous(limits = c(1, 50), breaks = c(1, seq(5, 50, 5))) + 
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
      #scale_colour_grey(start = 0.8, end = 0.2)
      ggsave(paste0(mydata, "_", num, "m.eps"), width = 8, height = 6)
    return (myPlot)
  }
  
}


## main

# drop F1 graph
for (x in 1:10){
    f1Plot(10, dataList[x])
}


f1Dist = sapply(1:4, function(y){
  # 1 to 10 comments
  result = sapply(seq(5, 50, 5), function(x){
    # 5 to 50 Uniq IDs, the interval is 5
    data =  colData2(dataList[1], y , 10)
    output = f1Result(data[, 3], x)
  })
})

f1Dist.m = melt(f1Dist, value.name = "F1")

names(f1Dist.m)[1:2] = c("UniqID", "Comments")
f1Dist.m$UniqID = rep(seq(5, 50, 5), 10)
f1Dist.m = f1Dist.m[order(f1Dist.m$UniqID), ]
