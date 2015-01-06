#profit.R
library(ggplot2)
library(reshape2)
library(lubridate)

# Sum up all the profit and minus transaction cost
singleProfit = function(data, open_up, open_down, close_up, close_down, p = 0.001)
{
  profit_up = sum(sapply(1:length(open_up), function(x) 
    1 - 1/data$stock_1[open_up[x]]*data$stock_1[close_up[x]] + 1/data$stock_2[open_up[x]]*data$stock_2[close_up[x]] - 1 + 
                           p*(1 + 1/data$stock_1[open_up[x]]*data$stock_1[close_up[x]] + 1/data$stock_2[open_up[x]]*data$stock_2[close_up[x]] + 1)))
  
  profit_down = sum(sapply(1:length(open_down), function(x) 
    1 - 1/data$stock_2[open_down[x]]*data$stock_2[close_down[x]] + 1/data$stock_1[open_down[x]]*data$stock_1[close_down[x]] - 1 +
                             p*(1 + 1/data$stock_2[open_down[x]]*data$stock_2[close_down[x]] + 1/data$stock_1[open_down[x]]*data$stock_1[close_down[x]] + 1)))
  
  profit = profit_up + profit_down
  profit
}

# Utilize a vectorie algorithm to grab all the open and close poistion.
# First to grab all the points on t+1 with a constraint that the ratio 
# of time t < m and  the ratio time t+1 >m. Then with use similar ways to
# find out open_up, open_down, close_up, close_down. The algorithm 
# pick the closet open_up after the t+1 point we mentioned above and then
# pick the closet close_up after the open_up date. Simliarly we pick up 
# the open_down and close_down and we fix the situation that number of open
# grater than number of close. The most important thing is this algorithm
# can correctly work when the date occurs open and close simultaneous.


open_close = function(data, k, m ,s)
{
  
  t = data$Ratio[1:nrow(data)-1]
  t_plus = data$Ratio[2:nrow(data)]
  pick_1 = c(1, grep(TRUE, t <= m & m <= t_plus) + 1)
  #pick_1 = grep(TRUE, t <= m & m <= t_plus) + 1
  #open_up = grep(TRUE, t <= (m+k*s) & (m+k*s) < t_plus) + 1
  open_up = grep(TRUE, data$Ratio > (m+k*s))
  open_up = unique(sapply(1:length(pick_1), function(i) open_up[match(TRUE, pick_1[i]<=open_up)]))
  open_up = open_up[!is.na(open_up)]
  close_up = grep(TRUE, t >= m & m >= t_plus) + 1
  close_up = sapply(1:length(open_up), function(i) close_up[match(TRUE, open_up[i]<=close_up)])
  pick_2 =  c(1, grep(TRUE, t >= m & m >= t_plus) + 1)
  #pick_2 = grep(TRUE, t >= m & m >= t_plus) 
  #open_down = grep(TRUE, t >= (m-k*s) & (m-k*s) > t_plus) + 1
  open_down = grep(TRUE, data$Ratio < (m-k*s))
  open_down = unique(sapply(1:length(pick_2), function(i) open_down[match(TRUE, pick_2[i]<=open_down)]))
  open_down = open_down[!is.na(open_down)]
  close_down = grep(TRUE, t <= m & m <= t_plus) + 1
  close_down = sapply(1:length(open_down), function(i) close_down[match(TRUE, open_down[i]<=close_down)])

  # Assign the last close position
  close_down[match(NA,close_down)] = length(data$Ratio)
  close_up[match(NA,close_up)] = length(data$Ratio)
  
  profit = singleProfit(data, open_up, open_down, close_up, close_down)
  pick = list(profit, open_up, close_up, open_down, close_down)
  pick
}

# The function can deal with simulation data and stock data.
# When training equals False, the function will generate the graph
# of ratio in testing dataset, combining with open and close position
totalProfit = function(k = 0.01, stock_1, stock_2, training = TRUE)
{
  # Pick the data with the same dates
  stock_1 = stock_1[stock_1$Date %in% stock_2$Date,]
  stock_2 = stock_2[stock_2$Date %in% stock_1$Date,]
  Time = as.Date(stock_1$Date, format="%Y-%m-%d")
  ratio = data.frame(Time, Ratio = stock_1$Close/stock_2$Close, stock_1 = stock_1$Close, stock_2 = stock_2$Close)
  ratio = ratio[order(ratio$Time),]
  # Compute ratio
  if (length(stock_1$Close)==4000)  {
    train = ratio[1:2000, ]
    test = ratio[1:2000, ]
  }
  
  else {
    five_year = tail(Time, 1L)
    year(five_year) = year(five_year)+1
    train = ratio[ratio$Time < five_year, ]
    test= ratio[ratio$Time >= five_year, ]
    
  }
  
  # Pick training and testing data

  s = sd(train$Ratio, na.rm = TRUE)
  m = mean(train$Ratio, na.rm = TRUE)

  # Choose open & close position
  if (training == FALSE){
    pick_test = open_close(test, k, m, s)
    open = c(pick_test[[2]], pick_test[[4]])
    close = c(pick_test[[3]], pick_test[[5]])
    ratio_plot = ggplot(test, aes(x = Time, y = Ratio)) + geom_line(colour = "blue") +
      ggtitle("Historical Ratio") + geom_hline(yintercept = c(m, m + k*s, m - k*s), 
                                               linetype = c(5, 3, 3), colour = "#8E8E93") +
      geom_point(aes(x = Time, y = Ratio, colour = "pick"), pch = 1, data = test[open,], size = 5) +
      geom_point(aes(x = Time, y = Ratio, colour = "#34AADC"), pch = 1, data = test[close,], size = 5) +
      scale_colour_manual(name = "Open & Close Positions", labels = c("Open", "Close"),
                          values = c("pink", "#34AADC")) + geom_text(aes(label = round(Ratio,2)), data = test[open,], size = 4) +
      geom_text(aes(label = round(Ratio,2)), data = test[close,], size = 3)
    print(ratio_plot)
    pick_test[[1]]
  }
  
  else{
    pick_train = open_close(train, k, m, s)
    pick_train[[1]]
  }
}

# The function let user to assign different range of k and use
# the best k of training data to the testing and than draw the graph
# , find out the best profit
maxProfit = function(stock_1, stock_2, k_begin = 0, k_end = 1, k_by = 0.01 , simu=FALSE)
{
  k.vector = seq(k_begin, k_end, k_by)
  result_profit= sapply(k.vector, function(x)
    totalProfit(k = x, stock_1, stock_2))
  #cat(result_profit)
  optimal_k = k_begin + (which.max(result_profit)-1)*k_by
  testing = totalProfit(k = optimal_k, stock_1, stock_2, training = FALSE)
  max_profit = max(testing)
  result = list(optimal_k, max_profit,  k.vector , result_profit)
  return(result)
}
