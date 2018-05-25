#Import the necessary libraries like pandas, numpy...
import matplotlib.pyplot as plt
from sklearn import linear_model
import pandas as pd
import numpy as np

#Load Train and Test datasets
train = pd.read_csv('population_accidents_training.csv')
test = pd.read_csv('population_accidents_testing.csv')

#Identify feature and response variable(s) and values must be numeric and numpy arrays
x_train = train.x_train[:, np.newaxis]
y_train=train.y_train
x_test=test.x_test[:, np.newaxis]
y_test=test.y_test.values

#x_train=x_train.T
#y_train=y_train.T

# Create linear regression object
linear = linear_model.LinearRegression()

# Train the model using the training sets and check score
linear.fit(x_train, y_train)
linear.score(x_train, y_train)

# Equation coefficient and Intercept
print('Coefficient: \n', linear.coef_)
print('Intercept: \n', linear.intercept_)

# Predict Output
y_predicted_test=linear.predict(x_test)

# Plot the data using matplotlib
plt.plot(x_train, linear.predict(x_train),  color='green', linewidth=3, label='Linear Fit')
plt.scatter(x_train, y_train,  color='black', label='Training Data')
plt.scatter(x_test, y_test, color='red', label='Test Data')

plt.legend(loc='lower right', shadow=True, fontsize='x-large')

# axis & plot labels
plt.xlabel('Population of states')
plt.ylabel('Accidents per state')
plt.title('Population & Accidents Regression')

# grid lines
plt.grid()

# save to a file
plt.savefig('linearregression-py.png')

plt.show()
