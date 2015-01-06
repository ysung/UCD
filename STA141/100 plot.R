#plot----------------------------------------------------------------------------------

#pick out the last data of each log file
last.seq <- cumsum(tapply(total.data$filename, total.data$filename, length))
last.data <- total.data[last.seq, ]

#calculate the intensity for plotting
I <- subset(last.data, select=c(d1:d360))

Ifunction <- function (n) 
{
  for(i in 1:n) {
    I.1 <- unname(unlist(I[i, ]))
    I.2 <- as.numeric(as.character(I.1))
  }
  return(I.2)
}

I.range <- seq(1, nrow(last.data))
I.3 <- sapply(I.range, function(x) Ifunction(x))

rads <- (1:360)*(pi/180)

##calculate the coordinate of the center of circle (where the robot is standing)
#x
c.x <- subset(last.data, select = x)
rownames(c.x) <- NULL
center.x <- as.numeric(as.character(unlist(c.x)))
class(center.x)

#y
c.y <- subset(last.data, select = y)
rownames(c.y) <- NULL
center.y <- as.numeric(as.character(unlist(c.y)))
class(center.y)

#coordinate for robot view
xfunction <- function(n){
  for (i in 1:n){
    x <- I.3[ ,i]*cos(rads) + center.x[i]
  }
  return(x)
}
x.1 <- sapply(I.range, function(x) xfunction(x))

yfunction <- function(n){
  for (i in 1:n){
    y <- I.3[ ,i]*sin(rads) + center.y[i]
  }
  return(y)
}
y.1 <- sapply(I.range, function(x) yfunction(x))

#coordinate for circle outside the robot view
xfunction2 <- function(n){
  for (i in 1:n){
    x <- 2*cos(rads) + center.x[i]
  }
  return(x)
}
x.2 <- sapply(I.range, function(x) xfunction2(x))

yfunction2 <- function(n){
  for (i in 1:n){
    y <- 2*sin(rads) + center.y[i]
  }
  return(y)
}
y.2 <- sapply(I.range, function(x) yfunction2(x))

#coordinate of where the robot is standing
last.data$group <- paste("(", last.data$x, ",", last.data$y, ")")

#plot
png(filename = "C:\\Users\\user\\Documents\\UCD\\2013 Fall\\STA 141\\HW4\\robot3.png", width = 2400, height = 2400, pointsize = 20)

par(mfrow = c(10, 10))

for (i in 1:length(I.range)){
  plot(x.2[ , i], y.2[ , i], type = "l", xlab = "x", ylab = "y", col = "green"
       , xlim = range(c(x.1[ , i], x.2[ , i])), ylim = range(c(y.1[ , i], y.2[ , i])))
  
  #overlay the view of robot on top of the circle
  par(new = TRUE)
  plot(x.1[ , i], y.1[ , i], type = "l", xlab = "x", ylab = "y"
       , xlim = range(c(x.1[ , i], x.2[ , i])), ylim = range(c(y.1[ , i], y.2[ , i])))
  draw.circle(center.x[i], center.y[i], radius = 0.03, nv = 100, border = "green", lty = 1, lwd = 1)
  title(main = last.data$group[i])
}

dev.off()