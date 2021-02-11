library(tidyverse)
library(ratios)
vignette("tibble")

# https://learning.oreilly.com/library/view/r-for-data/9781491910382/ch07.html

name = c('mx', 'mel')
age = c(24, 22)

user_df = data.frame(name, age)
user_df
# read only excel like view of data frame
View(user_df)
# sets in R
factor(c(1, 2, 3, 3, 4, 4, 1), levels = c('1', '2', '3', '4'))

#
#
# lab 1 tasks
head(ChickWeight)
?ChickWeight
# subset(ChickWeight$weight, ChickWeight$weight == 21)
# find date == 21 for dataset then get weight and last get avg
mean(ChickWeight[ChickWeight$Time == 21,]$weight)
# count number of chicks on each diet
table(ChickWeight$Diet)

#
#
# covert to df
?Titanic
df = data.frame(Titanic)
head(df)
# 23.95% of crew that survived 
sum(df[df$Survived=='Yes' & df$Class=='Crew',]$Freq) / sum(df[df$Class=='Crew',]$Freq) * 100

# 2.2% crew survived and female
sum(df[df$Class=='Crew' & df$Sex=='Female' & df$Survived=='Yes',]$Freq) / sum(df[df$Class=='Crew',]$Freq) * 100

# which passenger would you want to be, id like to be a 1st class passenger and female,
# I'd have 97.2% chance to be part of the group with the second highest chance of surviving which is the 1st class passengers at 9.22%
# second in line would be female and crew member with 86.9% out of 9.63%
# 0.41% group survival isnt worth the 9.9% difference of being part of it

# ToDo
# later on id want to find a statistical way of quantifying it further

survived_perecent = sum(df[df$Survived=='Yes',]$Freq) / sum(df$Freq) * 100 # 32.3 survived

first = sum(df[df$Survived=='Yes' & df$Class=='1st',]$Freq) / sum(df$Freq) * 100 # 9.22
second = sum(df[df$Survived=='Yes' & df$Class=='2nd',]$Freq) / sum(df$Freq) * 100 # 5.3
third = sum(df[df$Survived=='Yes' & df$Class=='3rd',]$Freq) / sum(df$Freq) * 100 # 8.08
crew = sum(df[df$Survived=='Yes' & df$Class=='Crew',]$Freq) / sum(df$Freq) * 100 # 9.63

crew_size = sum(df[df$Class=='Crew',]$Freq)
sum(df[df$Class=='Crew' & df$Sex=='Male' & df$Survived=='Yes',]$Freq) / crew_size * 100
sum(df[df$Class=='Crew' & df$Sex=='Female' & df$Survived=='Yes',]$Freq) / crew_size * 100

# more male crew members survived but there was also more of them
# % of own sex surv rate
sum(df[df$Class=='Crew' & df$Sex=='Male' & df$Survived=='Yes',]$Freq) / sum(df[df$Class=='Crew' & df$Sex=='Male',]$Freq) * 100
# 22.27 % of male crew members survived
sum(df[df$Class=='Crew' & df$Sex=='Female' & df$Survived=='Yes',]$Freq) / sum(df[df$Class=='Crew' & df$Sex=='Female',]$Freq) * 100
# 86.9% of female crew members survived 

sum(df[df$Survived=='Yes' & df$Class=='1st' & df$Sex=='Male',]$Freq) / sum(df[df$Class=='1st' & df$Sex=='Male',]$Freq) * 100 # 34.4
sum(df[df$Survived=='Yes' & df$Class=='1st' & df$Sex=='Female',]$Freq) / sum(df[df$Class=='1st' & df$Sex=='Female',]$Freq) * 100 # 97.2

#
#
# Iris data set
?iris
df = data.frame(iris)
head(df)

mean(df[df$Petal.Length & df$Species=='virginica',]$Petal.Length / df[df$Sepal.Length & df$Species=='virginica',]$Sepal.Length)

virginica = df[df$Species=='virginica',]

avg = c(mean(virginica$Sepal.Length), mean(virginica$Sepal.Width), mean(virginica$Petal.Length), mean(virginica$Petal.Width))
names(avg) = c('Sepal.Length', 'Sepal.Width', 'Petal.Length', 'Petal.Width')
avg

#
#
# mtcars
?mtcars
df = data.frame(mtcars)
head(df)
cars = df[df$am==1,]
row.names(cars)


#
#
# occupationalStatus data set, find most shared occupation by sons and fathers
?occupationalStatus
df = data.frame(occupationalStatus)
head(df)
# a data frame in this case makes things harder, so ill use the dataset as is
# max(df[row(df)==col(df)])
max(occupationalStatus[row(occupationalStatus)==col(occupationalStatus)])


#
#
# ggplot2::mpg data set, diff between numeric cols
?ggplot2::mpg
data_set = ggplot2::mpg
df = data.frame(ggplot2::mpg)
head(df)
# get list of numeric values
# ToDo plot this
nums = unlist(lapply(df, is.numeric))

yr_1999 = colMeans(df[df$year==1999, nums])
yr_2008 = colMeans(df[df$year==2008, nums])
View(yr_1999, 'year 1999 avgs')
View(yr_2008, 'year 2008 avgs')
change_over_9_yrs = yr_2008 - yr_1999
View(change_over_9_yrs, 'change_over_9_yrs')


#
#
# lubridate::lakers data set missing values for x, y and both
library(lubridate)
?lubridate::lakers
df = data.frame(lubridate::lakers)
head(df)

missing_x = sum(is.na(df$x))/length(df$x)*100
missing_y = sum(is.na(df$y))/length(df$y)*100
(sum ( is.na(df$x) ) + sum( is.na(df$y) ) ) / (length( df$x ) + length( df$y ) )*100

#
#
# nycflights13::flights data set avg, min, max delay for arrival and departure for each month
?nycflights13::flights
df = data.frame(nycflights13::flights)
head(df)

avg_departure_delay = tapply( df$dep_delay, df$month, mean, na.rm=TRUE)
avg_arrival_delay = tapply( df$arr_delay, df$month, mean, na.rm=TRUE)

max_departure_delay = tapply( df$dep_delay, df$month, max, na.rm=TRUE)
max_arrival_delay = tapply( df$arr_delay, df$month, max, na.rm=TRUE)

min_departure_delay = tapply( df$dep_delay, df$month, min, na.rm=TRUE)
min_arrival_delay = tapply( df$arr_delay, df$month, min, na.rm=TRUE)

