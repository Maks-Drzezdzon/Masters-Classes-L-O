install.packages (c ( "tm", "wordcloud", "RCurl", "XML", "SnowballC")) # install 'tm'' package

library(tm)
library(wordcloud)
library(SnowballC)

source("htmlToText.R")


data_1 = htmlToText("http://oralytics.com")
# data_2 = htmlToText("http://www.rte.ie/news") # its dead
data_3 = htmlToText("http://www.tudublin.ie")

data_merge = c(data_3, data_1)
