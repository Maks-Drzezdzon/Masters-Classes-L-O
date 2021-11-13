library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)
library(viridis)
library(hrbrthemes)


# lab 6
df = read.csv("/Users/Grim/Documents/GitHub/Masters-Classes-L-O/Data Visualisation/data/studentresult.csv", sep= ',' , header=T )


# Q1
test_marks = sqldf('select Subject, Name, round(avg(Mark_Written) + avg(Mark_Oral))/2 as Test_mark from df
group by Name, Subject')
test_marks
plot = ggplot(data = test_marks, aes(Name, Test_mark, fill=as.factor(Subject))) + geom_col(position="dodge") + labs(x="Student Name", y="Grade Average", 
       title="What are the total marks for each student for each subject?", fill="Subject Name")
plot


# Q2
# age_mark = select(df, c(Name, DOB, Subject, Mark_Written, Mark_Oral))
tmp_df = sqldf('select DOB, Subject, Name, round(avg(Mark_Written) + avg(Mark_Oral), 1)/2 as Test_mark from df
group by Name, Subject')

new_df = df
new_df$DOB = 0

tmp_df
age_mark  = apply(tmp_df, DOB, trunc((tmp_df$DOB %--% Sys.Date()) / years(1)))
tmp_df$DOB = age_calc(as.Date(tmp_df$DOB, Sys.Date(), origin="%Y/%m/%d"), units = "years")
age_mark
# What is the relationship between age and mark?
plot = ggplot(data = test_marks, aes(Name, Test_mark, fill=as.factor(Subject))) + geom_col(position="dodge") + xlab("Student Name") + labs(fill = "Subject Name") + ylab("Grade Average")
plot

# Q5 What are the average results in oral exams across all subjects and all years per student?
test_marks_5 = sqldf('select Subject, Name, Year, round(avg(Mark_Oral)) as "Avg Oral Score" from df group by name, subject, year')
test_marks_5 = drop_na(test_marks_5)
test_marks_5

pivot_data = melt(test_marks_5, id.vars = 'Year')


plot = barplot(test_marks_5, legend.text=rownames(test_marks_5), beside = TRUE) 
# https://stackoverflow.com/questions/9531904/plot-multiple-columns-on-the-same-graph-in-r

test_plot = barplot(heaight=pivot_data, aes(x=Name, fill=factor(Subject)), beside=TRUE)

plot = ggplot(pivot_data) + geom_bar(aes(variable, fill=as.factor(value)))

###########################################

pivot_data = melt(test_marks_5, id.vars = 'Year', variable.name = "col_names", value.name = "col_values")
pivot_data
test = melt(test_marks_5)
test

ggplot(pivot_data, aes(x = Year, y= col_values, fill = col_names)) +
  geom_bar(stat="identity", position = "dodge") 


###########################

test_marks_5 = sqldf('select Subject, Name, Year, round(avg(Mark_Oral)) as "Avg Oral Score" from df group by name, subject, year')
test_marks_5


ggplot(data=test_marks_5, aes(x=Name, y=test_marks_5$`Avg Oral Score`, fill=Subject)) +
  geom_bar(stat="identity", color="black", position=position_dodge())+
  theme_minimal() +
  facet_wrap(~Year)





pivot_data = melt(test_marks_5 ,  id.vars = 'Name', variable.name = 'temp')
pivot_data

tmp_data = data.frame(x=test_marks_5$Year,
                      y=c(test_marks_5$Subject, test_marks_5$Name, test_marks_5$`Avg Oral Score`),
                      group = c(rep("Subject", nrow(test_marks_5)),
                                rep("Name", nrow(test_marks_5)),
                                rep("Score", nrow(test_marks_5))))

tmp_data





test_marks_5_2013 = with(test_marks_5, test_marks_5[(Year == 2013),])
test_marks_5_2014= with(test_marks_5, test_marks_5[(Year == 2014),])
test_marks_5_2015 = with(test_marks_5, test_marks_5[(Year == 2015),])


plot_2013 = ggplot(data = test_marks_5_2013, aes(Name, test_marks_5_2013$`Avg Oral Score`, fill=as.factor(Subject))) + geom_col(position="dodge") + labs(x="Student Name", y="Grade Average", fill="Subject Name")
plot_2014 = ggplot(data = test_marks_5_2014, aes(Name, test_marks_5_2014$`Avg Oral Score`, fill=as.factor(Subject))) + geom_col(position="dodge") + labs(x="Student Name", y="Grade Average", fill="Subject Name")
plot_2015 = ggplot(data = test_marks_5_2015, aes(Name, test_marks_5_2015$`Avg Oral Score`, fill=as.factor(Subject))) + geom_col(position="dodge") + labs(x="Student Name", y="Grade Average", fill="Subject Name")


plots = cbind(plot_2013, plot_2014, plot_2015)

