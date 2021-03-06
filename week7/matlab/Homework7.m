clear;clc;close all

%% Cancer Detection
% In this homework you will be using a neural network to detect cancer from
% mass spectrometry data on protein profiles.

%% Read in the data
[x,t] = ovarian_dataset;
whos

%%
% Each column in |x| represents one of 216 different patients.
%
% Each row in |x| represents the ion intensity level at one of the 100
% specific mass-charge values for each patient.
%
% The variable |t| has 2 rows of 216 values each of which are either [1;0],
% indicating a cancer patient, or [0;1] for a normal patient.


%% Classification Using a Feed Forward Neural Network
% You can use this information to classify the cancer and normal samples.

%%
% Create and view a 1-hidden layer feed forward neural network with 5 
% hidden layer neurons using patternnet. 

net = patternnet(5)

%%
% Train the network using x as the inputs and t as the target outputs using
% the function train. The samples are automatically divided into training, 
% validation and test sets. The training set is used to teach the network.
% Training continues as long as the network continues improving on the 
% validation set. The test set provides a completely independent measure of 
% network accuracy.

[net, tr] = train(net, x, t)

%%
% Show how the network's performance improved during training using plotperform.
% Performance is measured in terms of mean squared error, and shown in log
% scale.  It should rapidly decrease as the network is trained.
% Performance is shown for each of the training, validation and test sets.
% The version of the network that did best on the validation set is was
% after training.
% save the figure to a png file called nn-performance.png

plotperform(tr)
print('nn-performance', '-dpng')

%%
% The trained neural network can now be tested with the testing samples we
% partitioned from the main dataset. The testing data was not used in
% training in any way and hence provides an "out-of-sample" dataset to test
% the network on. This will give us a sense of how well the network will do
% when tested with data from the real world.
%
% The network outputs will be in the range 0 to 1.
% Threshold them to get 1's and 0's indicating cancer or normal patients respectively.
% Create a matrix testX with the testing input data.
% Create a vector testT with the testing target data.
% Hint: The object tr returned by the train function you should have used above 
% includes the vector testInd which are the indices of the test data points
% used in training the neural network

testX = x(:, tr.testInd)
testT = t(:, tr.testInd)

%%
% One measure of how well the neural network has fit the data is the
% confusion plot.  Plot a confusion matrix across all samples.
%
% The confusion matrix shows the percentages of correct and incorrect
% classifications.  Correct classifications are the green squares on the
% matrices diagonal.  Incorrect classifications form the red squares.
%
% If the network has learned to classify properly, the percentages in the
% red squares should be very small, indicating few misclassifications.
%
% If this is not the case then further training, or training a network with
% more hidden neurons, would be advisable.
% Hint: Use plotconfusion.
% save the figure to a png file called nn-confusion.png

predictions = net(testX)

plotconfusion(testT, predictions)
print('nn-confusion', '-dpng')

%%
% Create a Classification confusion matrix using the function confusion.
% Use this to print the overall percentages of correct and incorrect classification.

confusion(testT, predictions)

%%
% Another measure of how well the neural network has fit data is the
% receiver operating characteristic plot.  This shows how the false
% positive and true positive rates relate as the thresholding of outputs is
% varied from 0 to 1.
%
% The farther left and up the line is, the fewer false positives need to be
% accepted in order to get a high true positive rate.  The best classifiers
% will have a line going from the bottom left corner, to the top left
% corner, to the top right corner, or close to that.
%
% Class 1 indicate cancer patiencts, class 2 normal patients.
% Create a receiver operating characteristic plot.
% Hint: Use plotroc
% save the figure to a png file called nn-roc.png

clusterOutputs = sim(net, x)
plotroc(t, clusterOutputs)
print('nn-roc', '-dpng')
%%
% This example illustrated how neural networks can be used as classifiers
% for cancer detection. One can also experiment using techniques like
% principal component analysis to reduce the dimensionality of the data to
% be used for building neural networks to improve classifier performance.

% TODO
