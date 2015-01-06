# Funtion of read data

dataCount <- function(name)
{
  input = paste0("count/", name)
  unicefCount = read.csv(input, header = FALSE)
  names(unicefCount) = c(0:50)
  unicefCount = unicefCount[, -52]
  return (unicefCount)
}


pickData <- function(name, a, b){
  # a comments, b mins
  input <- paste0("tmp/", name)
  data <- read.csv(input, header = FALSE)
  names(data) <- c("ob", "type", "freq")
  data <- data[-nrow(data), ]
  data$type <- rep(c(0:50) , 50*2*50)
  pattern = paste0("^ ", a," <=",b ," mins")
  data = data[grep(pattern, data$ob),] # pattern
  return (data)
}

unpopData <- function(name, a, b){
  # a comments, b mins
  input <- paste0("./tmp/", name)
  data <- read.csv(input, header = FALSE)
  names(data) <- c("ob", "type", "freq")
  data <- data[-nrow(data), ]
  data$type <- rep(c(0:50) , 50*2*50)
  pattern = paste0("^ ", a," >",b ," mins")
  data = data[grep(pattern, data$ob),] # pattern
  return (data)
}

read_data <- function(name){
  data <- read.csv(paste0("./tmp/", name), header = FALSE)
  names(data) <- c("observation", "type", "freq")
  data <- data[-nrow(data), ]
  data$type <- rep(c(0:50) , 10*2*50)
  # ob = rawdata$observation
  # data$observation <- rep(1:(nrow(data)/50), each = 50)
  return (data)
}

read_reg_data <- function(name, pattern){
  data <- read.csv(paste0("./tmp/", name), header = FALSE)
  names(data) <- c("ob", "type", "freq")
  data <- data[-nrow(data), ]
  data$type <- rep(c(0:50) , 10*2*50)
  data = data[grep(pattern, data$ob),] # pattern
  # data = droplevels(data[1:900, ]) # comments for 1 to 9
  return (data)
  # cross.table = xtabs(freq ~ ob + type, data = data)
  # return (cross.table[grep(pattern, rownames(cross.table)),])
}
