clear;clc;close all
%% Load Fisher's iris data set.
%%
load fisheriris
X = meas;Y = species;
%isCategoricalPredictor = [false, false, false, false];
ClassNames={'setosa'; 'versicolor'; 'virginica'};
%% Train a SVM classifier
% This code specifies all the classifier options and trains the classifier.
%%
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);

classificationSVM = fitcecoc(X,Y, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', ClassNames,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
    struct(...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'UseParallel',true ...
    )...
    );

%% Use the classifier
%%
[yfit,score,PBScore] = predict(classificationSVM,X);
%% create and plot the confusion matrix
%%
figure;C=confusionmat(Y,yfit);plotconfusionmatrix(C,ClassNames)
print('-depsc2','ConfusionMatrixSVM.eps');% save to an eps file
%% create and plot the ROC curves
%%
figure;ns=size(score);icount=0;
for i=1:ns(2)
    others=score;others(:,i)=[];
    diffscore=score(:,i)-max(others,[],2);
    [x,y,t,~,OPT,suby,subnames]=perfcurve(Y,diffscore,ClassNames{i});
    icount=icount+1;legend_names{icount}=ClassNames{i};
    plot(x,y,'LineWidth',2)
    hold on
    scatter(OPT(1),OPT(2),100,'filled')
    icount=icount+1;legend_names{icount}=['Optimum ' ClassNames{i}];
end
plot([0 1],[0 1],'--r','LineWidth',2)
icount=icount+1;legend_names{icount}='Random Guess';
xlabel('False positive rate');ylabel('True positive rate');title('ROC Curves')
hold off;grid on
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
legend(legend_names,'Location','southeast','FontSize',15)
print('-depsc2','ROCSVM.eps');% save to an eps file