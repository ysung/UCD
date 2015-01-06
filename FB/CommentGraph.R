library(ggplot2)
library(reshape2)
library(RColorBrewer)
 
read_data <- function(name){
  data <- read.csv(paste0("./data/", name), header = FALSE)
  names(data) <- c("observation", "type", "freq")
  data <- data[-nrow(data), ]
  data$type <- rep(c("01-05", "06-10", "11-15", "16-20", "21-25", "26-30", "31-35", "36-40", "41-45", "46-50", "51+") , 30*2*500)
  # ob = rawdata$observation
  data$observation <- rep(1:(nrow(data)/11), each = 11)
  return (data)
}

CommentGraph <- setRefClass("CommentGraph",
                       fields = list(rawdata = "data.frame", filename = "character"),
                       methods = list(
                         chiTable = function(rawdata, rnums = 500, cnums = 30){
                           cross.table = xtabs(freq ~ observation + type, data = rawdata)
                           results <- c( )
                           chi_results <- sapply(seq(1, nrow(cross.table), 2), function(x) {
                             chisq.test(cross.table[x:(x+1), ])$statistic
                           })
                           chi_results[is.nan(chi_results)] <- -10
                           results_table <- matrix(chi_results, nrow = 500, ncol = 30)
                           rownames(results_table) = c(1:500)
                           return (results_table)
                         },  
                         
                         chiHeatmap = function(Mins = 500, Comments = 30, m = 5, c = 1, out.w = 48, out.h = 4){
                           filename <<- gsub("(.*).csv", "\\1", filename)
                           subtable <- chiTable(rawdata)[c(5,10,15,20,25,30,35,40,45,50), 1:Comments]
                           results_table.m <- melt(subtable)
                           mytitle = paste0(filename, "_", Mins, "_", Comments)
                           ggplot(results_table.m, aes(Var1, Var2)) + geom_tile(aes(fill = value), colour = "white") +
                             scale_fill_gradient(low = "green", high = "red", limits=c(0, 800)) + 
                             labs(fill = "Chi Square Values") + ylab("Comments") + xlab("Mins") + 
                             scale_x_continuous(breaks = seq(0, Mins, m)) +
                             scale_y_continuous(breaks = seq(0, Comments, c)) +
                             ggtitle(mytitle)
                           ggsave(paste0(mytitle, ".eps"), width = out.w, height = out.h)
                           #500_100: w48 h4, 100_20: w16 h4, 50_10: w18 h4
                           #setEPS()
                           #postscript("whatever.eps", title = "test", width = 8, height = 6)
                           },
                         
                         simpleGraph = function(){
                           results_table <- chiTable(rawdata)
                           max_chi <- sapply(1:ncol(results_table), function(x)
                             max(results_table[, x])
                           )
                           setEPS()
                           mytitle <- paste("The Maximum Chi-Square Values in", filename)
                           out_max <- paste0(filename, "_", "Max", ".eps")
                           postscript(out_max, width = 8, height = 6)
                           plot(max_chi, xlab = "Comments", ylab = "Chi-Square Values",
                                main = mytitle)
                           lines(max_chi)
                           dev.off()
                           
                           which_max_chi <- sapply(1:ncol(results_table), function(x)
                             which(results_table[, x] == max(results_table[, x]))[1]
                           )
                           setEPS()
                           mytitle <- paste("The Mins Occur The Maximum Chi-Square Values \n of ", filename)
                           out_max <- paste0(filename, "_Max_Index", ".eps")
                           postscript(out_max, width = 8, height = 6)
                           plot(which_max_chi, xlab = "Comments", ylab = "Mins",
                                main = mytitle)
                           lines(which_max_chi)
                           dev.off()
                         }
                       )
)
