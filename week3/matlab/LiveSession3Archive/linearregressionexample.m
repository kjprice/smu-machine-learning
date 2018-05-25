clear;clc;close all

%%
% Load Train and Test datasets
load population_accidents

%%
% Create linear regression object 
% poly1 refers to a first order polynomial
%[f,S,mu]=fit(x_train,y_train,'poly1')
f=fit(x_train,y_train,'poly1')

%%
% Predict the Output
y_predicted_train=feval(f,x_train);
y_predicted_test=feval(f,x_test);

%%
% Plot the data.
scatter(x_train,y_train,40,'ob','filled')
hold on
scatter(x_test,y_test,40,'or','filled')
plot(x_test,y_predicted_test,'g','LineWidth',3)
hold off
grid on

legend_text={'Training Data','Testing Data','Linear Fit'};
legend(legend_text,'Location','southeast');
xlabel('Population','fontsize',25);
ylabel('Accidents','fontsize',25);
title('Population & Accidents Regression','fontsize',25);
set(gca,'FontSize',20)
set(gca,'LineWidth',2); 

% save plot to a png file
print('linearregression-m.png','-dpng')

%%
% calculate the mean square error (MSE) of the test points

% calculate the correlation coefficients for the training and test data 
% sets with the associated linear fits
% hint: check out the function corrcoef

% Draw a scatter diagram to characterize how good the linear estimates
% of the number of accidents are. This scatter diagram should include:
% 1. The 1:1 perfect fit line
% 2. The training data and its associated linear fit
% 3. The test data and its associated linear fit
% 4. A legend that contains the R value in the label
