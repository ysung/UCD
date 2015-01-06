setwd("/Users/SUNG/Desktop/STA141/HW5/Data")


# Q1
# shell
# curl http://eeyore.ucdavis.edu/stat141/Data/2013-October.txt.gz -o 2013-October.txt.gz
con = gzfile("2013-October.txt.gz")
data = readLines(con)
data = gsub(">", "", data)


alldata = strsplit(paste0(data, collapse=''), "From:")
alldata = unlist(alldata)
write(alldata,"abc")



#1
#reg = grep(".*From.*at (\\S+.\\w+)", data)
reg = gsub(".*(From: (.*at \\S+\\.\\w+)) .*", '\\2', data)
email = reg[grep(".*(From: (.*at \\S+\\.\\w+)) .*", data)]
email_at = gsub('( at )','@', email)
sort(table(email_at), decreasing = TRUE)[1:15]

#2 US telephone number

# Rough retrieve data
reg = gsub(".*(\\d{3}.*\\D\\d{3}\\-\\d{4}).*", '\\1', data)
phoneall=unique(reg[grep(".*(\\d{3}.*\\D\\d{3}\\-\\d{4}).*", data)])
length
phoneall

# we precise define the regular expression and we get 29 kinds of phone
reg = gsub(".*(\\d{3}(\\)|\\-|\\)\\-|\\s)\\s?\\d{3}\\-\\d{4}).*", '\\1', data)
phone = reg[grep(".*(\\d{3}(\\)|\\-|\\)\\-|\\s)\\s?\\d{3}\\-\\d{4}).*", data)]
length(phone)
phone = unique(phone)
phone


#3 Find all URLs

reg = gsub(".*(http\\S+\\w).*", '\\1', data)
URL = reg[grep(".*(http\\S+\\w).*", data)]
u = grep("(mailman|pipermail|R\\-project)", URL, invert = TRUE)
URL=URL[u]
URL



#4 Find function calls in the mail messages.
reg = gsub(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", '\\2', data)
func = reg[grep(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", data)]
unique(func)


nested = function(data){
  reg1 = gsub(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", '\\1', data)
  reg2 = gsub(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", '\\2', data)
  reg4 = gsub(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", '\\4', data)
  func2 = reg2[grep(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", data)]
  func4 = reg4[grep(".* (([a-zA-Z](\\w|\\.)*)\\((.*)\\)).*", data)]
  return (list(func2, func4))
}

funcname = c()
x = data
while(length(x))
  funcname = c(funcname, nested(x)[[1]])
  x = nested(x)[[2]]
}

unique(funcname)

# Q2
#shell
#cat 2013_*.csv | cut -d ',' -f 15 | egrep 'OAK|SFO|SMF|LAX|JFK'| sort | uniq -c| sort -k 2 > temp
#cat 2013_*.csv | cut -d ',' -f 25 | egrep 'OAK|SFO|SMF|LAX|JFK'| sort | uniq -c| sort -k 2 >> temp
d = read.table("temp")
five_air = data.frame(Airport = d[1:5, 2], Origin = d[1:5, 1], 
                      Destination = d[6:10, 1], Total = d[1:5, 1] + d[6:10, 1])
five_air