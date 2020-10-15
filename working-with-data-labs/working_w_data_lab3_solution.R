# 1.) Irish Hospital Waiting List Data
irish_hospital_waiting_list <- read.csv('https://raw.githubusercontent.com/openknowledgeireland/DataStore/master/OP%20Waiting%20List%20By%20Group%20Hospital%202017.csv')
limerick <- irish_hospital_waiting_list[which(irish_hospital_waiting_list$Group=="University of Limerick Hospital Group"),]
write.table(limerick,"UHL.txt",sep='\t')
limerick <- read.table("UHL.txt",sep='\t')

# 2.) Facebook Data
facebook_metrics <- read.csv('Facebook_metrics/dataset_Facebook.csv')
saveRDS(facebook_metrics,file = 'FBData.rds')
facebook_metrics <- readRDS('FBData.rds')

# 3.) Stock Data
require(readxl)
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00390/stock%20portfolio%20performance%20data%20set.xlsx",'stock_data.xlsx')
sheets <- excel_sheets('stock_data.xlsx')
stock_data <- read_excel('stock_data.xlsx',sheet=1,skip = 1)
write.table(stock_data,'stock_data.txt',sep=';')
stock_data <- read.table('stock_data.txt',sep = ';')

# 4.) Sports Data
require(readxl)
download.file('https://s3.amazonaws.com/rapidminer.community/RepoFiles/athlete_events.xlsx','athlete_events.xlsx')
athlete_events <- read_excel('athlete_events.xlsx')

# 5.) Chinese Cities Data
require(openxlsx)
download.file('https://archive.ics.uci.edu/ml/machine-learning-databases/00394/FiveCitiePMData.rar','FiveCitiePMData.rar')
system('unrar e FiveCitiePMData.rar FiveCities/')
cities <- list.files('FiveCities')
city_names <- vector(mode = "list", length = length(cities))
for (i in 1:length(cities)) {
  city_names[i] <- strsplit(cities[i], "(?=([A-Z]))", perl = TRUE)[1]
}
setwd('FiveCities')
cities_df <- lapply(cities, read.csv)
wb <- createWorkbook()
for (i in 1:length(cities)) {
  sheet <- addWorksheet(wb,paste(city_names[[i]][1],city_names[[i]][2],sep = ''))
  writeData(wb,sheet,cities_df[i])
}
saveWorkbook(wb,'FiveCities.xlsx',overwrite = TRUE)
beijing <- readWorkbook('FiveCities.xlsx',sheet='Beijing')
setwd('..')

# 6.) EU Data
eu_data <- read.table(gzfile("isoc_ec_ibuy.tsv.gz"),sep = '\t',header = TRUE)
write.csv(head(eu_data,1000),'EUData.csv')
eu_data <- read.csv('EUData.csv')

# 7.) Twitter Data
download.file('http://cs.stanford.edu/people/alecmgo/trainingandtestdata.zip', 'trainingandtestdata.zip')
unzip('trainingandtestdata.zip')
training <- read.csv('training.1600000.processed.noemoticon.csv',header = FALSE,col.names = c('polarity','id','date','query','user','tweet'))
nnp <- split(training,training$polarity)
negative <- nnp$`0`
neutral <- nnp$`2`
positive <- nnp$`4`
save(negative, neutral, positive, file='Twitter.RData')
rm('negative','neutral','positive')
load(file = 'Twitter.RData')

# 8.) Scraping Table Data
require(rvest)
webpage <- read_html('https://www.bundesliga.at/de/tabelle/')
tblNodes <- html_nodes(webpage,'table')
tbls <- html_table(tblNodes,fill = TRUE)
bundesliga <- tbls[[1]]
View(bundesliga)
clean_bundesliga <- subset(bundesliga,select=Verein:Punkte)

nrow(clean_bundesliga) # show number of rows
ncol(clean_bundesliga) # show number of columns
head(clean_bundesliga) # show first
tail(clean_bundesliga) # show last
summary(clean_bundesliga$Punkte) # show statistical summary of points
IQR(clean_bundesliga$Punkte) # show iqr of points
sd(clean_bundesliga$Punkte) # show standard deviation of points
var(clean_bundesliga$Punkte) # show variance of points

# show points of each club in scatterplot
library(ggplot2)
qplot(data=clean_bundesliga, x=Verein, y=Punkte, colour=Verein)
