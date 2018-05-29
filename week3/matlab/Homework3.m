clc; close all;
% clear out any existing variables and close any existing windows
% clear;clc;close all

% Load Train and Test datasets
% load population_accidents
load accidents

% Create linear regression object called f using the matlab function called fit 
% specify a first order polynomial (i.e. linear fit) using poly1
f = fit(x_train, y_train, 'poly1')

% A more comprensive output can be obtained using

% Create a variable called y_predicted_train that predicts 
% the output for the training dataset
y_predicted_train = f(x_train)

% Create a variable called y_predicted_test that predicts 
% the output for the test dataset
y_predicted_test = f(x_test)

% Plot a diagram of the data.
% 1. The x-axis should be the input x-data (the population)
% 2. the y-axis should be the output y-data (the number of accidents)
% 3. add a grid (graph paper)
% 4. add a legend
% 5. label the x and y-axis
% 6. add a title
% 7. Save the result to a png file called linearregression-m.png

title('Population Vs # Accidents')
plot(x_test, y_predicted_test, 'g', 'LineWidth', 2)
hold on
scatter(x_test, y_test, 'or', 'filled')
scatter(x_train, y_train, 'ob', 'filled')
hold off

legend({'Linear Fit ', 'Test', 'Train'})
xlabel('Population')
ylabel('Accidents')

print('linearregression-m', '-dpng')


% calculate the mean square error (MSE) for the prediction of the training and test points
% create variables called mse_train and mse_test
mse_train = sum((y_predicted_train - y_train) .^2) / length(y_train)
mse_test = sum((y_predicted_test - y_test) .^2) / length(y_test)

% calculate the correlation coefficients for the training called r_train and the test data called r_test
% with the associated linear fits hint: check out the function corrcoef
R_train = corrcoef(y_train, y_predicted_train)
r_train = R_train(1,2)

R_test = corrcoef(y_test, y_predicted_test)
r_test = R_test(1,2)

% Draw a scatter diagram to characterize how good the linear estimates of 
% the number of accidents are. This scatter diagram should include: 
% 1. The 1:1 perfect fit line (use the plot function)
% to add curves to the same plot check out 'hold on'
% 2. The training data and its associated linear fit (use the scatter function)
% 3. The test data and its associated linear fit (use the scatter function)
% 4. A legend that contains the R value in the label (check out the legend function and num2str)
% 5. Save the result to a png file called linearregression-scatter-m.png (check out the print function)

figure
title('best fit for test and training')
plot([y_train' y_test'], [y_train' y_test'], 'g', 'LineWidth', 2)
hold on
scatter(y_test, y_predicted_test, 'or', 'filled')
scatter(y_train, y_predicted_train, 'ob', 'filled')
hold off

legend({strcat(['Linear Fit ' num2str(r_test)]), 'Test', 'Train'})
xlabel('Population')
ylabel('Accidents')

print('linearregression-scatter-m', '-dpng')

%plot([x_train' x_test'], [y_train' y_test'], 'b', 'LineWidth', 3)
% plot(1:length(hwyrows), 


