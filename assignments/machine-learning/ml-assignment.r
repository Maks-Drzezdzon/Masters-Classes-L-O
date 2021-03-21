library(verification)
library(DWD)

setwd('Desktop/mlsp-2014-mri')
getwd()
# READ TRAIN

trainFNC = read.csv("Train/train_FNC.csv", as.is=T, header=T, sep=",")
trainSBM = read.csv("Train/train_SBM.csv", as.is=T, header=T, sep=",")
trainLAB = read.csv("Train/train_labels.csv", as.is=T, header=T, sep=",")

# READ TEST

testFNC = read.csv("Test/test_FNC.csv", as.is=T, header=T, sep=",")
testSBM = read.csv("Test/test_SBM.csv", as.is=T, header=T, sep=",")


head(testFNC)

# SUBMISSION EXAMPLE

myExample = read.csv("input/submission_example.csv", as.is=T, header=T, sep=",")

###############################################################################
################################## PREP DATA ##################################
###############################################################################

# (This will construct the data frames for Train And Test subsets)

# TRAIN

myTrain = rbind(t(trainFNC[,-1]), t(trainSBM[,-1]))
head(myTrain)
colnames(myTrain) = trainLAB$Class

# TEST

myTest = rbind(t(testFNC[,-1]), t(testSBM[,-1]))
colnames(myTest) = testFNC$Id