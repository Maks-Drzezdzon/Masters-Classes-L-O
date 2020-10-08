getwd()
library(tidyverse)
# https://en.wikipedia.org/wiki/Tidyverse
random_data = read.table('working_w_data_lab2/randomData.txt', sep = ',', header = T, fill = T, stringsAsFactors = F, col.names = c('id', 'state', 'households', 'moe'))
missing_data = read.table('working_w_data_lab2/missing.txt', sep = ',', header = T, fill = T, stringsAsFactors = F, na.strings = c('', '?', 'NA') )
missing_data_lib = read_csv('working_w_data_lab2/missing.txt', na = c('', '?', 'NA'))

# function features 
?read.table
head(missing_data)
head(data)
head(random_data)
missing_data_lib
