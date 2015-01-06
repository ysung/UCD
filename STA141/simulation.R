# simulation.R
# simulation one data sets with 4000 y1 and y2.
simu = function(x1, x2, b1_1, b1_2, b0_1 = 100, b0_2 =100, psi, rho = 0.99, e1 = e1, e2 = e2)
{
  for (t  in 2:4000)
  {
    x1 = c(x1, rho*x1[t-1] + (1-rho)*psi*x2[t-1] + e1[t-1])
    x2 = c(x2, rho*x2[t-1] + (1-rho)*psi*x1[t-1] + e2[t-1])
  }
  
  y1 = b0_1 + b1_1 + x1
  y2 = b0_2 + b1_2 + x2
  y = data.frame(y1 = y1, y2 = y2)
  return(y)
}

# generate numbers of datasets with the same parameters
stocksim = function(number, b1_1, b1_2, b0_1 = 100, b0_2 =100, psi, rho = 0.99)
{
  profit=c()
  for(i in 1:number)
  {
    x1 = rnorm(4000)[i] + e1[1]
    x2 = rnorm(4000)[i] + e2[1]
    data = simu(x1, x2, psi=psi, b1_1 =b1_1, b1_2=b1_2)
    
    # design y1, y2
    date = seq(as.Date("1900/1/1"), by = "days", length.out = 4000)
    y1 = data.frame(Date = as.Date(date), Close = data$y1[1:4000])
    y2 = data.frame(Date = as.Date(date), Close = data$y2[1:4000])
    
    profit = c(profit, totalProfit(k = 0.39, y1, y2, training = FALSE))
  }
  avg = list(mean(profit), profit)
  return(avg)
}