
#Variables
x<-2
y<-c(2,3,4,5)
y

#Accessing values...........Find differences with Python
y[1]
y[1:3]
y[-3]
class(x)    ###data type x

#Creating a dataframe
#setting up the components
x<-1:10
y<-4:13
comments<-c("good", "basic", "Excellent","good", "basic","good", "basic","Excellent","good","Excellent")
#Creating the dataframe
mydf<-data.frame(x,y,comments)
#displaying the dataframe
mydf
#displaying the firt few lines of the dataframe

#Reading data into a data frame
adult<-read.table('https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data',header=FALSE,sep=',')

#check the size of the data frame
dim(adult)

#add the column names 
colnames(adult) <- c("age","workclass","fnlwgt","education","education_num","marital_status","occupation","relationship","race","gender","capital_gain","capital_loss","hours_per_week","native_country","income_bracket")

#Have a look at the first few lines of the data frame


#checking for missing values
apply(is.na(adult),2,sum)

### Create a dataframe with the information from the table : http://datasets.flowingdata.com/hot-dog-contest-winners.csv




### Inspect the dataframe (size, columns, names etc..)


#checking for missing values


#filtering information by year
hotdogs[which(hotdogs[,1]>1990),]

#Inspect if there are any changes in the orginial dataframe


#create a new dataframe that contains information about the hotdogs competition 
#only for cases when more than 40 hotdogs were eaten


#Scatter plot with years on the x axis and hotdogs eaten on the y axis   ###Uncomment next line

#plot(hotdogs$Dogs.eaten~as.integer(hotdogs$Year), data = hotdogs)

#Replace the axis titles

### create a histogram of the amount of hotdogs eaten   .... use hist(....)


##Add main title and axis titles

#create a boxplot for hotdogs eaten   ... use boxplot(....)


##Add main title and axis titles

### Barplot hotdogs eaten per year   ... use barplot(....)




library(ggplot2)

#scatter plot ggplot2
#ggplot(hotdogs,aes(x=Year,y=Dogs.eaten))+geom_point()

###Customize the labels


#small multiples using facet_wrap  scatter plot ggplot2



