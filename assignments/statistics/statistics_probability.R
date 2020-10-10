library(tidyverse)
# test "Does a parents education correlate with child's academic success/goals"
path = '~/GitHub/Masters-Classes-L-O/assignments/statistics/portfolio_files/'
d1=read.table(paste(path, "student-mat.csv", sep = ""),sep=";",header=TRUE)
d2=read.table(paste(path, "student-por.csv", sep = ""),sep=";",header=TRUE)

d3=merge(d1,d2,by=c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))
print(nrow(d3)) # 382 students
