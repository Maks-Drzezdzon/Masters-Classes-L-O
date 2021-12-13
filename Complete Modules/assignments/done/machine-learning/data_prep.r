# Data preparation 
# I originally tried this in python but for some reason python cant drop the Id column, I google'd around for a solution 
# such as resetting the index etc and it still wouldn't work
# instead I'm going to do data transformation in R because its easier and then do ML in python with sklearn learn

# One more thing, I originally thought this data was going to be in image format but its not
# one way to enrich MRI data is to actually rotate images a few times to have more data to train the model on

# sadly the feather format is not good for this project as 
# classes have duplicate column names based on labels
# because of this I will save the new combined data set into a csv files




data = read.csv("mlsp-2014-mri/test.csv", as.is=T, header=T, sep=",")
write.csv(data[,-1], 'mlsp-2014-mri/assign_data/amalgamated_train_data.csv', row.names = F)

data = read.csv("mlsp-2014-mri/amalgamated_test_data.csv", as.is=T, header=T, sep=",")
head(data)
write.csv(data[,-2], 'mlsp-2014-mri/assign_data/new_test_data.csv', row.names = F)



test_FNC = read.csv(  'mlsp-2014-mri/Test/test_FNC.csv', as.is=T, header=T, sep=",")
test_SBM = read.csv(  'mlsp-2014-mri/Test/test_SBM.csv', as.is=T, header=T, sep=",")
test = rbind(test_FNC, test_SBM)
head(test)
test = read.csv(  'mlsp-2014-mri/new_test.csv', as.is=T, header=T, sep=",")
write.csv(test[,-1], 'mlsp-2014-mri/assign_data/new_test_data.csv', row.names = F)
