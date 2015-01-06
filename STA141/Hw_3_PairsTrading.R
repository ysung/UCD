setwd("/Users/SUNG/Desktop/STA141/HW3")

library(ggplot2)
library(reshape2)
library(lubridate)

APPL = read.csv("Data/AAPL.csv", header = TRUE)
GOOG = read.csv("Data/GOOG.csv", header = TRUE)
SBUX = read.csv("Data/SBUX.csv", header = TRUE)
PNRA = read.csv("Data/PNRA.csv", header = TRUE)


# stock
source("profit.R")
value = maxProfit(SBUX, PNRA, k_begin = 0, k_end = 2, k_by = 0.01)
value_2 = maxProfit(GOOG, APPL, k_begin = 0, k_end = 1, k_by = 0.005)

# simulation
e1 = rnorm(4000)
e2 = rnorm(4000)
x1 = rnorm(4000)[1] + e1[1]
x2 = rnorm(4000)[1] + e2[1]
rho = 0.99

source("simulation.R")

result_1 = simu(x1, x2, psi = 0, b1_1 = 0, b1_2 = 0, e1 = e1, e2 = e2)
result_2 = simu(x1, x2, psi = 0.9, b1_1 = 0, b1_2 = 0, e1 = e1, e2 = e2)
result_3 = simu(x1, x2, psi = 0.9, b1_1 = 0.01, b1_2 = 0.01, e1 = e1, e2 = e2)
result_4 = simu(x1, x2, psi = 0.9, b1_1 = 0.01, b1_2 = -0.01, e1 = e1, e2 = e2)
result = data.frame(result_1, result_2, result_3, result_4)


# Find Best K
data = simu(x1, x2, psi = 0, b1_1 = 0, b1_2 = 0, e1 = e1, e2 = e2)
# refer to @436
date = seq(as.Date("1900/1/1"), by = "days", length.out = 4000)
y1 = data.frame(Date = as.Date(date), Close = result_4$y1[1:4000])
y2 = data.frame(Date = as.Date(date), Close = result_4$y2[1:4000])

par(mfrow = c(1,1))

k_profit = maxProfit(y1, y2, k_begin = 0, k_end = 2, k_by = 0.01)

plot(k_profit[[3]], k_profit[[4]], type="l", col="red", xlab = "K", ylab = "Profit", main = "Profit of Different k")
points(k_profit[[1]],k_profit[[2]], pch =1, cex = 1, col = "blue")
legend("topright", "Best K: 0.39", pch = 1, col = "blue", cex = 1.0)

############################################
# Four plot
par(mfrow = c(2, 2))
p_title =c("psi = 0, b1_1 = 0, b1_2 = 0", "psi = 0.9, b1_1 = 0, b1_2 = 0", "psi = 0.9, b1_1 = 0.01, b1_2 = 0.01", "psi = 0.9, b1_1 = 0.01, b1_2 = -0.01")
for (i in 1:4){
  plot(c(1:4000), result[,1+(i-1)], type ="l", col = "red", 
       xlab = "Time", ylab = "Price", main = p_title[i], ylim =c(70, 150)) 
  lines(result[, 2+(i-1)], col = "blue") 
  legend("topleft", legend = c("Y1", "Y2"), fill=c("red", "blue"), lty = 2, title = "Stock", cex=0.5, text.font=2, pt.cex=2)#, pt.lwd=2, pt.cex=2)
}
###################################################
# plot psi, beta with given k and rho

# test different parameters
sim_1 = stocksim(number = 1000, b1_1 = 0, b1_2 = 0, psi = 0, rho = 0.99)
sim_2 = stocksim(number = 1000, b1_1 = 0, b1_2 = 0, psi = 0.9, rho = 0.99)
sim_3 = stocksim(number = 1000, b1_1 = 0.01, b1_2 = 0.01, psi =0.9, rho = 0.99)
sim_4 = stocksim(number = 1000, b1_1 = 0.01, b1_2 = -0.01, psi =0.9, rho = 0.99)
sim_5 = stocksim(number = 1000, b1_1 = 0, b1_2 = 0, psi = 0.3, rho = 0.99)
sim_6 = stocksim(number = 1000, b1_1 = 0, b1_2 = 0, psi = 0.6, rho = 0.99)
sim_7 = stocksim(number = 1000, b1_1 = 0.02, b1_2 = 0.02, psi =0.9, rho = 0.99)
sim_8 = stocksim(number = 1000, b1_1 = 0.03, b1_2 = 0.03, psi =0.9, rho = 0.99)
sim_9 = stocksim(number = 1000, b1_1 = 0.02, b1_2 = -0.02, psi =0.9, rho = 0.99)
sim_10 = stocksim(number = 1000, b1_1 = 0.03, b1_2 = -0.03, psi =0.9, rho = 0.99)

# Psi
p_data_1 = data.frame(Number.of.Simulations = seq(1, 1000), Psi_0 = sim_1[[2]], Psi_0.9 = sim_2[[2]])
p_1 = melt(p_data_1, value.name = "Profit", id.vars = "Number.of.Simulations", variable.name = "Psi")
ggplot(p_1, aes(x = Number.of.Simulations, y = Profit, colour =  Psi)) +
  geom_line() + ggtitle("Profit on Different Psi")

# Cross-correlation, opposite trends
p_data_2 = data.frame(Number.of.Simulations = seq(1, 1000), 
                      beta1_1 = sim_2[[2]], beta1_2 = sim_3[[2]])
p_2 = melt(p_data_2, value.name = "Profit", id.vars = "Number.of.Simulations", variable.name = "Beta")
ggplot(p_2) + geom_line(aes(x = Number.of.Simulations, y = Profit,colour =  Beta)) + ggtitle("Profit on Different Beta")

# Prices on Different Trend of Beta
p_data_3 = data.frame(Number.of.Simulations = seq(1, 1000), 
                      Same.trends = sim_2[[2]], Opposite.trends= sim_4[[2]])
p_3 = melt(p_data_3, value.name = "Profit", id.vars = "Number.of.Simulations", variable.name = "Beta")
ggplot(p_3) + geom_line(aes(x = Number.of.Simulations, y = Profit,colour =  Beta)) + ggtitle("Profit on Different Trend of Beta")

# Average of Profit on Different Psi
p_4 = data.frame(Psi = c(0.3, 0.6, 0.9), 
                      Profit = c(sim_5[[1]], sim_6[[1]], sim_2[[1]]))
ggplot(p_4) + geom_line(aes(x = Psi , y = Profit), lwd =1) + ggtitle("Average of Profit on Different Psi")+
  geom_point(aes(x = Psi, y = Profit, colour = Profit), size =4)  
  
  geom_text(aes(x = Beta, y = Psi), label = round(c(sim_5[[1]], sim_6[[1]], sim_2[[1]]),2), size = 3)

# Average of Profit on Different Beta
p_5 = data.frame(Beta = c(0.01, 0.02, 0.03), 
                 Profit = c(sim_3[[1]], sim_7[[1]], sim_8[[1]]))
ggplot(p_5) + geom_line(aes(x = Beta , y = Profit)) + ggtitle("Average of Profit on Different Beta")+
  geom_point(aes(x = Beta, y = Profit, size = Profit), colour = "blue")  

#Average of Profit on Different Trends of Beta
p_6 = data.frame(Beta.Positive.Negetive = c(0.01, 0.02, 0.03), 
                 Profit = c(sim_4[[1]], sim_9[[1]], sim_10[[1]]))
ggplot(p_6) + ggtitle("Average of Profit on Different Trends of Beta")+
  geom_point(aes(x = Beta.Positive.Negetive, y = Profit, size = Profit), colour = "blue")  
