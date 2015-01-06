setwd("/Users/sung/Desktop/STA141/HW6")

library(DBI)
library(RSQLite)
library(ggplot2)
library(reshape2)
drv = dbDriver("SQLite")
con = dbConnect(drv, "baseball-archive-2011.sqlite")
dbListTables(con)


#5
win_world = dbGetQuery(con, "SELECT yearID, teamID, W, WSWin FROM Teams WHERE yearID >= 1903 AND yearID != 1904 AND yearID != 1994;")
world = ifelse(win_world$WSWin == "Y", 1, 0)
world[is.na(world)] = 0
win = win_world$W
cor(win, world)

#7
team_salary = dbGetQuery(con, "SELECT yearID, teamID, SUM(salary) FROM Salaries GROUP BY teamID, yearID;")
names(team_salary)[3] = "Salary"
names(team_salary)
ggplot(team_salary, aes(x =yearID, y = Salary, colour = teamID)) + geom_line()

#8
#reference to post @776
inflat=read.csv("InflationRate.csv")
info = dbGetQuery(con, "SELECT yearID, teamID, SUM(salary) Salary FROM Salaries GROUP BY teamID, yearID ORDER BY yearID, Salary;")
names(info)[3] = "Salary"
##info
diff(info$Salary)/ info$Salary[-length(info$Salary)]
change = tapply(info$Salary, info$yearID, function(x) mean(diff(x)/x[-length(x)]))
change[is.na(change)]=0
##change
plot(inflat[316:345,1], inflat[316:345,2], type = "l", pch = ".", xlab = "Year", ylab = "Percentage Change",
     main = "Inflation Rate VS. % Change in Salaries")
lines(inflat[316:345,1], change[3:32], col="blue")
legend("topright", legend = c("Inflation Rate", "% Change in Salaries"), fill=c("black", "blue"), lty = 25, text.font=2, pt.cex=2)


#9
# reference to Cookbook for R
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
source('multiplot.R')

#league
content = "SELECT lgID, teamID, SUM(salary) salary FROM Salaries GROUP BY teamID;"
league = dbGetQuery(con, content)
league
AL = league[league$lgID =="AL",2:3]
NL = league[league$lgID =="NL",2:3]
p1 = ggplot(AL, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("American League") + ylim(0,2.5e+09)
p2 = ggplot(NL, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("National League") + ylim(0,2.5e+09)
multiplot(p1, p2, cols=2)

#division
content = "SELECT Salaries.lgID, Salaries.teamID, AVG(Salaries.salary), Teams.divID FROM Teams inner join Salaries ON Salaries.teamID == Teams.teamID GROUP BY Salaries.teamID ORDER BY Salaries.lgID, Teams.divID;"
division = dbGetQuery(con, content)
names(division)[3]= "salary"
ALC = division[division$lgID == "AL" & division$divID == "C",2:3]
ALE = division[division$lgID == "AL" & division$divID == "E",2:3]
ALW = division[division$lgID == "AL" & division$divID == "W",2:3]
NLC = division[division$lgID == "NL" & division$divID == "C",2:3]
NLE = division[division$lgID == "NL" & division$divID == "E",2:3]
NLW = division[division$lgID == "NL" & division$divID == "W",2:3]

p1 = ggplot(ALC, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("American League Central")+ ylim(0, 4e+06)
p2 = ggplot(ALE, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("American League East")+ ylim(0, 4e+06)
p3 = ggplot(ALW, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("American League West")+ ylim(0, 4e+06)
p4 = ggplot(NLC, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("National League Central")+ ylim(0, 4e+06)
p5 = ggplot(NLE, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("National League East")+ ylim(0, 4e+06)
p6 = ggplot(NLW, aes(x = teamID, y = salary, fill = teamID)) + geom_bar() + ggtitle("Nationl League West")+ ylim(0, 4e+06)
multiplot(p1, p2, p3, p4, p5, p6, cols=2)

# payroll
content = "SELECT Salaries.yearID, Salaries.teamID, Max(Salaries.salary), Teams.W FROM Salaries INNER JOIN Teams ON Salaries.teamID == Teams.teamID AND Salaries.yearID == Teams.yearID GROUP BY Salaries.yearID;"
payroll_win = dbGetQuery(con, content)
names(payroll_win)[3] = "salary"
payroll_win = payroll_win[-1,]
payroll_win
ggplot(payroll_win , aes(x = W, y = salary)) + geom_line(colour = "salmon") + geom_point(size = 2, colour = "grey") + 
  geom_text(label = payroll_win$yearID, position = position_jitter(h=1,w=2), size = 3) +
  ggtitle("Maximum Salary vs. Performance in Each Year")


#10
HR = dbGetQuery(con, "SELECT yearID, SUM(HR) FROM Teams GROUP BY yearID;")
HR40 = dbGetQuery(con, "SELECT yearID, COUNT(HR) FROM Batting WHERE HR >=40 GROUP BY yearID;")

plot(HR[,1], HR[,2], type="l", col="red", xlab = "Year", ylab = "Total Home Run", main = "HR in Each Year of MLB")
points(HR[136, 1], HR[136, 2], col = "blue", cex = 1.0)
text(HR[120, 1], HR[137, 2], labels="Joint Drug Prevention and\n Treatment Program Start", cex = .5)

plot(HR40[, 1], HR40[, 2], type="l", col="red", xlab = "Year", ylab = "Number of Home Run more than 40", main = "HRs(more than 40) in Each Year of MLB")
points(HR40[73, 1], HR40[73, 2], col = "blue", cex = 1.0)
text(HR40[60, 1], HR40[73, 2], labels="Joint Drug Prevention and\n Treatment Program Start", cex = .5)
w


