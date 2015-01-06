# Timestamp distribution
data_1 <- read.csv("time_distri_t=1.txt", header = FALSE)
names(data_1) = c("timestamp", "freq")
time_1 = ggplot(data_1, aes(timestamp, freq)) + geom_line() + 
  scale_y_continuous(limits = c(0, 0.006), breaks = seq(0, 0.006, 0.0005)) +
  ggsave("time_1.pdf")

data_5 <- read.csv("time_distri_t=5.txt", header = FALSE)
names(data_5) = c("timestamp", "freq")
data_5[, 1] = data_5[, 1]*5
time_5 = ggplot(data_5, aes(timestamp, freq)) + geom_line() + 
scale_y_continuous(limits = c(0, 0.006), breaks = seq(0, 0.006, 0.0005)) +
  ggsave("time_5.pdf")



# test data
dataList <- c("test.txt", "test2.txt", "test3.txt", "test4.txt", 
              "test5.txt", "test6.txt", "test7.txt")
cmtList <- c(50, 50, 50, 20, 20, 10, 10)

testDist <- function (input, cmt) {
  data = read.csv(input, header = FALSE)
  result = data.frame()
  for (i in 1:cmt) {
    result = rbind(result, getBEI(data, i))
  }
  names(result) = c("Comment", "Time", "BEI")
  #ggplot(result, aes(Comment, BEI)) + geom_point()
  ggplot(result, aes(Comment, Time)) + geom_point() +
    scale_y_continuous(limits = c(0, 200)) +
    scale_x_continuous(limits = c(0, 50)) +
    ggsave(paste0(input, "_cmt", cmt, ".pdf"))
}

for (i in 1:length(dataList)) {
  testDist(dataList[i], cmtList[i])
}

