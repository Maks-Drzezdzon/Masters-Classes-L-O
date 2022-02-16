library(pastecs) #For creating descriptive statistic summaries
library(ggplot2) #For creating histograms with more detail than plot
library(psych) # Some useful descriptive functions
library(semTools) #For skewness and kurtosis
library(FSA) #For percentage
library(car) # For Levene's test for homogeneity of variance 
library(effectsize) #To calculate effect size for t-test

anovatab <-
  function(mod){
    tab=as.matrix(anova(mod))
    rows=dim(tab)[1]
    moddf=sum(tab[,1])-tab[rows,1]
    ssmodel=sum(tab[,2])-tab[rows,2]
    msmodel=ssmodel/moddf
    f=msmodel/tab[rows,3]
    p=1-pf(f,moddf,tab[rows,1])
    tab2=tab[(rows-1):rows,]
    tab2[1,1:5]=c(moddf,ssmodel,msmodel,f,p)
    tab2=rbind(tab2,c(moddf+tab2[2,1],ssmodel+tab2[2,2],rep(NA,3)))
    rownames(tab2)=c('Model','Error','Total')
    colnames(tab2)[1]='df'
    return(print(tab2,na.print = "" , quote = FALSE,digits=3))
  }

setwd("~/GitHub/Masters-Classes-L-O/Applied Statistics/data_stats/")
getwd()
data_txt = read.csv("breadwrapper.txt")
data = read.csv("bf_study.csv")
data

scatter_plot = ggplot(data, aes(x=`body_fat`,
                                y=`neck_circumference`, 
                                color = 'body fat', show.legend = T)) + geom_point(size=2) + geom_smooth(method = "lm", se = FALSE)
scatter_plot

lin_reg = lm(`neck_circumference`~`body_fat`, data=data)
lin_reg
summary(lin_reg)

















