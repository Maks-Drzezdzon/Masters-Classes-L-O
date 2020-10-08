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
# https://www.xspdf.com/resolution/51757184.html
#1&2 are the same
hos_data = data.frame(read.csv('working_w_data_lab2/Hospital.csv', header = T, col.names = c('date', 'group', 'hospital_HIPE', 'hospital', 'speciality_HIPE', 'speciality','adult_child','age_range', 'time_bands','total')))
colnames(hos_data)
View(hos_data)
?write.csv
?write_delim
answer = hos_data[hos_data$group == ' University of Limerick Hospital Group',]
write.table(answer, file = 'UHL.txt', sep = '\t')
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
ch_city_1 = read.csv('working_w_data_lab2/ch_cities/c1.csv')
ch_city_2 = read.csv('working_w_data_lab2/ch_cities/c2.csv')
ch_city_3 = read.csv('working_w_data_lab2/ch_cities/c3.csv')
ch_city_4 = read.csv('working_w_data_lab2/ch_cities/c4.csv')
ch_city_5 = read.csv('working_w_data_lab2/ch_cities/c5.csv')

write.csv(c(ch_city_1, ch_city_2, ch_city_3, ch_city_4, ch_city_5), file = 'ch_cities.csv')


# 6 untar and save 1000 rows out of 56,000
eu_data = read_tsv(gzfile('working_w_data_lab2/isoc_ec_ibuy.tsv.gz'))
write.csv(eu_data[0:999,], file = 'isoc_ec_ibuy.csv')


# 7
twitter_unzip = unzip('working_w_data_lab2/trainingandtestdata.zip')
twitter = read.csv('training.1600000.processed.noemoticon.csv', header = T, col.names = c( 'polarity','id','date','query','user','tweet'))
colnames(twitter)
