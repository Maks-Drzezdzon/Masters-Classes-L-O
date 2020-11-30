library(tidyverse)
library(lubridate)
library(data.table)

df = read.table("bank/bank-full.csv", header = T, sep = ";")
drop = c("poutcome", "previous", "pdays", "months", "contact")
df = df[,!(names(df) %in% drop)]
df

