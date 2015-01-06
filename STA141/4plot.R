par(mfrow = c(2, 2))
p_title =c("psi = 0, b1_1 = 0, b1_2 = 0", "psi = 0.9, b1_1 = 0, b1_2 = 0", "psi = 0.9, b1_1 = 0.01, b1_2 = 0.01", "psi = 0.9, b1_1 = -0.01, b1_2 = 0")
for (i in 1:4){
  plot(c(1:4000), result[,1+(i-1)], type ="l", col = "red", 
       xlab = "Time", ylab = "Price", main = p_title[i], ylim =c(70, 150)) 
  lines(result[, 2+(i-1)], col = "blue") 
  legend("topleft", legend = c("Y1", "Y2"), fill=c("red", "blue"), lty = 2, title = "Stock", cex=0.5, text.font=2, pt.cex=2)#, pt.lwd=2, pt.cex=2)
}
