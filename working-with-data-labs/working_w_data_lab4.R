# unzip('bank/bank.zip', list = T)[[1]]
library(tidyverse)

full_file = read.csv('bank/bank-full.csv',sep=";",header=TRUE)
file = read.csv("bank/bank.csv",sep=";",header=TRUE)
# desc_file = read.csv('bank/bank-names.txt')
df = data.frame(full_file)
sum(is.na(df[df$education,]))

# skip rows with missing data
nrow(na.omit(df))

mean(df$duration)
mean(df$age)
mean(df$pdays)

# bottom 10%
quantile(df$age, 0.1)

# 0%, 25%, 50%, 75% and 100%
fivenum(df$age)

# Q75% - Q25%
IQR(df$age)

