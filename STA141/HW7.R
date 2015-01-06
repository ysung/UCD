load(url("http://eeyore.ucdavis.edu/stat141/Data/linearModelData.rda"))
library(ggplot2)
library(smoothmest)
library(reshape2)
A = devices[devices$device=='A',1:2]
B = devices[devices$device=='B',1:2]
model = lm(y~x, data = devices)
model_a = lm(y~x , data = A)
model_b = lm(y~x , data = B)
w = resid(model)
w_a = resid(model_a)
w_b = resid(model_b)

#coefficients(model_a) = coef(model_a) = coefficients(model_a)
#model_a$residuals = residuals(model_a) = resid(model_a)

### Part 0
# refer to @812, @820
essential = function(data){
  A = data[data$device=='A',1:2]
  B = data[data$device=='B',1:2]
  w_a = 1/(1/(nrow(A)-2)*sum(residuals(lm(y~x, data = A))^2))
  w_b = 1/(1/(nrow(B)-2)*sum(residuals(lm(y~x, data = B))^2))
  data = data.frame(rbind(A,B), weight = rep(c(w_a, w_b), c(nrow(A), nrow(B))))
  model = lm(data$y~data$x, data, weight = data$weight)
  return(list(coef(model), residuals(model)))
}

p0_result = essential(devices)
p0_result[[1]]

### Part 1

# Sampling in proportion to the number of observations for each device
# Return Variance-Covariance Matrix and beta 0, beta 1.
Sample_sep = function(data, number = 1000){
  dataA = data[data$device=='A',1:2]
  dataB = data[data$device=='B',1:2]
  beta = replicate(number,{
    A = dataA[sample(1:nrow(dataA), nrow(dataA), replace = TRUE), ]
    B = dataB[sample(1:nrow(dataB), nrow(dataB), replace = TRUE), ]
    w_a = 1/(1/(nrow(A)-2)*sum(residuals(lm(A$y~A$x, data = A))^2))
    w_b = 1/(1/(nrow(B)-2)*sum(residuals(lm(B$y~B$x, data = B))^2))
    data = data.frame(rbind(A,B), weight = rep(c(w_a, w_b), c(nrow(A), nrow(B))))
    model = lm(data$y~data$x, data, weight = data$weight)
    coef(model)
  })
  result = list(matrix(c(var(beta[1,]), cov(beta[1,], beta[2,]), 
                    cov(beta[1,], beta[2,]), 
               var(beta[2,])), nrow = 2, ncol = 2), beta)
   return(result)
}

# Randomly Sampling
# Return Variance-Covariance Matrix and beta 0, beta 1.
Sample_all = function(data, number = 1000){
beta = replicate(number,{
data = data[sample(1:nrow(data), nrow(data), replace = TRUE), ]
A = data[data$device=='A',1:2]
B = data[data$device=='B',1:2]
w_a = 1/(1/(nrow(A)-2)*sum(residuals(lm(A$y~A$x, data = A))^2))
w_b = 1/(1/(nrow(B)-2)*sum(residuals(lm(B$y~B$x, data = B))^2))
data = data.frame(rbind(A,B), weight = rep(c(w_a, w_b), c(nrow(A), nrow(B))))
model = lm(data$y~data$x, data, weight = data$weight)
coef(model)
})
result = list(matrix(c(var(beta[1,]), cov(beta[1,], beta[2,]), 
            cov(beta[1,], beta[2,]), 
            var(beta[2,])), nrow = 2, ncol = 2), beta)
return(result)
}

p1_result = Sample_sep(devices)
p1_matrix = p1_result[[1]]
p1_beta0 = p1_result[[2]][1,]
p1_beta1 = p1_result[[2]][2,]
p1_matrix
c(mean(p1_beta0), mean(p1_beta1))



### Part 2
beta = p0_result[[1]]
X = devices
e_a = sample(p0_result[[2]][1:4000], length(p0_result[[2]])-6000, replace = TRUE)
e_b = sample(p0_result[[2]][4001:10000], length(p0_result[[2]])-4000, replace = TRUE)
e = c(e_a, e_b)
Y = beta[1] + beta[2]*X$x + e
X$y = Y
p2_result = Sample_sep(X)
p2_matrix = p2_result[[1]]
p2_beta0 = p2_result[[2]][1,]
p2_beta1 = p2_result[[2]][2,]
p2_matrix
c(mean(p2_beta0), mean(p2_beta1))


### Part 3
# Sampling on one device
essential_one = function(data, type){
  d = data[data$device== type,1:2]
  w = 1/(1/(nrow(d)-2)*sum(residuals(lm(d$y~d$x, data = d))^2))
  data = data.frame(d, weight = rep(w, nrow(d)))
  model = lm(data$y~data$x, data, weight = data$weight)
  return(list(coef(model), residuals(model)))
}

modelA = essential_one(devices, "A")[[2]]
modelB = essential_one(devices, "B")[[2]]
a = rdoublex(4000, mu = 0, lambda = 1/ (4000/sum(abs(modelA))))
b = rdoublex(6000, mu = 0, lambda = 1/ (6000/sum(abs(modelB))))
X = devices
Y = beta[1] + beta[2]*X$x + c(a, b)
X$y = Y
p3_result = Sample_sep(X)
p3_matrix = p3_result[[1]]
p3_beta0 = p3_result[[2]][1,]
p3_beta1 = p3_result[[2]][2,]
p3_matrix
c(mean(p3_beta0), mean(p3_beta1))

### plot
single_plot = function(Beta, title){
  boxplot(Beta, horizontal=TRUE,  outline=FALSE)
  hist(Beta, breaks = 50, prob = TRUE, main = title)
  lines(density(Beta)) + abline(v = mean(Beta), col = "red")
  rug(Beta, col = "red")
}

single_plot(p1_beta0, "Part 1: Beta 0")
single_plot(p1_beta1, "Part 1: Beta 1")
smoothScatter(p1_beta1, p1_beta0, main = "Part 1: Beta 1 vs. Beta 0")

smoothScatter(p2_beta1, p2_beta0, main = "Part 2: Beta 1 vs. Beta 0")
smoothScatter(p3_beta1, p3_beta0, main = "Part 3: Beta 1 vs. Beta 0")
single_plot(p2_beta0, "Part 2: Beta 0")
single_plot(p2_beta1, "Part 2: Beta 1")
single_plot(p3_beta0, "Part 3: Beta 0")
single_plot(p3_beta1, "Part 3: Beta 1")

#Comparison 
betas = data.frame("Method.1" = p1_beta1 + 3 - mean(p1_beta1), 
                   "Method.2" = p2_beta1 + 3 - mean(p2_beta1), 
                   "Method.3" = p3_beta1 + 3 - mean(p3_beta1))
t = melt(betas, variable.name = "Method", value.name = "beta1")
ggplot(t, aes(x = beta1, colour = Method)) + geom_density() + ggtitle("Comparison of Beta 1")


