import numpy as np
import sklearn
import pandas as pd





# merging test data
test_fnc = pd.read_csv(
    '../../../../../Desktop/mlsp-2014-mri/Test/test_FNC.csv', delimiter=',')
test_sbm = pd.read_csv(
    '../../../../../Desktop/mlsp-2014-mri/Test/test_SBM.csv', delimiter=',')

test_set = pd.merge(test_fnc, test_sbm)

lables = pd.read_csv(
    '../../../../../Desktop/mlsp-2014-mri/Train/train_labels.csv', delimiter=',')

# merging train data
train_fnc = pd.read_csv(
    '../../../../../Desktop/mlsp-2014-mri/Train/train_FNC.csv', delimiter=',')
train_sbm = pd.read_csv(
    '../../../../../Desktop/mlsp-2014-mri/Train/train_SBM.csv', delimiter=',')
    
    
# transposing otherwise
train_fnc.transpose()
train_sbm.transpose()

train_set = pd.merge(train_fnc, train_sbm)
train_set.drop(labels='Id', axis=0)
print(train_set.head(10))
# train_set.transpose()
