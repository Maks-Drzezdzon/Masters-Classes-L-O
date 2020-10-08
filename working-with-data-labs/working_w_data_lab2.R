getwd()
library(tidyverse)
library(xlsx)

# https://en.wikipedia.org/wiki/Tidyverse
random_data = read.table('working_w_data_lab2/randomData.txt', sep = ',', header = T, fill = T, stringsAsFactors = F, col.names = c('id', 'state', 'households', 'moe'))
missing_data = read.table('working_w_data_lab2/missing.txt', sep = ',', header = T, fill = T, stringsAsFactors = F, na.strings = c('', '?', 'NA') )
missing_data_lib = read_csv('working_w_data_lab2/missing.txt', na = c('', '?', 'NA'))
df = read_csv('working_w_data_lab2/data.csv', col_types = 'i_l')
df_2= read.csv('working_w_data_lab2/data.txt')

# function features 
?read.table
head(missing_data)
head(data)
head(random_data)

#ToDo make notes on functions
problems(missing_data_lib)
problems(df_2)



# lab 
#1&2 are the same
hos_data = data.frame(read.csv('working_w_data_lab2/Hospital.csv', header = T, col.names = c('date', 'group', 'hospital_HIPE', 'hospital', 'speciality_HIPE', 'speciality','adult_child','age_range', 'time_bands','total')))
colnames(hos_data)
View(hos_data)
?write.csv
?write_delim
write.table(hos_data, file = 'UHL.txt', sep = '\t')
# 3
stock_portfolio = xlsx::read.xlsx('working_w_data_lab2/stock_portfolio.xlsx', sheetName = '1st period')
write.table(stock_portfolio, file = 'stock_portfolio.txt', sep = ',')

# 4
library(readxl)
# use this for large datasets, since R stores everything in memory it wont load it
# similar to how in python you'd use chunks
athlete_events = read_excel('working_w_data_lab2/athlete_events.xlsx')
read.table('athlete_events.csv')

# 5 




