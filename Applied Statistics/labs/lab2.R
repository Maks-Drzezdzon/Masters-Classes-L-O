library(pastecs) #For creating descriptive statistic summaries
library(ggplot2) #For creating histograms with more detail than plot
library(psych) # Some useful descriptive functions
library(semTools) #For skewness and kurtosis
library(FSA) #For percentage
library(car) # For Levene's test for homogeneity of variance 
library(effectsize) #To calculate effect size for t-test

setwd("~/GitHub/Masters-Classes-L-O/Applied Statistics/data_stats/")
getwd()
data = read.csv("bf_study.csv")
data
scatter_plot = ggplot(data, aes(x=`body_fat`,
                                y=`neck_circumference`, 
                                color = 'body fat', show.legend = T)) + geom_point(size=2) + geom_smooth(method = "lm", se = FALSE)
scatter_plot

lin_reg = lm(`neck_circumference`~`body_fat`, data=data)
lin_reg
summary(lin_reg)
