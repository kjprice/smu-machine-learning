clear;clc;close all

% Load in the Fisher Iris Data
% Fisher's iris data set contains species (species) and 
% measurements (meas) on sepal length, sepal width, petal length, 
% and petal width for 150 iris specimens. The data set contains 50 
% specimens from each of three species: setosa, versicolor, and 
% virginica.
load fisheriris

% Plot the input data using gscatter.
% Use only the last two columns makes it easier to plot.
% Label the X & Y axes appropriately, add a Legend,
% add grid lines, save the data to a color encapsulated 
% postscript file called IrisData.eps


data = meas(:, 3:4);
gscatter(data(:, 1), data(:, 2), species)
grid on;
xlabel('Petal Length')
ylabel('Petal Width')
legend(species);
print 'IrisData' '-deps'

% Create a Self-Organizing Map with 3 classes to classify the irises
% First, set up an SOM called net with 3 classes
net = selforgmap([3 1]);


% Train the SOM
net = train(net, data');


% Use the Network to classify each record 
y = net(data');
y = vec2ind(y);

% Plot the results
% save the data to a color encapsulated 
% postscript file called SOM.eps


gscatter(data(:, 1), data(:, 2), y)
grid on;
xlabel('Petal Length')
ylabel('Petal Width')
print 'SOM' '-deps'

