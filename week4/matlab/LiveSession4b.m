clear;clc;close all

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

% Create a Fitting Network with 10 nodes in the hidden layer
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);

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
mse_train=sum((z_train_nn-z_train).^2)/length(z_train)
mse_test=sum((z_test_nn-z_test).^2)/length(z_test)

% calculate the correlation coefficients for the training and test data 
% sets with the associated linear fits hint: check out the function corrcoef
R_train = corrcoef(z_train,z_train_nn)
R_test = corrcoef(z_test,z_test_nn)
r_train=R_train(1,2)
r_test=R_test(1,2)

% Calculate the error in a variable called e and plot an error histogram using ploterrhist
% save to a png file called nn-errhist-m.png
e_train = z_train-z_train_nn;
e_test = z_test-z_test_nn;
figure
ploterrhist(e_train,'Training',e_test,'Test')
grid on
set(gca,'FontSize',16)
set(gca,'LineWidth',2);  
print('nn-errhist-m.png','-dpng')

% Create a scatter diagram and label the axis 
% save to a png file called nn-scatter-m.png
figure
plot(z_train,z_train,'LineWidth',10)
hold on
scatter(z_train,z_train_nn,10,'og','filled')
scatter(z_test,z_test_nn,10,'or','filled')
hold off
grid on
legend_text={...
    ['1:1'],...
    ['Training Data (R ' num2str(r_train,2) ')'],...
    ['Testing Data (R ' num2str(r_test,2) ')']...
    };
legend(legend_text,'Location','southeast');
xlabel('Actual z','fontsize',20);
ylabel('Estimated z','fontsize',20);
title('Scatter Diagram','fontsize',25);
set(gca,'FontSize',16)
set(gca,'LineWidth',2);  
print('nn-scatter-m.png','-dpng')
