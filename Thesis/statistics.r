library(pastecs) #For creating descriptive statistic summaries
library(ggplot2) #For creating histograms with more detail than plot
library(psych) # Some useful descriptive functions
library(semTools) #For skewness and kurtosis
library(FSA) #For percentage
library(car) # For Levene's test for homogeneity of variance 
library(effectsize) #To calculate effect size for t-test


setwd("~/GitHub/Data/mlsp-2014-mri")
getwd()


labels_train = read.csv(file='Train/train_labels.csv',head=TRUE,sep=",")
labels_train
# Convert 'Class' into an unordered categorical variable, and assign labels
# to each level.
labels_train$Class = factor(labels_train$Class,labels=c('Healthy Control','Schizophrenic Patient'))
summary(labels_train$Class)
# 46 control # 40 patient 

## Load FNC features
# These are correlation values.

FNC_train = read.csv(file='Train/train_FNC.csv',head=TRUE,sep=",")

# Generate five number summary
summary(FNC_train[,-1])
# Group means and standard deviations
by(FNC_train[,-1], labels_train$Class, colMeans)
by(FNC_train[,-1], labels_train$Class, apply, 2, sd)


FNC_test = read.csv(file='Test/test_FNC.csv',head=TRUE,sep=",")

## Load SBM features
# These are ICA weights.

SBM_train = read.csv(file='Train/train_SBM.csv',head=TRUE,sep=",")

# Generate five number summary
summary(SBM_train[,-1])
# Group means and standard deviations
by(SBM_train[,-1], labels_train$Class, colMeans)
by(SBM_train[,-1], labels_train$Class, apply, 2, sd)

