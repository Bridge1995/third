library(nycflights13)
library(dplyr)
dim(flights)
flights[flights$month==2 & flights$day==2,]
subset(flights, month ==2 & day==2,)
flights[order(flights$year, flights$month, flights$day), ]
flights[order(-flights$year, -flights$month, -flights$day), ]
subset(flights,select=c(year:sched_dep_time))
flights[,1:5,]
slice(flights,1:5)
flights[,-(1:5),]
names(flights)[12] <- "tail_num"
unique("year")
unique(flights,col="year")
tansform(flights,gain = arr_delay - dep_delay)
transform(gain_per_hour = gain / (air_time / 60)