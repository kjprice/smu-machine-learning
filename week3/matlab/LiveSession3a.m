clear; clc;close all

%--------------------------------------------------------------------------
% load an example dataset
load accidents %% which accidents.mat

%--------------------------------------------------------------------------
% extarct 2 columns as our example x & y data
x = hwydata(:,14); % Population of states %% % all rows, 14th column
y = hwydata(:,4); % Accidents per state

%--------------------------------------------------------------------------
% example of saving to a mat file
save testset.mat x y

%--------------------------------------------------------------------------
% example of saving to a csv file
T=table(x,y,'VariableNames',{'x','y'});
writetable(T,'testset.csv')

%--------------------------------------------------------------------------
% example of a for loop
% cross validation switch loop
for icv=0:1

    %--------------------------------------------------------------------------
    % Split up the data to provide a training dataset and independent validation 
    % dataset of size specified by the validation fraction, validation_fraction
    validation_fraction=0.1;

    % write to the command window
    disp(['Validation Fraction is: ' num2str(validation_fraction)])
    
    % example of an if clause
    if icv==1

        disp('Randomly partitioning data into a training and testing dataset')
        ipointer=1:length(y);
        cvpart=cvpartition(ipointer,'holdout',validation_fraction);

        % Training Data
        x_train=x(training(cvpart),:);
        y_train=y(training(cvpart),:);

        % Independent Validation Data
        x_test=x(test(cvpart),:);
        y_test=y(test(cvpart),:);
        
        % base file name
        fn_base='population_accidents_cv';

    else

        nskip=floor(1/validation_fraction);
        disp(['nskip is ' num2str(nskip)])
        ichoose=1:nskip:length(y);

        % Training Data (delete every tenth item)
        x_train=x;
        y_train=y;
        x_train(ichoose)=[];
        y_train(ichoose)=[];

        % Independent Validation Data
        x_test=x(ichoose);
        y_test=y(ichoose);    

        % base file name
        fn_base='population_accidents';
        
    end

    %--------------------------------------------------------------------------
    % create two tables, one for the training data, one for the testing data
    % then save each of the tables to a different csv file

    %--------------------------------------------------------------------------
    % training data file name
    fn_training=[fn_base '_training.csv'];
    disp(['Saving training data to:' fn_training])
    
    % create a table for the training data then save it to the csv file
    T_train=table(x_train,y_train,'VariableNames',{'x_train','y_train'});
    writetable(T_train,fn_training)

    %--------------------------------------------------------------------------
    % testing data file name
    fn_testing=[fn_base '_testing.csv'];
    disp(['Saving testing data to:' fn_testing])
    
    % create a table for the testing data then save it to the csv file
    T_test=table(x_test,y_test,'VariableNames',{'x_test','y_test'});
    writetable(T_test,fn_testing)

    %--------------------------------------------------------------------------
    % Saving all the data to a mat file
    fn_save=[fn_base '.mat'];
    disp(['Saving all data to:' fn_save])
    save(fn_save,'x_train','y_train','x_test','y_test')
    
    %--------------------------------------------------------------------------
    disp(' ')
    
end
% end of the cross validation switch loop
%--------------------------------------------------------------------------


