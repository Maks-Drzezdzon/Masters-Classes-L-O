library(dplyr)
library(ggplot2)

births = read.csv('births.csv')
baby_names = data.frame(read.csv('bnames.csv'))

df_baby_names = data.frame(baby_names)

filter(baby_names, name == 'John')
select(baby_names, name, year, sex)
head(arrange(baby_names, name, year))
head(summarise(baby_names, name, year))
