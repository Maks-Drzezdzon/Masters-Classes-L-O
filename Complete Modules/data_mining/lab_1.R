install.packages (c ( "tm", "wordcloud", "RCurl", "XML", "SnowballC")) # install 'tm'' package

library(tm)
library(wordcloud)
library(SnowballC)

source("htmlToText.R")


data_1 = htmlToText("http://oralytics.com")
data_2 = htmlToText("http://www.rte.ie/news") # its dead
data_3 = htmlToText("http://www.tudublin.ie")

data_merge = c(data_3, data_1)

txt_corpus = Corpus(VectorSource(data_merge))
summary(txt_corpus)
tm_map <- tm_map (txt_corpus, stripWhitespace) # remove white space
tm_map <- tm_map (tm_map, removePunctuation) # remove punctuations
tm_map <- tm_map (tm_map, removeNumbers) # to remove numbers
tm_map <- tm_map (tm_map, removeWords, stopwords("english")) # to remove stop words(like 'as' 'the' etc..)
tm_map <- tm_map (tm_map, stemDocument)
tm_map <- tm_map (tm_map, removeWords, c("work", "use", "java", "new", "support"))
inspect(tm_map)
Matrix <- TermDocumentMatrix(tm_map) # terms in rows
matrix_c <- as.matrix (Matrix)
freq <- sort (rowSums (matrix_c)) # frequency count of the data
freq #view the words and their frequencies
tmdata <- data.frame (words=names(freq), freq)
wordcloud (tmdata$words, tmdata$freq, max.words=100, min.freq=3, scale=c(7,.5), random.order=FALSE, colors=brewer.pal(8, "Dark2"))

# Do later maybe
# Use the code (and if needed expand it) to analyse 3 or 4 webpages from a company
# Use this code (and if needed expand it) to analyse and/or compare some news stories from newpaper websites