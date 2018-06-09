function f = scalarobjective(x)

% First variable to optimize is the number of hidden nodes
hiddenLayerSize=x(1);

% Second variable to optimize is the transfer function
itransferFunctions=x(2);

transferFunctions={'tansig','logsig','tansig','purelin','satlin'};

% Load the example data
load trainingdata.mat

%--------------------------------------------------------------------------
% Set up the training dataset for the neural network using x & y as the inputs
% saved in a row matrix called In (i.e. the two rows of In are x & y).
% Set up the output row matrix called Out containing z.
% Input
In_train=[x_train y_train]';
In_test=[x_test y_test]';
% Output (target)
Out_train=z_train';

%--------------------------------------------------------------------------
% Now do neural network fit using Levenberg-Marquardt backpropagation
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network with hiddenLayerSize nodes in the hidden layer
net = fitnet(hiddenLayerSize,trainFcn);

% set the transfer function
net.layers{1}.transferFcn=transferFunctions{itransferFunctions};

% Setup Division of the training Data as follows:
% 70% of the data used for Training, 
% 15% of the Data used for Validation, Testing
% 15% of the Data used for Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,In_train,Out_train);

% Use the trained network, net, provided with the input matrix In to 
% estimate the z values and save the results in a column vector called z
z_train_nn = net(In_train)';
z_test_nn = net(In_test)';

% calculate the mean square error (MSE) of the test and training points
mse_train=sum((z_train_nn-z_train).^2)/length(z_train);
mse_test=sum((z_test_nn-z_test).^2)/length(z_test);

f=mse_test;


end