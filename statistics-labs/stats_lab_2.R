library(ggplot2)

getwd()
survey = read.table("survey.dat")
colnames(survey) <- tolower(colnames(survey))



#Simple scatterplot of feeling of control and perceived stress
#aes(x,y)
scatter <- ggplot2::ggplot(survey, aes(tpstress, tpcoiss))
scatter + geom_point() + labs(x = "Total Perceived Stress", y = "Total PCOISS") 

#Add a regression line
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", se = F) + labs(x = "Total Perceived Stress", y = "Total PCOISS") 

#Note: When running this in RStudio the output will appear un the Plots tab on the right hand side, if not visible click the Plots tab

#### Conducting Correlation Tests - Pearson, Spearman, Kendall

#Pearson Correlation
stats::cor.test(survey$tpcoiss, survey$tpstress, method='pearson')
stats::cor.test(survey$tposaff, survey$tpstress, method='pearson')
#Spearman Correlation
#Change the method to be spearman.
#This test will give an error since this method uses ranking but cannot handle ties but that is ok with us - we consider this to be missing data
cor.test(survey$tpcoiss, survey$tpstress, method = "spearman")

#We can also use kendall's tau which does handle ties
cor.test(survey$tpcoiss, survey$tpstress, method = "kendall")
stats::cor.test(survey$tposaff, survey$tpstress, method='kendall')
