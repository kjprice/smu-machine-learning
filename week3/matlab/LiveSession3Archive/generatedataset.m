clear; clc;close all

load accidents
x = hwydata(:,14); % Population of states
y = hwydata(:,4); % Accidents per state

% cross validation switch
icv=0;

%--------------------------------------------------------------------------
% Split up the data to provide a training dataset and independent validation 
% dataset of size specified by the validation fraction, validation_fraction
validation_fraction=0.1;

disp(['Validation Fraction is: ' num2str(validation_fraction)])
if icv==1

    ipointer=1:length(y);
    cvpart=cvpartition(ipointer,'holdout',validation_fraction);

    % Training Data
    x_train=x(training(cvpart),:);
    y_train=y(training(cvpart),:);

    % Independent Validation Data
    x_test=x(test(cvpart),:);
    y_test=y(test(cvpart),:);
    
else

    nskip=floor(1/validation_fraction);
    disp(['nskip is ' num2str(nskip)])
    ichoose=1:nskip:length(y);
    
    % Training Data
    x_train=x;
    y_train=y;
    x_train(ichoose)=[];
    y_train(ichoose)=[];

    % Independent Validation Data
    x_test=x(ichoose);
    y_test=y(ichoose);    
    
end

%--------------------------------------------------------------------------
% create a table then save the table to a csv file

% training data
T_train=table(x_train,y_train,'VariableNames',{'x_train','y_train'});
writetable(T_train,'population_accidents_training.csv')

% testing data
T_test=table(x_test,y_test,'VariableNames',{'x_test','y_test'});
writetable(T_test,'population_accidents_testing.csv')

save population_accidents.mat x_train y_train x_test y_test