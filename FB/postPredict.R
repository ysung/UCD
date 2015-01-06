setwd("/Users/sung/Desktop/Research/data")

library(ggplot2)
library(reshape2) # change data.frame the the table with ggplot format
library(RColorBrewer) # Color
library(ROCR) # Caculate Recall, Precision, F1


dataList <- c("Bing", "CBS", "cnnstudentnews", "Daily", "Global", "MLS", "OccupyLA", "Rockets", "Susan", "UNICEF") # 10 datasets

dataCount <- function(input, greater = 20){
  # final number of unique ID from 0 to 50
  # message ("95% sum of the count")
  if (greater > 50 | greater < 0)
    stop("inputs beyond the range")
  
  input <- paste0(input, "_count.txt")
  data <- read.csv(input, header = FALSE)[-52]
  names(data) <- c(0:50)
  greater = greater + 1
  return(ceiling(sum(data[greater:51])*.95)) 
}

chooseColMax <- function(input, greater = 20){
  # final number of unique ID from 0 to 50.
  input <- paste0(input, "_ID.csv")
  data <- read.csv(pipe(paste0("cut -f1-3 -d',' ", input)), header = FALSE)
  data <- data[-51001, ]
  names(data) <- c("ob", "type", "freq")
  data$type <- rep(c(0:50) , 10*2*50)
  colMax <- max(data[data$type>greater, 3])
  return(colMax)
}

colData <- function(input, a, b){
  # a unique IDs, from 1 - 10
  # b mins, from 1 - 50

  if ( a < 1 | a > 10 | b < 1 | b > 50)
    stop("inputs beyond the range")
  
  input <- paste0(input, "_ID.csv")
  data <- read.csv(pipe(paste0("cut -f1-3 -d',' ", input)), header = FALSE)[-51001, ]
  names(data) = paste0("V", seq_len(3))
  data$V2 <- rep(c(0:50) , 10*2*50)
  pattern <- paste0("^.?", a," <=",b ," mins")
  data <- data[grep(pattern, data$V1), ]
  return(data)
}

popRate <- sapply(1:10, function(d){
  # to detect the proportion of popular posts over total posts
  dTotal <- dataCount(dataList[d], greater = 0)
  dCount <- dataCount(dataList[d], greater = 20)
  dRate <- dCount/dTotal
  return (dRate)
})


# main
myList <- lapply(1:10, function(d) {
  coverList <- c()
  dCount <- dataCount(dataList[d], greater = 10)
  # 10 for 10 up
  # 20 for 20 up
  # 30 for 30 up
  for (i in 1:3){
    countList <- sapply(1:50, function(x) sum(colData(dataList[d], i, x)[11:51, 3]))
    # 11~51 for 10 up
    # 21~51 for 20 up
    # 31~51 for 30 up
    coverList <- c(coverList, which(countList >= dCount)[1])
  }
  return(coverList)
})


## run 10, 20, 30

# for 10
myList[[1]][3] = 50
myList[[2]][2:3] = 50
# over the limit 50
mylist <- melt(myList)
mylist <- cbind(mylist, Mins = rep(1:3, 10))
mylist$L1 <- rep(dataList, each = 3)
ggplot(mylist, aes(Mins, value, group = L1, colour = L1)) + geom_line() + 
  geom_point() + scale_x_continuous(breaks = seq(1, 3, 1)) +
  scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 5)) + ylab("User Responses") + 
  labs(colour = "Page") + ggsave("Timestamp_10.eps", width = 8, height = 6)

# for 20
myList[[1]][3] = 50
 # over the limit 50
mylist <- melt(myList)
mylist <- cbind(mylist, Mins = rep(1:3, 10))
mylist$L1 <- rep(dataList, each = 3)
ggplot(mylist, aes(Mins, value, group = L1, colour = L1)) + geom_line() + 
  geom_point() + scale_x_continuous(breaks = seq(1, 3, 1)) +
  scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 5)) + ylab("User Responses") + 
  labs(colour = "Page") + ggsave("Timestamp_20.eps", width = 8, height = 6)


# for 30
myList[[1]][3] = 50
# over the limit 50
mylist <- melt(myList)
mylist <- cbind(mylist, Mins = rep(1:3, 10))
mylist$L1 <- rep(dataList, each = 3)
ggplot(mylist, aes(Mins, value, group = L1, colour = L1)) + geom_line() + 
  geom_point() + scale_x_continuous(breaks = seq(1, 3, 1)) +
  scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 5)) + ylab("User Responses") + 
  labs(colour = "Page") + ggsave("Timestamp_30.eps", width = 8, height = 6)


# for 30
myList[[1]][3] = 50
# over the limit 50
mylist <- melt(myList)
mylist <- cbind(mylist, Mins = rep(1:3, 10))
mylist$L1 <- rep(dataList, each = 3)
ggplot(mylist, aes(Mins, value, group = L1, colour = L1)) + geom_line() + 
  geom_point() + scale_x_continuous(breaks = seq(1, 3, 1)) +
  scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 5)) + ylab("User Responses") + 
  labs(colour = "Page") + ggsave("Timestamp_50.eps", width = 8, height = 6)





#############################################################################


# checkID <- function
# start = 8*2*51+20
# end = 8*2*51 +51
# data <- read.csv(pipe("awk 'NR >836 && NR <= 867' Daily_ID.csv"), 
#                  header = FALSE, col.names = paste0("V", seq_len(1000)), fill = TRUE)
# data <- unlist(data[-c(1,2),])
# length(unique(as.numeric(data[!is.na(data)])))

colMax <- c()
dCount <- c()
for (i in 1:length(dataList)){
  #read.csv(paste0("data/", dataList[i], "_ID.csv"), header = FALSE)
  #print(dim(data))
  colMax <- c(colMax, chooseColMax(dataList[i]))
  dCount <- c(dCount, dataCount(dataList[i]))
  }
