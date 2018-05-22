import sklearn as sk
from sklearn.linear_model import LinearRegression
from sklearn import datasets
import numpy as np
import pandas as pd

boston = datasets.load_boston()

x = pd.DataFrame(boston.data)
x.columns = boston.feature_names
y = boston.target
print(x.describe())

linear_model = LinearRegression()
linear_model.fit(boston.data, y)

print('r^2 {}'.format(linear_model.score(boston.data, y)))

