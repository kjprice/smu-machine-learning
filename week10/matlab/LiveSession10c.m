clear;clc;close all
%% Classify Iris Data using Fuzzy C-Means
% Classify a new point based on the Fisher iris.
%%
load fisheriris
x = meas(:,1:4);
gscatter(x(:,3),x(:,4),species)
legend('Location','southeast')
grid on
title('Actual Data','FontSize',30)
set(gca,'TickDir','out'); set(gca,'LineWidth',2);set(gca,'FontSize',16); 
print('-depsc2','IrisData.eps');% save to an eps file
%% 
% Find |3| clusters using fuzzy c-means clustering.
%%
[centers,U] = fcm(x,3);
%% 
% Classify each data point into the cluster with the largest membership 
% value.
%%
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
index3 = find(U(3,:) == maxU);

figure
scatter(x(index1,3),x(index1,4),'or','filled')
hold on
scatter(x(index2,3),x(index2,4),'og','filled')
scatter(x(index3,3),x(index3,4),'ob','filled')
legend('Location','southeast')
title('Fuzzy Classes','FontSize',30)
plot(centers(1,3),centers(1,4),'xr','MarkerSize',15,'LineWidth',3)
plot(centers(2,3),centers(2,4),'xg','MarkerSize',15,'LineWidth',3)
plot(centers(3,3),centers(3,4),'xb','MarkerSize',15,'LineWidth',3)
hold off
grid on
set(gca,'TickDir','out'); set(gca,'LineWidth',2);set(gca,'FontSize',16); 
print('-depsc2','FuzzyCMean.eps');% save to an eps file