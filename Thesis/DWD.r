# I arranged the working directory into "input" (all input files went here)
# and "output" - for submission files.

# For completeness I will past all the code in this one file. This includes:
# 1. Reading Data
# 2. Preparing Data
# 3. Building the Model.
# 4. Wrigin Submission File.

###############################################################################
################################### SOURCES ###################################
###############################################################################

setwd("~/GitHub/Data/mlsp-2014-mri")
getwd()
data_txt = read.csv("breadwrapper.txt")
data = read.csv("bf_study.csv")
data
# Used libraries

library(verification)
library(DWD)

###############################################################################
################################## LOAD DATA ##################################
###############################################################################

trainFNC = read.csv(file='Train/train_FNC.csv', head=TRUE, sep=",")
trainSBM = read.csv(file='Train/train_SBM.csv', head=TRUE, sep=",")
trainLAB = read.csv(file='Train/train_labels.csv', head=TRUE, sep=",")

testFNC = read.csv(file='Test/test_FNC.csv', head=TRUE, sep=",")
testSBM = read.csv(file='Test/test_SBM.csv', head=TRUE, sep=",")


# myExample <- read.csv(file.path(projectTree, "input/submission_example.csv"), as.is=T, header=T, sep=",")

###############################################################################
################################## PREP DATA ##################################
###############################################################################

myTrain = rbind(t(trainFNC[,-1]), t(trainSBM[,-1]))
colnames(myTrain) = trainLAB$Class

myTest = rbind(t(testFNC[,-1]), t(testSBM[,-1]))
colnames(myTest) = testFNC$Id

###############################################################################
############################## CROSS-VALIDATION ###############################
###############################################################################

# This part is optional and was used to select the values of C constraint.

# (This runs 100 itterations of 10-fold cross validation

ROCS = list()

Cs = c(1, 5, 10, 50, 100, 300, 500, 1000)

for(Cind in 1:length(Cs)) {
  C = Cs[Cind]
  tmpRocs = numeric()
  for(i in 1:100) {
    trainInds1 = sample(which(colnames(myTrain)==0), 42)
    trainInds2 = sample(which(colnames(myTrain)==1), 36)
    trainInds = c(trainInds1, trainInds2)
    theTrain = myTrain[,trainInds]
    theTest = myTrain[,-trainInds]
    
    myFit = kdwd(t(myTrain), colnames(myTrain), C=C)
    testScores = t(myFit@w[[1]]) %*% theTest
    testScores = 1 - ((testScores - min(testScores)) / max(testScores - min(testScores)))
    
    tmpRocs[i] = roc.area(as.numeric(colnames(theTest)), testScores)$A		
    
    print(i)
  }
  ROCS[[Cind]] = tmpRocs
}


###############################################################################
################################## FIT MODEL ##################################
###############################################################################

myFit = kdwd(t(myTrain), colnames(myTrain), C=300)

# Get scores for training data (meaningless for now).

scores = t(myFit@w[[1]]) %*% myTrain
scores = 1 - ((scores - min(scores)) / max(scores - min(scores)))

# Check ROC area. (meaningless, because of possible overfitting)

roc.area(as.numeric(colnames(myTrain)), scores)

###############################################################################
################################ WRITE SCORES #################################
###############################################################################

testScores = t(myFit@w[[1]]) %*% myTest
testScores = 1 - ((testScores - min(testScores)) / max(testScores - min(testScores)))

myExample$Probability = as.numeric(testScores)

write.csv(myExample, file=file.path(projectTree, "output/submission.csv"), row.names=F)
