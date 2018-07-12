clear;clc;close all

%% Classify Query Data
% This example shows how to classify query data by:
% # Growing a _K_ d-tree
% # Conducting a _k_ nearest neighbors search using the grown tree.
% # Assigning each query point the class with the highest representation
% among their respective nearest neighbors.

%%
% Classify a new point based on the last two columns of the Fisher iris
% data. Using only the last two columns makes it easier to plot.
load fisheriris
x = meas(:,3:4);
gscatter(x(:,1),x(:,2),species)
legend('Location','best')

%%
% Plot the new point.
newpoint = [5 1.45];
line(newpoint(1),newpoint(2),'marker','x','color','k',...
   'markersize',10,'linewidth',2)
%%
% Prepare a _K_ d-tree neighbor searcher model.
Mdl = KDTreeSearcher(x)
%%
% |Mdl| is a |KDTreeSearcher| model.  By default, the distance metric it
% uses to search for neighbors is Euclidean distance.
%%
% Find the 10 sample points closest to the new point.
[n,d] = knnsearch(Mdl,newpoint,'k',10);
line(x(n,1),x(n,2),'color',[.5 .5 .5],'marker','o',...
    'linestyle','none','markersize',10)
%%
% It appears that |knnsearch| has found only the nearest eight neighbors.
% In fact, this particular dataset contains duplicate values.
x(n,:)
%%
% Make the axes equal so the calculated distances correspond to the
% apparent distances on the plot axis equal and zoom in to see the
% neighbors better.
xlim([4.5 5.5]);ylim([1 2]);axis square

%%
% Find the species of the 10 neighbors.
tabulate(species(n))
%%
% Using a rule based on the majority vote of the 10 nearest neighbors, you
% can classify this new point as a versicolor.
%%
% Visually identify the neighbors by drawing a circle around the group of
% them. 
% Define the center and diameter of a circle, based on the location
% of the new point.
ctr = newpoint - d(end);
diameter = 2*d(end);
% Draw a circle around the 10 nearest neighbors.
h = rectangle('position',[ctr,diameter,diameter],...
   'curvature',[1 1]);
h.LineStyle = ':';

grid on
set(gca,'TickDir','out'); set(gca,'LineWidth',2);set(gca,'FontSize',16); 
print('-depsc2','NearestNeighbors.eps');% save to an eps file