setwd("/Users/SUNG/Desktop/STA141/HW4")

#infile = file("logs/JRSPdata_2010_03_10_12_52_37.log", open = "r")
library(ggplot2)
library(grid)
library(reshape2)

##############################################
#Q1
readlog = function(name){
  infile = file(name, open = "r")
  temp = NA
  data = matrix(data = NA, nrow = 0, ncol = 364)
  i = c() # summary of the lines we processed 
  while(TRUE){
    line = readLines(infile, n = 1) # read one line 
    line = strsplit(line, " ")
    line = unlist(lapply(line, function(x) x = x[x!= ""])) 
    # skip "" , or we can use line = strsplit(line, " +")
    
    if(length(line) == 0) # if no data in the line, see as end of file
    {
      print("go to the end of file")
      break
    }
    
    if (line[1] == "##"){
      i = c(i, "Comment")
      temp = NA
      next
    }
    
    else if (length(line) < 7) 
    {
      temp = NA
      next
    }
    
    else if(length(line) == 12)
    {
      i = c(i, "Initial Value of P & L")
      temp = NA
      next
    }
      
    if (line[4] == "position2d" && line[7] == "001"){
      temp = as.numeric(c(line[1], line[8], line[9]))
      if (tail(i, n = 1L) == "Position"){
        i[length(i)] = "Line Skipped"
      }
      i = c(i, "Position")
      next
    } # position: time, x, y
    
    else if (line[4] == "laser" && line[7] == "001" && line[13] == "0361" && !is.na(temp)){
      line = as.numeric(line[14:length(line)]) # pick 361 obervations
      line = line[seq(1, length(line), by = 2)] # skip 0
      temp = c(temp, line) # put two lists together
      data = rbind(data, temp) # put the row into the matrix
      i = c(i, "Laser")
      temp = NA 
      next
    } #laser

    else{
      if (tail(i, n = 1L) == "Position"){
        i[length(i)] = "Line Skipped"
      }
      i = c(i, "Line Skipped")
      temp = NA
      next
    }
  }
  close(infile)
  data = list(data, i)
  return(data)
}

# test the function
log="logs/JRSPdata_2010_03_10_12_52_37.log"
first_log = readlog(log)
dim(first_log[[1]])
table(first_log[[2]])

df = data.frame(Type= unlist(first_log[[2]), Line = c(1:length(first_log[[2]])))
ggplot(df, aes(x = Line, y = Type, fill = Type)) + 
  geom_tile() + ggtitle(paste0("Validation of Log Files\n", log))
typeof(first_log[[2]])

##############################################
#Q2
validate = function(matrix1, list1){
  df = data.frame(Type= unlist(list1), Line = c(1:length(list1)))
  plot1 = ggplot(df, aes(x = Line, y = Type, fill = Type)) + 
    geom_tile() + ggtitle("Validation of Log Files")
  outrange = table(0 <= matrix1[ ,4:364] & matrix1[ ,4:364] <= 2)
  # test if observations are between 0 to 2 or not
  error = table(matrix1[ ,4] == matrix1[ ,364])
  # compare the observations at 0 and 360
  return(list(plot1, table(list1), outrange, error))
}

result = validate(first_log[[1]], first_log[[2]])
result
##############################################
#Q3
readlogs = function(){
  logs = paste0("logs/", list.files(path = "logs/"))
  result = lapply(logs, function(x) readlog(x))
  #vali = sapply(1:length(result), function(x) validate(result[[x]][[1]],result[[x]][[2]]))
  #return(list(result, vali))
  return(result)
}

# time 
ptm <- proc.time()
final = readlogs()
proc.time() - ptm

##############################################
#Q4
robot_sd = sd(unlist(lapply(1:2, function(x) final[[1]][[x]][[1]][,4] - final[[1]][[x]][[1]][,364])))
robot_sd

##############################################
#Q5
lastlines = lapply(1:100, function(x) as.numeric(tail(final[[1]][[x]][[1]], 1)))
showLook = function(data){
  rads = (1:360) *(pi/180)
  x = data[4:363]*cos(rads)
  y = data[4:363]*sin(rads)
  plot(2*cos(rads)+data[2],2*sin(rads)+data[3], type = "l", 
       col = "green", xlim = data[2] + range(-2, 2), 
       ylim = data[3] + range(-2, 2), xlab = "x", ylab = "y",
       main = paste0("Observation of a Robot at (",data[2],", ",data[3],")"))
  lines(x + data[2], y + data[3], lwd = 1.5)
  points(data[2], data[3], col = "green")
  text(data[2], data[3]-0.3, label = paste0(data[2],", ",data[3]), col = "green", cex =0.8)
}
lastlines[,1]
plot.new()
par(mfrow= c(1,1))
showLook(lastlines[,1])

##############################################
#Q6
readlast = function(name){
  infile = file(name, open = "r")
  line = tail(readLines(infile), n = 2L) 
  line = strsplit(line, " ")
  line = lapply(line, function(x) x = x[x!= ""])
  line[[1]] = as.numeric(c(line[[1]][1], line[[1]][8], line[[1]][9]))
  line[[2]] = as.numeric(line[[2]][14:length(line[[2]])]) # pick 361 obervations)
  line[[2]] = line[[2]][seq(1, length(line[[2]])-2, by = 2)] # skip 0, pick 360 obervations
  line = unlist(line)
  close(infile)
  return(line)
}
readlasts = function(){
  logs = paste0("logs/", list.files(path = "logs/"))
  result = sapply(logs, function(x) readlast(x))
  return(result)
}
ob =readlasts()

showLooks = function(multidata){
  sapply(1:4, function(x){
    png(filename = paste0("new_look", x,".png"), width = 2400, 
        height = 2400, pointsize = 20)
    par(mfrow = c(5, 5))
    sapply((1+25*(x-1)):(25+25*(x-1)), function(i) showLook(multidata[,i]))
    dev.off()
  })
}

showLooks(laslines)

##############################################

#Q7
for (x in 2:100){
  data = rbind(data, data.frame(id = paste0("log",x), x = final[[x]][,1], y =final[[x]][,2]))  
}

test =c("log1", "log3", "log20", "log21", "log36", "log48", "log64")
ggplot(data[data$id %in% test,], aes(x = x, y = y))+ geom_line(aes(group=id, colour = id))+
  ggtitle("The Trajectory of The Robots")
