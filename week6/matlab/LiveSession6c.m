clear;clc;close all
%% Optimize SVM Classifier
% This example shows how to optimize hyperparameters automatically using |fitcsvm|. 
% The example uses the |ionosphere| data.
% 
% Load the data.
%%
load ionosphere
%% 
% Find hyperparameters that minimize five-fold cross-validation loss by 
% using automatic hyperparameter optimization.
% 
% For reproducibility, set the random seed and use the |'expected-improvement-plus'| 
% acquisition function.
%%
rng default
% tic
% Mdl = fitcsvm(X,Y,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus')...
%     )
% toc
tic
Mdl = fitcsvm(X,Y,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct(...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'UseParallel',true...
    )...
    )
toc

hold off; grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','SVM-Example3b.eps');% save to an eps file

figure(1)
hold off; grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','SVM-Example3a.eps');% save to an eps file