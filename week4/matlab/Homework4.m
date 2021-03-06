clear;clc;close all

%--------------------------------------------------------------------------
% Set up the variables we will use.
% Create 2000 random x values between -1 and +1 and save them in a vector called x.
% Create 2000 random y values between -1 and +1 and save them in a vector called y.
% Use the randomn x and y values to create a highly non-linear function z=x^5 + y^4 - x^4 - y^3 

x = rand(2000, 1) .* 2 - 1;
y = rand(2000, 1) .* 2 - 1;
z = x.^5 + y.^4 - x.^4 - y.^3;
%--------------------------------------------------------------------------
% Set up the training dataset for the neural network using x & y as the inputs
% saved in a row matrix called In (i.e. the two rows of In are x & y).
% Set up the output row matrix called Out containing z.
% Input
In = [x, y]';
% Output (target)
Out = z';


%--------------------------------------------------------------------------
% Now do neural network fit using Levenberg-Marquardt backpropagation
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
% Create a Fitting Network with 10 nodes in the hidden layer
net = fitnet(10, 'trainlm'); % Levenberg-Marquardt

% Setup Division of the training Data as follows:
% 70% of the data used for Training, 
% 15% of the Data used for Validation, Testing
% 15% of the Data used for Testing
net.divideParam.trainRatio = 0.70;
net.divideParam.testRatio = .15;
net.divideParam.valRatio = .15;

% Train the Network
net = train(net,In,Out);

% Use the trained network, net, provided with the input matrix In to 
% estimate the z values and save the results in a column vector called z
z = net(In)';
% Calculate the error in a variable called e and plot an error histogram using ploterrhist
% save to a png file called nn-errhist-m.png
e = z-Out;
grid on
ploterrhist(e);
print('nn-errhist-m', '-dpng')
% Create a scatter diagram and label the axis 
% save to a png file called nn-scatter-m.png
figure
plot(z, z);
grid on
hold on
scatter(z, Out');
xlabel('estimates')
ylabel('actual')
title('estimate versus actual');
print('nn-scatter-m', '-dpng')
hold off

% scatterhist
figure
scatterhist(z, Out')
xlabel('estimates')
ylabel('actual')
title('estimates versus actual')
print('nn-scatter-marginal-m', '-dpng')

% QQ Plot
figure
ranges = [prctile(z, 25), prctile(z, 50), prctile(z, 75)]
scatter(ranges, ranges)
qqplot(z, Out')
text(ranges(1),ranges(1), '25%')
text(ranges(2),ranges(2), '50%')
text(ranges(3),ranges(3), '75%')
xlabel('Estimate')
xlabel('Actual')
print('nn-qq-m', '-dpng')

