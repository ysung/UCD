# To count the number of posts that number of final comments > 20 with the 
# hypothesis and check the propotion of it and all posts

setwd("/Users/sung/Desktop/Research")
library(ggplot2)
library(reshape2) # change data.frame the the table with ggplot format
library(RColorBrewer) # Color
library(ROCR) # Caculate Recall, Precision, F1
source("readata.R")




# Bing_count.txt
# Rockets_count.txt
# CBS_count.txt
# UNICEF_count

sum(unpopData("UNICEF.csv", 1, 5)[21:51, 3])
sum(unicefCount)
# UNICEF, with 9651 posts.
# For the posts without receivng any comments in 5 mins 
# only 1 post receives more than 50 final comments. 1/121
# 23 posts receive more than 20 coments. 23/411

sum(unpopData("Bing.csv", 1, 5)[21:51, 3])
sum(bingCount[21:51])
# Bing, with 4885 posts.
# For the posts without receivng any comments in 5 mins 
# only 2 post receives more than 50 final comments. 2/36
# 4 posts receive more than 20 coments. 4/78

sum(unpopData("CBS.csv", 1, 5)[51, 3])
sum(cbsCount[51])
# CBS, with 15832 posts.
# For the posts without receivng any comments in 5 mins 
# only 0 post receives more than 50 final comments. 0/20
# 23 posts receive more than 20 coments. 23/131


pickData("UNICEF.csv", 1, 1)
# to sum # post which contains more than 20 comments

onem = sapply(1:20, function(x) sum(pickData("UNICEF.csv", x, 1)[31:51, 3]))
twom = sapply(1:20, function(x) sum(pickData("UNICEF.csv", x, 2)[31:51, 3]))
threem = sapply(1:20, function(x) sum(pickData("UNICEF.csv", x, 3)[31:51, 3]))

onem
twom
threem 

sum(unicefCount[21:51]) # 411
# 411*.95 = 391
sum(unicefCount[31:51]) # 411
# 411*.95 = 391

sum(bingCount[21:51]) # 78
# 78*.95 = 75
sum(bingCount[31:51]) # 78
# 78*.95 = 75

sum(cbsCount[21:51]) # 1313
# 131*.95 = 125
sum(cbsCount[31:51]) # 1313
# 131*.95 = 125

UNICEF_1c = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 1, x)[31:51, 3]))
UNICEF_2c = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 2, x)[31:51, 3]))
UNICEF_3c = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 3, x)[31:51, 3]))
UNICEF_1c2 = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 1, x)[21:51, 3]))
UNICEF_2c2 = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 2, x)[21:51, 3]))
UNICEF_3c2 = sapply(1:30, function(x) sum(pickData("UNICEF.csv", 3, x)[21:51, 3]))

BING_1c = sapply(1:30, function(x) sum(pickData("Bing.csv", 1, x)[31:51, 3]))
BING_2c = sapply(1:30, function(x) sum(pickData("Bing.csv", 2, x)[31:51, 3]))
BING_3c = sapply(1:30, function(x) sum(pickData("Bing.csv", 3, x)[31:51, 3]))
BING_1c2 = sapply(1:30, function(x) sum(pickData("Bing.csv", 1, x)[21:51, 3]))
BING_2c2 = sapply(1:40, function(x) sum(pickData("Bing.csv", 2, x)[21:51, 3]))
BING_3c2 = sapply(1:50, function(x) sum(pickData("Bing.csv", 3, x)[21:51, 3]))

CBS_1c = sapply(1:30, function(x) sum(pickData("CBS.csv", 1, x)[31:51, 3]))
CBS_2c = sapply(1:30, function(x) sum(pickData("CBS.csv", 2, x)[31:51, 3]))
CBS_3c = sapply(1:30, function(x) sum(pickData("CBS.csv", 3, x)[31:51, 3]))
CBS_1c2 = sapply(1:30, function(x) sum(pickData("CBS.csv", 1, x)[21:51, 3]))
CBS_2c2 = sapply(1:50, function(x) sum(pickData("CBS.csv", 2, x)[21:51, 3]))
CBS_3c2 = sapply(1:50, function(x) sum(pickData("CBS.csv", 3, x)[21:51, 3]))


# for over 20 comments
which (UNICEF_1c2 > sum(unicefCount[21:51])*.95)[1] # got 1 comment in 6 mins
which (UNICEF_2c2 > sum(unicefCount[21:51])*.95)[1] # got 2 comment in 9 mins
which (UNICEF_3c2 > sum(unicefCount[21:51])*.95)[1] # got 3 comment in 15 mins
which (BING_1c2 > sum(bingCount[21:51])*.95)[1] # got 1 comment in 9 mins
which (BING_2c2 > sum(bingCount[21:51])*.95)[1] # got 2 comment in 33 mins
which (BING_3c2 > sum(bingCount[21:51])*.95)[1] # NA
which (CBS_1c2 > sum(cbsCount[21:51])*.95)[1] # got 1 comment in 11 mins
which (CBS_2c2 > sum(cbsCount[21:51])*.95)[1] # got 2 comments in 32 mins
which (CBS_3c2 > sum(cbsCount[21:51])*.95)[1] # got 3 comments in 49 mins

# test2 = read.csv("./tmp/UNICEF.csv", header = FALSE)
# test2[1, ]
# sum(test2[ test2[, 1]== ' 1 <=6 mins', ][21:51,3])
# sum(test2[ test2[, 1]== ' 2 <=9 mins', ][21:51,3])
# sum(test2[ test2[, 1]== ' 3 <=15 mins', ][21:51,3])

# test = read.csv("./ID/Bing_ID.csv", header = FALSE)
# 
# bingID_1 = test[ test[, 1 ]== '1 <=9 mins', ][20:50, ]
# bingID_2 = test[ test[, 1 ]== '2 <=33 mins', ][20:50, ]
# sum(bingID_1[,3])
# sum(bingID_2[,3])
# bingID1 = bingID_1[-c(1:3)]
# bingID1 = unlist(bingID1)
# length(bingID1[!is.na(bingID1)])
# 
# bingID2 = bingID_2[-c(1:3)]
# bingID2 = unlist(bingID2)
# length(bingID[!is.na(bingID2)])
# 
# count = 0
# for ( i in 1:length(bingID1))
# {
#   if ((as.numeric(bingID1[i]) %in% as.numeric(bingID2)) != TRUE)
#     {
#       count = count +1
#       print (as.character(bingID1[i]))
#     }   
# }
# 
# print (count)
# 
# for (i in 1:31){
#   print(sum(bingID_1[i,3]))
#   print(unlist(bingID_1[i,-c(1:3)]))
# }
# sum(bingID_1[1:30,3])
# tmp = unlist(bingID_1[1:30,-c(1:3)])
# length(tmp[!is.na(tmp)])

test = read.csv("./ID/CBS_ID.csv", header = FALSE)

cbsID_1 = test[ test[, 1 ]== '1 <=11 mins', ][20:50, ]
cbsID_2 = test[ test[, 1 ]== '2 <=32 mins', ][20:50, ]
sum(cbsID_1[,3])
sum(cbsID_2[,3])
cbsID1 = cbsID_1[-c(1:3)]
cbsID1 = unlist(cbsID1)
length(cbsID1[!is.na(cbsID1)])

cbsID2 = cbsID_2[-c(1:3)]
cbsID2 = unlist(cbsID2)
length(cbsID2[!is.na(cbsID2)])

count = 0
for ( i in 1:length(cbsID2))
{
  if ((as.numeric(cbsID2[i]) %in% as.numeric(cbsID1)) != TRUE)
  {
    count = count +1
    print (as.character(cbsID2[i]))
  }   
}

print (count)

for (i in 1:31){
  print(sum(bingID_1[i,3]))
  print(unlist(bingID_1[i,-c(1:3)]))
}
sum(bingID_1[1:30,3])
tmp = unlist(bingID_1[1:30,-c(1:3)])
length(tmp[!is.na(tmp)])



test = read.csv("./ID/UNICEF_ID.csv", header = FALSE)
UNICEF_1 = test[ test[, 1 ]== '1 <=6 mins', ][20:50, ]
UNICEF_2 = test[ test[, 1 ]== '2 <=9 mins', ][20:50, ]
UNICEF_3 = test[ test[, 1 ]== '3 <=15 mins', ][20:50, ]
sum(UNICEF_1[,3])
sum(UNICEF_2[,3])
sum(UNICEF_3[,3])
UNICEF1 = UNICEF_1[-c(1:3)]
UNICEF1 = unlist(UNICEF1)
UNICEF1 = UNICEF1[!is.na(UNICEF1)]
length(UNICEF1)
UNICEF2 = UNICEF_2[-c(1:3)]
UNICEF2 = unlist(UNICEF2)
UNICEF2 = UNICEF2[!is.na(UNICEF2)]
length(UNICEF2)
UNICEF3 = UNICEF_3[-c(1:3)]
UNICEF3 = unlist(UNICEF3)
UNICEF3 = UNICEF3[!is.na(UNICEF3)]
length(UNICEF3)

count = 0
for ( i in 1:length(UNICEF3))
{
  if ((as.numeric(UNICEF3[i]) %in% as.numeric(UNICEF1)) != TRUE)
  {
    count = count +1
    print (as.character(UNICEF3[i]))
  }   
}

print (count)

