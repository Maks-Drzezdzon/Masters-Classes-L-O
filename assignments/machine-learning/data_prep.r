library(feather)

# Data preparation 
# I originally tried this in python but for some reason python cant drop the Id column, I google'd around for a solution 
# such as resetting the index etc and it still wouldn't work
# instead I'm going to do data transformation in R because its easier and then do ML in python with sklearn learn

# One more thing, I originally thought this data was going to be in image format but its not
# one way to enrich MRI data is to actually rotate images a few times to have more data to train the model on


# train data
trainFNC = read.csv("mlsp-2014-mri/Train/train_FNC.csv", as.is=T, header=T, sep=",")
trainSBM = read.csv("mlsp-2014-mri/Train/train_SBM.csv", as.is=T, header=T, sep=",")
train_labels = read.csv("mlsp-2014-mri/Train/train_labels.csv", as.is=T, header=T, sep=",")

head(trainFNC)
head(trainSBM)
head(trainLAB)

# test data

testFNC = read.csv("mlsp-2014-mri/Test/test_FNC.csv", as.is=T, header=T, sep=",")
testSBM = read.csv("mlsp-2014-mri/Test/test_SBM.csv", as.is=T, header=T, sep=",")

head(testSBM)
head(testFNC)


submission_example = read.csv("mlsp-2014-mri/submission_example.csv", as.is=T, header=T, sep=",")

head(submission_example)

# remove id column, transpose data frames otherwise they wont be able to be combined as their dimensions are different
train_data = rbind(t(trainFNC[,-1]), t(trainSBM[,-1]))
head(train_data)
# add class label to each col
colnames(train_data) = train_labels$Class
typeof(train_data)
train_data = as.data.frame(train_data)
write_feather(train_data, 'train_data.feather')

test_data = rbind(t(testFNC[,-1]), t(testSBM[,-1]))
head(test_data)
colnames(test_data) = testFNC$Id
test_data = as.data.frame(test_data)
write_feather(test_data, 'test_data.feather')

train_data = read_feather('train_data.feather')
# doesnt work rip :c