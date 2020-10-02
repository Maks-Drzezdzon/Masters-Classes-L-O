library(tidyverse)
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

# lab 1 tasks
head(ChickWeight)
?ChickWeight
# subset(ChickWeight$weight, ChickWeight$weight == 21)
# find date == 21 for dataset then get weight and last get avg
mean(ChickWeight[ChickWeight$Time == 21,]$weight)
# count number of chicks on each diet
table(ChickWeight$Diet)


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
# later on id want to find a statistical way of quantofying it further

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

