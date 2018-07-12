clear;clc;close all

%% Classify Iris Data using a Self Organizing Map
% Classify a new point based on the Fisher iris
% Using only the last two columns makes it easier to plot.
load fisheriris
x = meas(:,1:4);
gscatter(x(:,3),x(:,4),species)
legend('Location','southeast')
grid on
title('Actual Data','FontSize',30)
set(gca,'TickDir','out'); set(gca,'LineWidth',2);set(gca,'FontSize',16);
print('-depsc2','IrisData.eps');% save to an eps file
%%

%--------------------------------------------------------------------------
% Create a Self-Organizing Map to classify the irises
% set up the SOM
net = selforgmap([3 1]);

% Train the Network
[net,tr] = train(net,x');

% Use the Network to classify each discrete time step
icluster_som = vec2ind(net(x'))';

% Plot the results
figure
gscatter(x(:,3),x(:,4),icluster_som)
legend('Location','southeast');grid on
title('SOM Classes','FontSize',30)
set(gca,'TickDir','out'); set(gca,'LineWidth',2);set(gca,'FontSize',16); 
print('-depsc2','SOM.eps');% save to an eps file