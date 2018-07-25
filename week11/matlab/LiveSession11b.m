clear;clc;close all

% Read in wine dataset
[X,T] = wine_dataset;

% Prepare inputs and class labels
In=X';
targets=vec2ind(T)';
ClassLabels=num2str(unique(targets));

%--------------------------------------------------------------------------
% Create ensemble model without Hyperparameter Optimization
Mdl_UnOptimized = fitcensemble(In,targets)

% Use model to predict Wine Class
outputs_unoptimized=predict(Mdl_UnOptimized,In);

%--------------------------------------------------------------------------
% plot confusion matrix
figure
plotconfusion(categorical(targets),categorical(outputs_unoptimized))
title('Full Confusion Matrix Unoptimized')
print('-dpng','wine-full-unoptimized-ConfusionMatrix.png');% save to an png file

%--------------------------------------------------------------------------
% Create ensemble model with Hyperparameter Optimization
Mdl = fitcensemble(...
    In,targets,...
    'OptimizeHyperparameters','all', ...
    'HyperparameterOptimizationOptions',struct('UseParallel',true,'ShowPlots',true) ...
    )

% Use model to predict Wine Class
outputs=predict(Mdl,In);

%--------------------------------------------------------------------------
% plot confusion matrix
figure
plotconfusion(categorical(targets),categorical(outputs))
title('Full Confusion Matrix')
print('-dpng','wine-full-ConfusionMatrix.png');% save to an png file

%--------------------------------------------------------------------------
% Estimate the predictor importance
imp=predictorImportance(Mdl)
[sorted_imp,isorted_imp] = sort(imp,'descend');   

%--------------------------------------------------------------------------
% Draw a horizontal bar chart showing the variables in descending order of
% importance. Hint: look up the function barh.
% Label each variable with its name. 
% Hints: (1) Look up the function text. (2) Variable names are held in 
% Mdl.PredictorNames
figure;barh(imp(isorted_imp));hold on;grid on;
barh(imp(isorted_imp(1:5)),'y');barh(imp(isorted_imp(1:3)),'r');
title('Predictor Importance Estimates');
xlabel('Estimates with Curvature Tests');ylabel('Predictors');
set(gca,'FontSize',20); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
ax = gca;ax.YDir='reverse';ax.XScale = 'log';

% label the bars
for i=1:length(Mdl.PredictorNames)
    text(...
        1.05*imp(isorted_imp(i)),i,...
        strrep(Mdl.PredictorNames{isorted_imp(i)},'_',''),...
        'FontSize',14 ...
    )
end
print('-dpng','wine-full-input-importance.png');% save to an png file


%--------------------------------------------------------------------------
% Now create a new model with just the top 6 features
In_Smaller=In(:,isorted_imp(1:6));

% Create ensemble model with Hyperparameter Optimization
Mdl_Smaller = fitcensemble(...
    In_Smaller,targets,...
    'OptimizeHyperparameters','all', ...
    'HyperparameterOptimizationOptions',struct('UseParallel',true,'ShowPlots',true) ...
    )

% Use model to predict Wine Class
outputs_smaller=predict(Mdl_Smaller,In_Smaller);

%--------------------------------------------------------------------------
% plot confusion matrix
figure
plotconfusion(categorical(targets),categorical(outputs_smaller))
title('Top 6 Confusion Matrix')
print('-dpng','wine-top6-ConfusionMatrix.png');% save to an png file
