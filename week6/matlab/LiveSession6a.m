clear;clc;close all
%% Load the data
%%
load cancer_dataset.mat
inputs = cancerInputs;
targets = cancerTargets;
%% Create a Pattern Recognition Network
%%
hiddenLayerSize = 20;
net = patternnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
%% Train the Network
%%
[net,tr] = train(net,inputs,targets);
%% Test the Network
%%
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)
%% View the Network
%%
view(net)
%% Plots
%%
figure, plotperform(tr);grid on
set(gca,'FontSize',14); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','NN-Performance.eps');% save to an eps file

figure, plottrainstate(tr);grid on
set(gca,'FontSize',14); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
subplot(2,1,1);grid on
set(gca,'FontSize',14); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','NN-TrainingState.eps');% save to an eps file

figure, plotconfusion(targets,outputs);grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','NN-Confusion.eps');% save to an eps file

figure, ploterrhist(errors);grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','NN-ErrorHistogram.eps');% save to an eps file

figure, plotroc(targets,outputs);grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
print('-depsc2','NN-ROC.eps');% save to an eps file