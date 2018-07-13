clear;clc;close all

%% Cancer Detection
% In this homework you will be using an ensemble of decision trees to detect 
% cancer from mass spectrometry data on protein profiles.

%% Read in the data
[x,t] = ovarian_dataset;

% recast so that the variables are column vectors
x=x';
t=vec2ind(t)';
whos

%%
% Each column in |x| represents one of 216 different patients.
%
% Each row in |x| represents the ion intensity level at one of the 100
% specific mass-charge values for each patient.
%
% The variable |t| has 2 rows of 216 values each of which are either [1;0],
% indicating a cancer patient, or [0;1] for a normal patient.


%% Build a classification model called Mdl using a TreeBagger ensemble of classification trees
% Turm on the following TreeBagger flags:
% 'Surrogate','on'
% 'PredictorSelection','curvature'
% 'OOBPredictorImportance','on'
Mdl = TreeBagger(30, x, t, ...
'Method', 'classification', ...
'PredictorSelection', 'curvature', ...
'OOBPredictorImportance', 'on');

% Save the estimate predictor importance in a variable called imp. 
% TreeBagger stores predictor importance estimates in the property 
% called OOBPermutedPredictorDeltaError. 
imp = Mdl.OOBPermutedPredictorDeltaError;

% Sort the importances into descending order, with the most important first
[imp_sorted, imp_index] = sort(imp, 'descend');

% Compare the estimates using a bar graph that shows the top 20 input 
% variables in descending order.
% Hint: You will need to use the YDir atribute of the y axes and set it to 'reverse'.


figure;
barh(imp(imp_index(1:20)));
hold on;grid on;
for i=1:20
    text(...
        imp_sorted(i) * 1.05,...
        i,...
        Mdl.PredictorNames{imp_index(i)},...
        'FontSize', 14 ...
    )
end

ax.XScale = 'log'

hold off;
print 'input-importance-curvature-test' '-dpng'

%%
% Use the Mdl to estimate the presence/absence of cancer and plot a confusion matrix 
t_fit=str2num(cell2mat(predict(Mdl,x)));
ClassNames={'0','1'};
figure;
plotconfusion(t' -1, t_fit' - 1);
%C=confusionmat(t,t_fit);
%plotconfusionmatrix(C,ClassNames)
print('-dpng','ConfusionMatrixTB.png');% save to an eps file
