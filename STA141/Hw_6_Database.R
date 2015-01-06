


> library(DBI)
> library(RSQLite)
> drv <- dbDriver("SQLite")
con <- dbConnect(drv, "t http://eeyore.ucdavis.edu/stat141/Data/baseball-archive-2011.sqlite.
")