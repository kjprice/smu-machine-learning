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
petals = [meas(:,3), meas(:,4)]

gscatter(petals(:,1), petals(:,2), species)
grid on
legend(unique(species))
xlabel('Petal Length')
ylabel('Petal Width')
print 'IrisData' '-deps'


% Find 3 clusters using fuzzy c-means clustering.

% Classify each data point into the cluster with the largest membership value.
[centers, U] = fcm([petals(:,1), petals(:,2)], 3)
% Plot the results of the fuzzy clustering.
% Use only the last two columns makes it easier to plot.
% Label the X & Y axes appropriately, add a Legend,
% add grid lines. Add the center points of each fuzzy cluster
% save the data to a color encapsulated 
% postscript file called FuzzyCMean.eps

maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
index3 = find(U(3,:) == maxU);

figure
%gscatter(meas(:,3), meas(:,4), species)
plot(petals(index1,1), petals(index1,2), 'or')
hold on
plot(petals(index2,1), petals(index2,2), 'og')
plot(petals(index3,1), petals(index3,2), 'ob')
plot(centers(1, 1), centers(1, 2), 'xr','MarkerSize',15,'LineWidth',3)
plot(centers(2, 1), centers(2, 2), 'xg','MarkerSize',15,'LineWidth',3)
plot(centers(3, 1), centers(3, 2), 'xb','MarkerSize',15,'LineWidth',3)
grid on
legend(unique(species))
xlabel('Petal Length')
ylabel('Petal Width')
print 'FuzzyCMean' '-deps'
