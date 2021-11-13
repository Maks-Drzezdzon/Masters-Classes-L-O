library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)
library(viridis)
library(hrbrthemes)
library(lubridate)


# lab 7
df = read.csv("/Users/Grim/Documents/GitHub/Masters-Classes-L-O/Data Visualisation/data/studentresult.csv", sep= ',' , header=T )



# Q1
test_marks = sqldf('select Subject, Name, round(Mark_Written) as "Mark Written" from df
group by Name, Subject')

hist(test_marks$`Mark Written`, 
     col="skyblue2", 
     xlab="Mark Ranges for Students",
     main="")

# flip bar chart orientation
qplot(test_marks$`Mark Written`, geom="histogram", xlab="Mark Ranges for Students") + coord_flip()



# lab 8
df = read.csv("/Users/Grim/Documents/GitHub/Masters-Classes-L-O/Data Visualisation/data/studentresult.csv", sep= ',' , header=T )
