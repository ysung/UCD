setwd("/Users/sung/Desktop/Research/data")

library(ggplot2)
library(reshape2) # change data.frame the the table with ggplot format
library(RColorBrewer) # Color
library(ROCR) # Caculate Recall, Precision, F1


dataList <- c("Bing", "CBS", "cnnstudentnews", "Daily", "Global", "MLS", "OccupyLA", "Rockets", "Susan", "UNICEF") # 10 datasets

dataCountDist <- function(input){
  input <- paste0(input, "_count.txt")
  data <- read.csv(input, header = FALSE)[-52]
  names(data) <- c(0:50)
  data <- melt(data, value.name = "freq", variable.name = "value")
  data = data[-1, ]
  data = droplevels(data)
  data$value = as.numeric(data$value)
  data$freq = as.numeric(data$freq)
  # change factor to int
  return (data)
}

fastmean <- function(dat) {
  with(dat, sum(value*freq)/sum(freq) )
}

fastRMSE <- function(dat) {
  mu <- fastmean(dat)
  with(dat, sqrt(sum(freq*(value-mu)^2)/(sum(freq)-1) ) )
  }

summaryData <- function(input) {
  dat = dataCountDist(input)
  m = fastmean(dat)
  s = fastRMSE(dat)
  output = data.frame(Page = input, "Mean minus SD" = m - 2*s, Mean = m, 
                      "Mean plus SD" =  m + 2*s, SD = s)
  return (output)
}

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

f1Plot = function(num, mydata, resultType = "data") {
  # resultType = "data" or "graph
  # num from 1 to 10
  # my data from dataList[1] to dataList[10]
  
  f1Dist = sapply(1:50, function(y){
    # 1 to 50 mins
    result = sapply(seq(5, 50, 5), function(x){
      # 5 to 50 Uniq IDs, the interval is 5
      data =  colData2(mydata, num, y)
      output = f1Result(data[, 3], x)
    })
  })
  f1Dist.m = melt(f1Dist, value.name = "F1")
  names(f1Dist.m)[1:2] = c("UniqID", "Mins")
  f1Dist.m$UniqID = rep(seq(5, 50, 5), 50)
  f1Dist.m = f1Dist.m[order(f1Dist.m$UniqID), ]
  write.csv(f1Dist.m, file = paste0(mydata, "_", num, "u.csv"))
  return (f1Dist.m)
  
  if (resultType == "graph") {
      myPlot = ggplot(f1Dist.m, aes(Mins, F1, group = UniqID, colour = factor(UniqID))) + geom_line() + 
      xlab("Mins") + ylab("F1 Value") +
      labs(colour = "Final number of Uniq ID") + ggtitle(paste0(mydata, " (received ", num, " Uniq IDs)")) +
      scale_x_continuous(limits = c(1, 50), breaks = c(1, seq(5, 50, 5))) + 
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
      #scale_colour_grey(start = 0.8, end = 0.2)
      ggsave(paste0(mydata, "_", num, "u.eps"), width = 8, height = 6)
      return (myPlot)
  }
  
}


## main

# drop F1 graph
for (x in 1:10){
  sapply(1:10, function(y) 
    f1Plot(x, dataList[y])
  )
}

# Calcute mean and sd for data
result = data.frame()
for (x in 1:10) {
  result = rbind(result, summaryData(dataList[x]))
}
print(result, digits = 3)
write.csv(print(result, digits = 3), "data_summary.csv")

# Calcute median, quarter

for (x in 1:10) {
  print(dataList[x])
  print(summary(dataCountDist(dataList[x])[, 2])[c(2, 3, 5)])
}

#
test = dataCountDist(dataList[1])
ggplot(test, aes(value, freq)) + geom_line() + geom_point()


#
f1Dist = sapply(1:50, function(y){
  # 1 to 50 mins
  result = sapply(seq(5, 50, 5), function(x){
    # 5 to 50 Uniq IDs, the interval is 5
    data =  colData2(mydata, num, y)
    output = f1Result(data[, 3], x)
  })
})
f1Dist.m = melt(f1Dist, value.name = "F1")
names(f1Dist.m)[1:2] = c("UniqID", "Mins")
f1Dist.m$UniqID = rep(seq(5, 50, 5), 50)
f1Dist.m = f1Dist.m[order(f1Dist.m$UniqID), ]
write.csv(f1Dist.m, file = paste0(mydata, "_", num, "u.csv"))
return (f1Dist.m)








  
  
  
# rest is not important



f1Per <- function(data, final_u){
  # Calculate F1 score
  # final_u from 2 to 50
  if (final_c == 2) {
    tp <- rowSums(data[seq(1, nrow(data), by = 2), final_c:ncol(data)])
    fp <- data[seq(1, nrow(data), by = 2), 1:(final_c-1)]
    tn <- data[seq(1+1, nrow(data), by = 2), 1:(final_c-1)]
    fn <- rowSums(data[seq(1+1, nrow(data), by = 2), final_c:ncol(data)])
  } 
  else if (final_c == 50) {
    tp <- data[seq(1, nrow(data), by = 2), final_c:ncol(data)]
    fp <- rowSums(data[seq(1, nrow(data), by = 2), 1:(final_c-1)])
    tn <- rowSums(data[seq(1+1, nrow(data), by = 2), 1:(final_c-1)])
    fn <- data[seq(1+1, nrow(data), by = 2), final_c:ncol(data)]
  }
  else {
    tp <- rowSums(data[seq(1, nrow(data), by = 2), final_c:ncol(data)])
    fp <- rowSums(data[seq(1, nrow(data), by = 2), 1:(final_c-1)])
    tn <- rowSums(data[seq(1+1, nrow(data), by = 2), 1:(final_c-1)])
    fn <- rowSums(data[seq(1+1, nrow(data), by = 2), final_c:ncol(data)])
  }
  precision <- tp/(tp+fp)
  if(tp+fn == 0){
    recall <- 0 
  }
  else{
    recall <- tp/(tp+fn) 
  }
  F1 <- 2*precision*recall/(precision+recall)
  return (F1)
}

creatlist <- function(data) {
  # create max list of F1, and max comment list of F1
  maxlist <- c()
  whichmaxlist <- c()
  overlist <- c()
  for (i in 1:length(testlist)){
    mydata <- read_reg_data(data, testlist[i])
    flist <- sapply((1+1):50, function(x) f1Per(mydata, x))
    flist <- t(sapply(1:nrow(flist), function(x)  
      if (x == 1 | x ==2)
        flist[x, ]
      else
        replace(flist[x, ], 1:(x-2), 0)))
      # f1 = 0 if the final comment less than critiria
#     if (i == 1){
#       overlist <- cbind(overlist, flist)
#     }
    maxlist <- cbind(maxlist, apply(flist, 1, max)) # max and min values in each row of the matrix
    whichmaxlist <- cbind(whichmaxlist, apply(flist, 1, which.max) + 1)# the position of the max value in each row
    # max.col(tt)+2 # the position of the max value in each row
    # apply(tt, 1, range) # max and min values in each row of the matrix
  }
  rownames(maxlist) <- c(1:9)
  colnames(maxlist) <- seq(5, 50, by = 5)
  rownames(whichmaxlist) <- c(1:9)
  colnames(whichmaxlist) <- seq(5, 50, by = 5)
  write.csv(whichmaxlist, file = paste0(gsub("(*).csv","\\1", data), "_F1C.csv"))
  write.csv(maxlist, file = paste0(gsub("(*).csv","\\1", data), "_F1.csv"))
  write.csv(overlist, file = paste0(gsub("(*).csv","\\1", data), "_F1O.csv"))
  return(list(maxlist, whichmaxlist, overlist))
}


for (i in 1:3){
  mylist <- creatlist(filenames[i])
  maxlist <-  mylist[[1]]
  whichmaxlist <- mylist[[2]]
  overlist <- mylist[[3]]
  
  #f1TrendPlot(filenames[i], maxlist, whichmaxlist) 
  #f1TilePlot(filenames[i], maxlist, whichmaxlist)
}


f1TrendPlot <- function(data, mlist, wmlist){
  mlist.m <- melt(mlist)
  wmlist.m <- melt(wmlist)
  mytitle <- gsub("(*).csv","\\1", data)
  ggplot(mlist.m, aes(Var2, value, group = Var1, colour = factor(Var1))) + geom_line() +
    xlab("Responce Time (Mins)") + ylab("F1 Value") + labs(colour = "Responce Comments") +
    ggtitle(mytitle) + scale_y_continuous(limits = c(0.3, 1), breaks = seq(0.3, 1, 0.1)) +
    scale_x_continuous(breaks = seq(5, 50, 5)) + geom_point()
  ggsave(paste0(mytitle, "_Max_F1.eps"), width = 8, height = 6)
  
  ggplot(wmlist.m, aes(Var2, value, group = Var1, colour = factor(Var1))) + geom_line() + 
    xlab("Responce Time (Mins)") + ylab("Final Comments") + labs(colour = "Responce Comments") +
    ggtitle(mytitle) + scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 2)) + 
    scale_x_continuous(breaks = seq(5, 50, 5)) + geom_point()
  ggsave(paste0(mytitle, "_Max_F1C.eps"), width = 8, height = 6)
}


f1TilePlot <- function(data, mlist, wmlist){
  mlist.m <- melt(mlist)
  wmlist.m <- melt(wmlist)
  mytitle <- gsub("(*).csv","\\1", data)
  ggplot(mlist.m, aes(Var2, Var1)) + geom_tile(aes(fill = value), colour = "white") +
    scale_fill_gradient(low = "green", high = "red") + #, limits = c(0 ,1)) +
    labs(fill = "F1 Value") + ylab("Comments") + xlab("Mins") + 
    scale_x_continuous(breaks = seq(5, 50, 5)) +
    scale_y_continuous(breaks = seq(1, 10, 1)) + 
    ggtitle(mytitle)
    ggsave(paste0(mytitle, "_Max_F1T_no.eps"), width = 6, height = 5)
  ggplot(wmlist.m, aes(Var2, Var1)) + geom_tile(aes(fill = value), colour = "white") +
    scale_fill_gradient(low = "green", high = "red", limits = c(0 ,50)) +
    labs(fill = "Final Comments") + ylab("Comments") + xlab("Mins") + 
    scale_x_continuous(breaks = seq(5, 50, 5)) +
    scale_y_continuous(breaks = seq(1, 10, 1)) + 
    ggtitle(mytitle)
  ggsave(paste0(mytitle, "_Max_F1CT.eps"), width = 6, height = 5)
}

testlist = c("((<=1)|(>1)) mins", "((<=2)|(>2)) mins", "((<=3)|(>3)) mins", 
             "((<=4)|(>4)) mins", "((<=5)|(>5)) mins", "((<=6)|(>6)) mins",
             "((<=7)|(>7)) mins", "((<=8)|(>8)) mins", "((<=9)|(>9)) mins",
             "((<=10)|(>10)) mins")

filenames <- list.files(path = "./tmp", pattern = ".csv")
# tmp <- read.csv(paste0("./tmp/", filenames[[1]]), header = FALSE)
# names(tmp) <- c("observation", "type", "freq")
# ob = tmp$observation

# files = lapply(1:length(filenames), function(x) read_data(filenames[x]))
# cross.table = xtabs(freq ~ observation + type, data = files[[1]])
# dim(cross.table) # 1000*50
# lapply(1:10, function(x) sapply(1:10, function(y) cat(x, y)))







  #main
  for (i in 1:3){
    mylist <- creatlist(filenames[i])
    maxlist <-  mylist[[1]]
    whichmaxlist <- mylist[[2]]
    overlist <- mylist[[3]]
    
    #f1TrendPlot(filenames[i], maxlist, whichmaxlist) 
    #f1TilePlot(filenames[i], maxlist, whichmaxlist)
  }
  
  test = data.frame()
  for (i in 1:9){
    fc = mean(which(overlist[i, ] > 0.8))
    fcr = max(which(overlist[i, ] > 0.8)) - fc
    test = rbind(test, data.frame(comment = i, fc, fcr))
  }
  
  ggplot(test, aes(comment, fc, ymin = fc - fcr, ymax = fc + fcr))+ 
    geom_linerange() + scale_x_continuous(breaks = seq(1, 9, 1)) +
    scale_y_continuous(limit = c(0, 20), breaks = seq(0, 20, 1)) +
    ggtitle("F1 > 0.8 when receive c in 10 mins")
  
  




mymatrix <- matrix(0, 1000, 20)

for (x in 1:1000){
  # to check left 1 commments in 1 to 50 mins, what is the percentage 
  # of the amoount final comment.
  for (y in 1:20)
    mymatrix[x,y] <- sum(cross.table[x, y:50])
} 



#mymatrix = round(mymatrix, 2)
diff = mymatrix[seq(1, 1000, 2), ] - mymatrix[seq(2, 1000, 2), ]
plot(diff[1, ], ylim =c(-200, 200), type = "l", xlab = "accumulation", ylab = "Difference")
lines(diff[2, ], ylim =c(-200, 200), type = "l")
lines(diff[3, ], ylim =c(-200, 200), type = "l")

cross.table[1:2, ]


temp= sapply(1:dim(diff)[1], function(x) which.max(diff[x, ])) 
tempm= matrix(temp, nrow = 50, ncol = 10)
temp_value= sapply(1:dim(diff)[1], function(x) max(diff[x, ])) 
tempv = matrix(temp_value, nrow = 50, ncol = 10)
tempv
tempm
pheatmap(tempm)
max(diff[1,])
sum(cross.table[4, 8:50])

diff[2,]
mymatrix[2,3]
write.csv(tempv, file = "diff_max_value.csv")
write.csv(tempm, file = "diff_max_point.csv")
data = data.frame(data = temp, id = rep(1:10, each =50))
data
data.m <- melt(data)
data.m


mymatrix2 <- matrix(0, 100, 20)

for (x in 1:100){
  # to check left 2 commments in 1 to 50 mins, what is the percentage 
  # of the amoount final comment.
  for (y in 1:20)
    mymatrix2[x, y] <- sum(cross.table[(x+100), y:50])/sum(cross.table[(x+100), ])
} 

diff2 = mymatrix2[seq(1, 100, 2), ] - mymatrix2[seq(2, 100, 2), ]
max(diff2)
duf
mymatrix2[1:2, ]
cross.table[101:102, ]
diff2.m <- melt(diff2)
ggplot(diff2.m, aes(Var1, Var2)) + geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient(low = "green", high = "red") +
  labs(fill = "Percentage Difference") + ylab("Comments") + xlab("Mins") + 
  scale_x_continuous(breaks = seq(0, 50, 2)) +
  scale_y_continuous(breaks = seq(0, 20, 1))


test = colData2(dataList[1], 1, 1)
f1Result(test, 3)
