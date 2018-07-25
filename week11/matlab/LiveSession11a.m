clear;clc;close all

%% Generate a circle in 2 dimensions (300 points in 2 dimensions)
X = randn(300, 2);
X = X./(sqrt(sum(X.*X,2))*ones(1, 2));

%% Find the Inter-point Distance Matrix
d = L2_distance(X',X',1);

%% Find the filter, here we use the distance from the first point
eccFilter = d(1, :);
scatter(X(:,1), X(:,2), 1000, eccFilter, '.');
axis equal;
colorbar

%% Parameters for Mapper
filterSamples = 5;
overlapPct = 50;

%% Run Mapper
[adja, nodeInfo, levelIdx] = mapper(d, eccFilter, 1/filterSamples,...
                                                        overlapPct);
                                         
%% Prepare inputs for GraphViz
% For each node of the output graph, find the size (~ cardinality of the
% cluster) and the average function value of points in the cluster.
label{1} = sprintf('Dataset Name   : test');
label{2} = sprintf('Filter Samples : %d', filterSamples);
label{3} = sprintf('Overlap Pct    : %0.2f', overlapPct);

for i=1:length(nodeInfo)
    ecc(i) = nodeInfo{i}.filter;
    setSize(i) = length(nodeInfo{i}.set);
end

%% Generate the input to Graphviz
writeDotFile(sprintf('/tmp/t1.dot'), adja, ecc, setSize, label);

%% Execute Graphviz
%system(sprintf('/opt/local/bin/neato -Tpng /tmp/t1.dot -o /tmp/t1.png'));
%imshow('/tmp/t1.png')