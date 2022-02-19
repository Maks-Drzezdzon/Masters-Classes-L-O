library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)
library(viridis)
library(hrbrthemes)
library(lubridate)
library(reshape2)
library(maps)

CJA12 = read.csv("/Users/maksdrzezdzon/Documents/CJA12.csv", sep= ',' , header=T )
CJA17 = read.csv("/Users/maksdrzezdzon/Documents/CJA17.csv", sep= ',' , header=T )
CJA18 = read.csv("/Users/maksdrzezdzon/Documents/CJA18.csv", sep= ',' , header=T )
CJA19 = read.csv("/Users/maksdrzezdzon/Documents/CJA19.csv", sep= ',' , header=T )
CJA20 = read.csv("/Users/maksdrzezdzon/Documents/CJA20.csv", sep= ',' , header=T )
CJA21 = read.csv("/Users/maksdrzezdzon/Documents/CJA21.csv", sep= ',' , header=T )

CJA12

CJA17 = subset(CJA17, select = -c(STATISTIC, UNIT, C02076V02508, TLIST.A1.))
colnames(CJA17)
CJA17
CJA18 = subset(CJA18, select = -c(STATISTIC, UNIT, C03103V03752, TLIST.A1.))
colnames(CJA18)

CJA19 = subset(CJA19, select = -c(STATISTIC, UNIT, C02480V03003, TLIST.A1.))
colnames(CJA19)

CJA20 = subset(CJA20, select = -c(STATISTIC, UNIT, C02199V02655, TLIST.A1.))
colnames(CJA20)

CJA21 = subset(CJA21, select = -c(STATISTIC, UNIT, C02196V04140, TLIST.A1.))
colnames(CJA21)

test = merge(CJA17, CJA18, by = c("year", "Statistic"))
test
