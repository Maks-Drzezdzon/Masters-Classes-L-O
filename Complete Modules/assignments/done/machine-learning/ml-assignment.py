import sklearn
import pandas as pd




# test is bigger
test_data = pd.read_csv(  '../../../../mlsp-2014-mri/assign_data/amalgamated_test_data.csv', delimiter=',')
train_data = pd.read_csv(  '../../../../mlsp-2014-mri/assign_data/amalgamated_train_data.csv', delimiter=',')


print(train_data.head(10))
print("################")
print(test_data.head(10))