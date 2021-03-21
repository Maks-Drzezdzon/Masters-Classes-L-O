import tensorflow as tf
import numpy as np
import sklearn
import pandas as pd

from time import time
import logging
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn.datasets import fetch_lfw_people
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.decomposition import PCA
from sklearn.svm import SVC


train_fnc = pd.read_csv(
    '/Desktop/mlsp-2014-mri/Test/test_SBM.csv', delimiter=',')
train_sbm = pd.read_csv()
train_set = pd.merge(train)
