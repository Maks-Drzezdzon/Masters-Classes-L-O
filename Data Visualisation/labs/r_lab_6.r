library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)

# lab 6
df = read.csv("/Users/maksdrzezdzon/Downloads/studentresult.csv", sep= ',' , header=T )


# Q1
test_marks = sqldf('select Subject, Name, round(avg(Mark_Written) + avg(Mark_Oral), 1)/2 as Test_mark from df
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
test_marks_5 = sqldf('select Subject, Name, Year, round(avg(Mark_Written)) as "Avg Oral Score" from df group by name, subject, year')
test_marks_5
pivot_data = melt(test_marks_5 ,  id.vars = 'Name', variable.name = 'temp')
pivot_data
plot = barplot(test_marks_5, x = "name", y = test_marks_5$`Avg Oral Score`) + geom_col(position="dodge", fill="skyblue4") + labs(x="Subject Name", y="Grade Average", title="What are the average results in oral exams across all subjects and all years per student?", fill="")
plot





