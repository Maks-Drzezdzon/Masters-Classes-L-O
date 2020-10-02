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
# % of crew that survived 
sum(df[df$Survived=='Yes' & df$Class=='Crew',]$Freq) / sum(df$Freq) * 100

# % survived and female
sum(df[df$Survived=='Yes' & df$Sex=='Female',]$Freq) / sum(df$Freq) * 100

# which passenger would you want to be
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
m = sum(df[df$Class=='Crew' & df$Sex=='Male' & df$Survived=='Yes',]$Freq) / sum(df[df$Class=='Crew' & df$Sex=='Male',]$Freq) * 100
# 22.27 % of male crew members survived
f = sum(df[df$Class=='Crew' & df$Sex=='Female' & df$Survived=='Yes',]$Freq) / sum(df[df$Class=='Crew' & df$Sex=='Female',]$Freq) * 100
# 86.9% of female crew members survived 
# id like to be a crew member and female

titanic_df = data.frame(Titanic)
first <- titanic_df[which(titanic_df$Class=='1st'),]
first_survived <- first[which(first$Survived=='Yes'),]
sum(first_survived$Freq)/sum(first$Freq)*100
second <- titanic_df[which(titanic_df$Class=='2nd'),]
second_survived <- second[which(second$Survived=='Yes'),]
sum(second_survived$Freq)/sum(second$Freq)*100
third <- titanic_df[which(titanic_df$Class=='3rd'),]
third_survived <- third[which(third$Survived=='Yes'),]
sum(third_survived$Freq)/sum(third$Freq)*100


sum(df[df$Class=='1st' & df$Survived=='Yes',]$Freq) / sum(df[,]$Freq) * 100

