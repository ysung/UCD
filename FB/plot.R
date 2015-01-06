setwd("/Users/sung/Dropbox/toJasper")
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(gridExtra)
source("multiplot.R")
library(plyr)


factor_to_int = function (data)
{
  return(as.numeric(as.character(data)))
}

dataset = function (input)
{
  data = read.csv(input, header = FALSE)
  data= data[1:100,]
  names(data) = c("Type" ,"Affective.processes", "Cognitive.processes", "Biological.processes")
  data$Affective.processes=as.numeric(as.character(data$Affective.processes))
  return (data)
}

# Cogntive Processes vs. Affective Processes
AC_cor=function(data)
{
  ggplot(data, aes(Affective.processes, Cognitive.processes)) + aes(shape = factor(Type)) + 
    geom_point(aes(colour = factor(Type)), size = 4) + geom_point(colour="grey90", size = 1.7) +
    #geom_density2d(aes(colour = factor(Type))) +
    #scale_fill_continuous(name = "Type") +
    theme(legend.title=element_blank()) +
    xlab("Affective Processes") +
    ylab("Cognitive Processes")
  #ggtitle("Plant growth with\ndifferent treatments")
  
}

g_legend<-function(a.gplot)
  {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

fancy = function(data)
{
  cols = brewer.pal(3, 'Set1')
  p <- ggplot(data, aes(Affective.processes, Cognitive.processes, colour = Type)) + 
    aes(shape = Type) + geom_point() + scale_color_manual(values=cols) + 
    theme(legend.title=element_blank()) + # delete legend title
    ylab("TCFC") +
    xlab("TAFC") +
    #geom_abline(intercept = 0.034, slope = 1.45) #muplus
    geom_abline(intercept = -0.667, slope = 30) #stdplus
  p1 <-  p + theme(legend.position = "none")
  p2 <- ggplot(data, aes(x=Affective.processes, group=Type, colour=Type)) + scale_color_manual(values=cols) +
    stat_density(fill = NA, position="dodge") + ylab("Density") +
    theme(legend.position = "none", axis.title.x=element_blank(), 
          axis.text.x=element_blank())
  p3 <- ggplot(data, aes(x=Cognitive.processes, group=Type, colour=Type)) + scale_color_manual(values=cols) +
    #geom_density(binwidth=1, alpha=0.3, position="identity") +
    stat_density(fill = NA, position="dodge") + coord_flip() + ylab("Density") +
    theme(legend.position = "none", axis.title.y=element_blank(), 
          axis.text.y=element_blank())
  
  legend <- g_legend(p)
  grid.arrange(arrangeGrob(p2, legend, p1, p3, widths=unit.c(unit(0.75, "npc"), unit(0.25, "npc")), heights=unit.c(unit(0.25, "npc"), unit(0.75, "npc")), nrow=2))
  
}

bcg =function(data)
{
  p1 = ggplot(data, aes(x=Affective.processes,fill = Type)) + xlim(0, 0.2) +
    geom_density(binwidth= 0.01, alpha=0.3, position="identity") + theme(legend.title=element_blank()) +
    xlab("TAPL") +
    ylab("Density")
  
  p2 = ggplot(data, aes(x=Cognitive.processes,fill = Type)) + xlim(0, 0.2) +
    geom_density(binwidth=0.01, alpha=0.3, position="identity") + theme(legend.title=element_blank()) +
    xlab("TCPL") +
    ylab("Density")
  
  p3 = ggplot(data, aes(x=Biological.processes,fill = Type)) + xlim(0, 0.2) +
    geom_density(binwidth=0.01, alpha=0.3, position="identity") + theme(legend.title=element_blank()) +
    xlab("TBPL") +
    ylab("Density")
  multiplot(p1, p2, p3, cols= 1)
  
}


highestpost = function(data, post, num = nrow(h_data))
{
  h_data = data[data$V2 == post,][,c(5,6,7)]
  h_mean = sapply(1:num,function(x)
    cbind(sum(h_data$V6[1:x])/sum(h_data$V5[1:x]), sum(h_data$V7[1:x])/sum(h_data$V5[1:x]))
  )
  nrow(h_data)
  hh = data.frame(Affective.processes = h_mean[1,], Cognitive.processes = h_mean[2,], Count = c(1:num))
  hh = melt(hh, id.vars='Count')
  dim(hh)/2
  
  ggplot(hh, aes(x= Count, y=value, colour = variable)) +
    geom_line(size = 1) + xlab("Comments") + ylab("Average") +
    theme(legend.title=element_blank()) +
    scale_color_hue(breaks = c("Affective.processes", "Cognitive.processes"),
                       labels=c("Affective Processes Ratio", "Cognitive Processes Ratio"))
}


#BCG
forKeith_CBS_News = read.csv("forKeith_CBS_News.txt", header = FALSE)
forKeith_Google = read.csv("forKeith_Google.txt",header = FALSE)
forBarack_Obama = read.csv("forKeith_Barack_Obama.txt",header = FALSE)

a = count(forKeith_Barack_Obama, "V2")
b = count(forKeith_CBS_News, "V2")
a = a[order(-b$freq),]
# "6815841748_10150248859341749"
b = b[order(-b$freq),]
# "131459315949_258787387494610"

#highpost
highestpost(forKeith_Barack_Obama, "6815841748_10150248859341749")
highestpost(forKeith_Barack_Obama, "6815841748_10150248859341749", 300)
highestpost(forKeith_CBS_News, "131459315949_258787387494610")
highestpost(forKeith_CBS_News, "131459315949_258787387494610", 500)




forKeith_Barack_Obama = read.csv("forKeith_Barack_Obama.txt",header = FALSE)
forKeith_Barack_Obama = cbind(forKeith_Barack_Obama, Type = rep("Barack Obama",nrow(forKeith_Barack_Obama)))
forKeith_Google = cbind(forKeith_Google, Type = rep("Google",nrow(forKeith_Google)))                            
forKeith_CBS_News = cbind(forKeith_CBS_News, Type = rep("CBS News",nrow(forKeith_CBS_News)))
data = rbind(forKeith_Barack_Obama, forKeith_CBS_News, forKeith_Google)
names(data) = c("Comment.Counts" ,"Affective.processes", "Cognitive.processes", "Null", "Biological.processes", "Type")
names(forKeith_CBS_News) = c("Comment.Counts" ,"Affective.processes", "Cognitive.processes", "Null", "Biological.processes")#, "Type")
names(forKeith_Google) = c("Comment.Counts" ,"Affective.processes", "Cognitive.processes", "Null", "Biological.processes")#, "Type")
names(forKeith_Barack_Obama) = c("Comment.Counts" ,"Affective.processes", "Cognitive.processes", "Null", "Biological.processes")#, "Type")

henmean = function(data)
{
  m = sapply (1:1000, function(i)
    cbind(mean(data$Affective.processes[data$Comment.Counts>=i]) 
    ,sd(data$Affective.processes[data$Comment.Counts>=i]))
  )
  return (m)
}

cbs = henmean(forKeith_CBS_News)
forKeith_Google[forKeith_Google$Comment.Counts==max(forKeith_Google$Comment.Counts),]
goo = henmean(forKeith_Google)
oba = henmean(forKeith_Barack_Obama)
c(cbs[1,], goo[1,], oba[1,]), 
meansd = data.frame(Greater = rep(1:1000,3), Mean = c(cbs[1,], goo[1,], oba[1,]), SD = c(cbs[2,], goo[2,], oba[2,]), Type = rep(c("CBS", "Google", "Barack Obama"), c(1000, 1000, 1000)))


plot_comment = function(data)
{
  ## add extra space to right margin of plot within frame
  par(mar=c(5, 4, 4, 6) + 0.1)
  
  ## Plot first set of data and draw its axis
  plot(meansd$Greater[meansd$Type =="CBS"], meansd$Mean[meansd$Type =="CBS"], axes=FALSE, ylim=c(0, max(meansd$Mean[meansd$Type =="CBS"])), xlab="", ylab="", 
       type="p",col="#34AADC", alpha=.1)
  axis(2, ylim=c(0, 0,max(meansd$Mean[meansd$Type =="CBS"])),col="black",las=1)  ## las=1 makes horizontal labels
  mtext("Mean",side=2,line=2.5)
  lol <- loess(meansd$Mean[meansd$Type =="CBS"]~meansd$Greater[meansd$Type =="CBS"])
  lines(predict(lol), col='blue', lwd=2)
  
  box()
  
  ## Allow a second plot on the same graph
  par(new=TRUE)
  
  ## Plot the second plot and put axis scale on right
  plot(meansd$Greater[meansd$Type =="CBS"], meansd$SD[meansd$Type =="CBS"],  xlab="", ylab="", ylim=c(0, max(meansd$SD[meansd$Type =="CBS"])), 
       axes=FALSE, type="p", col="#FF4981", alpha=.1)
  ## a little farther out (line=4) to make room for labels
  mtext("Standard Deviation",side=4,col="red",line=4) 
  axis(4, ylim=c(0, max(meansd$SD[meansd$Type =="CBS"])), col="red",col.axis="red",las=1)
  
  ## Draw the time axis
  #axis(1,pretty(meansd$Greater,10))
  axis(1,pretty(1:max(meansd$Greater),n = 10))
  mtext("Comments",side=1,col="black",line=2.5)  
  lo <- loess(meansd$SD[meansd$Type =="CBS"]~meansd$Greater[meansd$Type =="CBS"])
  lines(predict(lo), col='darkred', lwd=2)
  
  
  ## Add Legend
  legend("bottomright",legend=c("Mean","Standard Deviation"),
         text.col=c("black","red"),pch=c(16,15),col=c("black","red"))
  
}




ggplot(meansd, aes(Greater, SD, colour = Type)) +
  geom_line(size=1)

ggplot(meansd, aes(Greater, Mean, colour = Type)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1) +
  ggtitle("Fitted growth curve per diet")


geom_smooth(aes(ymin = lcl, ymax = ucl), data=grid, stat="identity")

 #geom_path(alpha = 0.5)







#bcg
stdplus = dataset("stdPlus.csv")
stdplus$Type=as.character(stdplus$Type)
stdplus$Type[stdplus$Type == "Politics"] = "Politics-related"
stdplus$Type[stdplus$Type == "Non-politics"] = "Non-politics-related"
stdplus
stdplus$Affective.processes = factor_to_int(stdplus$Affective.processes)
stdplus$Cognitive.processes = factor_to_int(stdplus$Cognitive.processes)
stdplus$Biological.processes = factor_to_int(stdplus$Biological.processes)
bcg(stdplus)

muPlus = dataset("muPlus.csv")
muPlus$Type=as.character(muPlus$Type)
muPlus$Type[muPlus$Type == "Politics"] = "Politics-related"
muPlus$Type[muPlus$Type == "Non-politics"] = "Non-politics-related"

muPlus$Affective.processes = factor_to_int(muPlus$Affective.processes)
muPlus$Cognitive.processes = factor_to_int(muPlus$Cognitive.processes)
muPlus$Biological.processes = factor_to_int(muPlus$Biological.processes)
bcg(muPlus)

data$Affective.processes = factor_to_int(data$Affective.processes)
data$Cognitive.processes = factor_to_int(data$Cognitive.processes)
data$Biological.processes = factor_to_int(data$Biological.processes)
#data_up = data[data$Comment.Counts > 10,]
#data_below = data[data$Comment.Counts <= 10,]
n <- 10
data_top10 = data[data$Comment.Counts > quantile(data$Comment.Counts,prob=1-n/100),]
data_down90 = data[data$Comment.Counts <= quantile(data$Comment.Counts,prob=1-n/100),]
#bcg(data_below)
#bcg(data_up)
bcg(data_top10) 
bcg(data_down90)
bcg(data)



stdplus
# AC map
AC_cor(stdplus)
AC_cor(averageLL)
AC_cor(muPlus)
AC_cor(threshold)
AC_cor(rho)


# fancy graph
rho = dataset("rho.csv")
stdplus = dataset("stdPlus.csv")
stdplus$Type = as.character(stdplus$Type)
stdplus$Type[stdplus$Type=="News"] = "Politics"

averageLL = dataset("averageLL.csv")
muPlus = dataset("muPlus.csv")
muPlus$Type = as.character(muPlus$Type)
muPlus$Type[muPlus$Type=="News"] = "Politics"
threshold = dataset("threshold.csv")
names(muPlus)
fancy(stdplus)
fancy(averageLL)
fancy(muPlus)
fancy(threshold)
fancy(rho)

＃#Type Affective.processes Cognitive.processes Biological.processes


# Distribution Histogram
p1 = ggplot(stdplus, aes(x=Affective.processes,fill = Type)) + xlim(0, 1) +
  geom_density(binwidth=1, alpha=0.3, position="identity") #+ theme(legend.position = "none") 
p2 = ggplot(stdplus, aes(x=Cognitive.processes,fill = Type)) + xlim(0, 1) +
  geom_density(binwidth=1, alpha=0.3, position="identity") #+ theme(legend.position = "none")
p3 = ggplot(stdplus, aes(x=Biological.processes,fill = Type)) + xlim(0, 1) +
  geom_density(binwidth=1, alpha=0.3, position="identity") #+ theme(legend.text=element_text(size=0.1))

multiplot(p1, p2, p3, cols= 1)

library(e1071)

la = read.csv("newdata/forKeith_Occupy_LosAngeles.txt", header = FALSE)
goo = read.csv("newdata/forKeith_Google.txt", header = FALSE)
names(la) = c("Comments", "AP", "CP", "V4", "V5")
names(goo) = c("Comments", "AP", "CP", "V4", "V5")
dat = la[la$Comments<=10,]
#grid = with(dat, seq(min(AP), max(AP), length = 99999))
normaldens = data.frame(predicted = seq(0,max(dat$AP),by=0.01), density = dnorm(seq(0,max(dat$AP),by=0.01), mean=mean(dat$AP), sd=sd(dat$AP)))
ggplot(dat, aes(x=AP)) + geom_histogram(aes(y = ..density..), binwidth = 0.025, fill = "#FF9500", colour = "black") +
  geom_line(data = normaldens, aes(x = predicted, y = density), colour = "black") + 
  scale_x_continuous(breaks=c(seq(0, 1, by=0.1))) # + scale_y_continuous(breaks=c(seq(0, 20, by=2)))



ggplot(la[la$Comments>2,], aes(x=AP)) + 
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666")  # Overlay with transparent density plot

#sd(goo$V2[goo$V1>2])
#sd(goo$V3[goo$V1>2])




#svm
library(e1071)
example("svm")
model = svm(goo$V3[goo$V1>2], goo$V3[goo$V1>2])

all = stdplus[stdplus$Type!="News", c(2,3,4,1)]
all$Type <- factor(all$Type)
y = all$Type[all$Type!="News"]
x = all[,c(1,2,3)]
model <- svm(x, y, kernel = "linear")
pred_result <- predict(model, x)
table(pred_result,y)
  plot(model, all, Affective.processes ~ Cognitive.processes, slice = list(Affective.processes = 1, Cognitive.processes= 2),
       color.palette = terrain.colors)
plot(all$Affective.processes, all$Cognitive.processes)

print(model)
data(iris)
xx <- subset(iris, select = -Species)
yy <- iris$Species
xx
drop.levels(all)

plot(model, iris, Sepal.Width ~ Petal.Width,
     slice = list(Sepal.Length = 3, Petal.Length = 4),color.palette = terrain.colors)
