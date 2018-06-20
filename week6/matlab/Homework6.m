clear;clc;close all

%--------------------------------------------------------------------------
% load the data In (24 Environmental Variables) & Out (pollen)
% The names of the variables are stored in the cell array Names.
load pollen-small.mat

%--------------------------------------------------------------------------
% Split up the data to provide (1) a training dataset and (2) an 
% independent validation dataset of a size specified by the validation 
% fraction variable that you should call validation_fraction.
% Use a validation fraction of 0.1, i.e. use 10% of the dataset for 
% independent validation.
validation_fraction = .1;

% Create a random nonstratified partition for holdout validation on n 
% observations. 

partition = cvpartition(length(In), 'HoldOut', validation_fraction);

% Create a training dataset variables called In_train & Out_train containing 
% 90% of the input data stored in the variables In and Out.
% Find the number of records in the training dataset and save it in a variable
% called n_train

In_train = In(partition.training, :);
Out_train = Out(partition.training);
n_train = length(In_train);

% Create an independent Validation dataset called In_test & OutTest
% containing 10% of the input data stored in the variables In and Out
% Find the number of records in the independent Validation dataset and 
% save it in a variable called n_test
In_test = In(partition.test, :);
Out_test = Out(partition.test);
n_test = length(In_train);
%--------------------------------------------------------------------------
% Create Several Different Fits and Compare Them

%--------------------------------------------------------------------------
% Create a table called Data from the Input training data array called In_train
Data = array2table(In_train);
% Add a column to the table for the output data called Pollen using Out_train
Data.Pollen = Out_train;
%--------------------------------------------------------------------------
% Fit 1: TreeBagger
%
% Train a regression tree bagger called Mdl_TB with 30 regression trees 
% using the entire data set specified in the Data table. Specify 
% the output variable name as 'Pollen'.
% To grow unbiased trees, specify usage of the curvature test for splitting
% predictors. In case there are missing values in the data, specify usage
% of surrogate splits.  Store the out-of-bag information for predictor
% importance estimation.

Mdl_TB = TreeBagger(30, Data, 'Pollen', ...
'Method', 'regression', ...
'PredictorSelection', 'curvature', ...
'OOBPredictorImportance', 'on');

%--------------------------------------------------------------------------
% Use the trained model, Mdl_TB, provided with the input matrix In_train to 
% estimate the pollen values and save the results in a column vector 
% called Out_Train_TB

Out_Train_TB = Mdl_TB.predict(In_train);

%--------------------------------------------------------------------------
% Use the trained model, Mdl_TB, provided with the independent validation data 
% input matrix In_test to estimate the pollen values and save the results in 
% a column vector called Out_Test_TB

Out_Test_TB = predict(Mdl_TB, In_test);

%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl_TB in a 
% variable called mseTrain_TB for the estimated pollen using as input to the 
% model Mdl_TB the training data points in the input array In_train
mseTrain_TB = mean((Out_Train_TB - Out_train) .^2);

%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl_TB in a 
% variable called mseTest_TB for the estimated pollen using as input to the 
% model Mdl_TB the independent validation data points in the input array In_test
mseTest_TB = mean((Out_Test_TB - Out_test) .^2);

%--------------------------------------------------------------------------
% Save the correlation coefficient for the training data with the 
% associated TreeBagger model estimates in a variable called r_train_TB
% hint: check out the function corrcoef

R_train_TB = corrcoef(Out_Train_TB, Out_train);
r_train_TB = R_train_TB(1,2);

%--------------------------------------------------------------------------
% Save the correlation coefficient for the independent testing data with the 
% associated TreeBagger model estimates in a variable called r_test
% hint: check out the function corrcoef
R_test_TB = corrcoef(Out_Test_TB, Out_test)
r_test_TB = R_test_TB(1,2)

%--------------------------------------------------------------------------
% Calculate the error for the training dataset in a variable called eTrain_TB
% and calculate the error for the testing dataset in a variable called eTest_TB. 

eTrain_TB = gsubtract(Out_Train_TB, Out_train);
eTest_TB = gsubtract(Out_Test_TB, Out_test);






%--------------------------------------------------------------------------
% Fit 2: Neural Network
%
% Now do a neural network fit using Levenberg-Marquardt backpropagation
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.

% Create a Fitting Neural Network with 10 nodes in the hidden layer

% Setup Division of the training Data as follows:
% 70% of the data used for Training, 
% 15% of the Data used for Validation, Testing
% 15% of the Data used for Testing

cv = cvpartition(length(In), 'HoldOut', .3);

In_Train_NN = In(cv.training, :);
Out_Train_NN = Out(cv.training);
holdout_In_NN = In(cv.test, :);
holdout_Out_NN = Out(cv.test);

% odd numbers
test_index_NN = 1:2:length(holdout_In_NN);
% even numbers
validation_index_NN = 2:2:length(holdout_In_NN);

In_Test_NN = holdout_In_NN(test_index_NN, :);
In_Validation_NN = holdout_In_NN(validation_index_NN, :);

Out_Test_NN = holdout_Out_NN(test_index_NN);
Out_Validation_NN = holdout_Out_NN(validation_index_NN);


% Train the Network
net = fitnet(10, 'trainlm');
Mdl_NN = train(net, In_Train_NN', Out_Train_NN');




%--------------------------------------------------------------------------
% Use the trained neural network net provided with the input matrix In_train to 
% estimate the pollen values and save the results in a column vector 
% called Out_Train_NN

Out_train_NN_estimate = Mdl_NN(In_Train_NN')';

%--------------------------------------------------------------------------
% Use the trained neural network net provided with the independent validation data 
% input matrix In_test to estimate the pollen values and save the results in 
% a column vector called Out_Test_NN

Out_Test_NN_estimate = Mdl_NN(In_Test_NN')';

%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl_NN in a 
% variable called mseTrain_NN for the estimated pollen using as input to the 
% model Mdl_NN the training data points in the input array In_train
mseTrain_NN = perform(Mdl_NN, Out_train_NN_estimate, Out_Train_NN)

%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl_NN in a 
% variable called mseTest_NN for the estimated pollen using as input to the 
% model Mdl_NN the independent validation data points in the input array In_test
mseTest_NN = perform(Mdl_NN, Out_Test_NN_estimate, Out_Test_NN)
%--------------------------------------------------------------------------
% Save the correlation coefficient for the training data with the 
% associated Neural Network Model estimates in a variable called r_train_NN
% hint: check out the function corrcoef

R_train_NN = corrcoef(Out_train_NN_estimate, Out_Train_NN);
r_train_NN = R_train_NN(1,2);

%--------------------------------------------------------------------------
% Save the correlation coefficient for the independent testing data with the 
% associated Neural Network Model estimates in a variable called r_test_NN
% hint: check out the function corrcoe
R_test_NN = corrcoef(Out_Test_NN_estimate, Out_Test_NN);
r_test_NN = R_test_NN(1,2);

%--------------------------------------------------------------------------
% Calculate the error for the training dataset in a variable called eTrain_NN
% and calculate the error for the testing dataset in a variable called eTest_NN
% then plot an error histogram using ploterrhist. 

eTrain_NN = gsubtract(Out_train_NN_estimate, Out_Train_NN);
eTest_NN = gsubtract(Out_Test_NN_estimate, Out_Test_NN);
%--------------------------------------------------------------------------
% Create an error histogram comparing eTest_TB and eTest_NN
% save to a png file called errhist-m.png
ploterrhist(eTest_TB, 'Tree Bagger', eTest_NN, 'Neural Network')
print 'errhist-m.png' '-dpng'

%--------------------------------------------------------------------------
% Create a scatter diagram and label the axes and add a legend which
% contains the correlation coefficients for each scatter line
% save to a png file called scatter-m.png

figure
plot_range = 0:max([max(Out_Test_NN) max(Out_test)]);
plot(plot_range, plot_range);
hold on
scatter(Out_Train_TB, Out_train, 'ob')
scatter(Out_Test_TB, Out_test, '+b')
scatter(Out_train_NN_estimate, Out_Train_NN, 'or')
scatter(Out_Test_NN_estimate, Out_Test_NN, '+r')
hold off

legend({...
    '1:1',...
    ['Train TB - R ' num2str(r_train_TB, 2)],...
    ['Test TB - R ' num2str(r_test_TB, 2)],...
    ['Train NN - R ' num2str(r_train_NN, 2)],...
    ['Test NN - R ' num2str(r_test_NN, 2)],...
})
grid on;
title 'Scatter Diagram';
xlabel('Estimate Pollen')
ylabel('Actual Pollen')


