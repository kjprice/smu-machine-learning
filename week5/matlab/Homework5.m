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

validation_fraction=.1;
%n_skip=floor(1/validation_fraction)
%ichoose = 1:n_skip:length(In);

%training_x = In;
%training_y = Out;
%training_x(ichoose, :) = [];
%training_y(ichoose, :) = [];

%testing_x = In(ichoose, :);
%testing_y = Out(ichoose, :);

% Create a random nonstratified partition for holdout validation on n 
% observations.

%c  = cvpartition(length(training_x), 'HoldOut', .1);

%validation_index = c.test();
%validation_x = training_x(validation_index, :);
%validation_y = training_y(validation_index, :);

%train_index = c.training();
%training_x = training_x(train_index, :);
%training_y = training_y(train_index, :);

%disp(length(training_x) + length(validation_x) + length(testing_x))

c  = cvpartition(length(In), 'HoldOut', validation_fraction);


% Create a training dataset variables called In_train & Out_train containing 
% 90% of the input data stored in the variables In and Out.
% Find the number of records in the training dataset and save it in a variable
% called n_train

training_index = c.training();

In_train = In(training_index, :);
Out_train = Out(training_index, :);

n_train = length(In_train);
disp(['Number of training records ' num2str(n_train)]);

% Create an independent Validation dataset called In_test & Out_test
% containing 10% of the input data stored in the variables In and Out
% Find the number of records in the independent Validation dataset and 
% save it in a variable called n_test
testing_index = c.test();

In_test = In(testing_index, :);
Out_test = Out(testing_index, :);

n_test = length(In_test);
disp(['Number of testing records '  num2str(n_test)]);

%--------------------------------------------------------------------------
% Train a regression tree bagger called Mdl with 30 regression trees 
% using the training data set specified by In_train Out_train.
Mdl = TreeBagger(30, In_train, Out_train, 'Method', 'regression')
%--------------------------------------------------------------------------
% Create a table called Data from the Input training data array called In_train
Data = array2table(In_train);
% Add a column to the table for the output data called Pollen using Out_train
Data.Pollen = Out_train;
%--------------------------------------------------------------------------
% Now train a regression tree bagger called Mdl with 30 regression trees 
% using the entire data set this time specified in the Data table. Specify 
% the output variable name as 'Pollen'.
% To grow unbiased trees, specify usage of the curvature test for splitting
% predictors. In case there are missing values in the data, specify usage
% of surrogate splits.  Store the out-of-bag information for predictor
% importance estimation.

Mdl = TreeBagger(30, Data, 'Pollen', ...
    'Method', 'regression', 'PredictorSelection', 'curvature', ...
    'Surrogate', 'on', 'OOBPredictorImportance', 'on');

%--------------------------------------------------------------------------
% Use the trained model, Mdl, provided with the input matrix In_train to 
% estimate the pollen values and save the results in a column vector 
% called Out_Train

Out_Train_Estimate = predict(Mdl, In_train);


%--------------------------------------------------------------------------
% Use the trained model, Mdl, provided with the independent validation data 
% input matrix In_test to estimate the pollen values and save the results in 
% a column vector called Out_Test
Out_Test_Estimate = predict(Mdl, In_test);

%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl in a 
% variable called mseTrain for the estimated pollen using as input to the 
% model Mdl the training data points in the input array In_train

mseTrain = mean((Out_Train_Estimate - Out_train) .^2);
%--------------------------------------------------------------------------
% Save the mean square error (MSE) of the TreeBagger model Mdl in a 
% variable called mseTest for the estimated pollen using as input to the 
% model Mdl the independent validation data points in the input array In_test
mseTest = mean((Out_Test_Estimate - Out_test) .^2);
%--------------------------------------------------------------------------
% Save the correlation coefficient for the training data with the 
% associated TreeBagger model estimates in a variable called r_train
% hint: check out the function corrcoef

R_train = corrcoef(Out_Train_Estimate, Out_train);
r_train = R_train(2,1);

disp('all done here')

%--------------------------------------------------------------------------
% Save the correlation coefficient for the independent testing data with the 
% associated TreeBagger model estimates in a variable called r_test
% hint: check out the function corrcoef

R_test = corrcoef(Out_Test_Estimate, Out_test);
r_test = R_test(1,2);


%--------------------------------------------------------------------------
% The |TreeBagger| stores predictor importance estimates in the property
% |OOBPermutedPredictorDeltaError|. Compare the estimates using a bar
% graph. First save the importance estimates into a variable called imp
imp = Mdl.OOBPermutedPredictorDeltaError;
%--------------------------------------------------------------------------
% sort the importances into descending order, with the most important first
% Hint: look up the function sort with the option 'descend'
[imp_sorted, imp_index] = sort(imp, 'descend');
%--------------------------------------------------------------------------
% Draw a horizontal bar chart showing the variables in descending order of
% importance. Use a log scale for the x-axis.
% Hint: look up the function barh.
% Label each variable with its name. Save the plot to a png file called 
% input-importance-curvature-test.png
% Hints: (1) Use the function text to label each horizintal bar. 
% (2) Variable names are saved by the TreeBagger in Mdl.PredictorNames


figure;
barh(imp(imp_index));
hold on;grid on;
for i=1:length(Mdl.PredictorNames)
    text(...
        imp_sorted(i) * 1.05,...
        i,...
        Mdl.PredictorNames{imp_index(i)},...
        'FontSize', 14 ...
    )
end

ax.XScale = 'log'

hold off;
print 'input-importance-curvature-test' '-dpng'

%--------------------------------------------------------------------------
% Calculate the error in a variable called e and plot an error histogram 
% using ploterrhist. save to a png file called tb-errhist-m.png

e = Mdl.error(Data);
ploterrhist(e)
print 'tb-errhist-m.png' '-dpng'
%--------------------------------------------------------------------------
% Create a scatter diagram and label the axes and add a legend 
% save to a png file called tb-scatter-m.png

figure;
plot(0:length(Out), 0:length(Out))
hold on;
scatter(Out_train, Out_Train_Estimate, 'filled');
scatter(Out_test, Out_Test_Estimate, 'filled');
hold off;

xlabel('Actual Pollen');
ylabel('Estimated Pollen');
legend({'1:1', ['Train ' num2str(r_train)], ['Test ' num2str(r_test)]});

print 'tb-scatter-m.png' '-dpng'
