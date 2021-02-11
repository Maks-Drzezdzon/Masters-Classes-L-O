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

# data viz
# grammar of graphics book
library('ggplot2')
?mpg
# 6 points dont follow the trend 
# red dots
qplot(data = mpg, x = displ, y = hwy, color = I('red'))
# well.. size
qplot(data = mpg, x = displ, y = hwy, size = I(0.25), geom = 'smooth')
# transparency 
qplot(data = mpg, x = displ, y = hwy, alpha = I(0.1))
# x over dot
qplot(data = mpg, x = displ, y = hwy, shape = I(4))
# color dots by its category and div by category in drv
qplot(data = mpg, x = displ, y = hwy, color = class) + facet_grid(drv ~ .)



