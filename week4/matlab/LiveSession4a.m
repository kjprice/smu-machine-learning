clear;clc;close all

% percentage noise
noise_p=.1;
%--------------------------------------------------------------------------
% Set up the some test data
n=1000;
x = 2*(rand(n,1)-0.5);
y = 2*(rand(n,1)-0.5);
noise=noise_p*2*(rand(n,1)-0.5);
z = (x.^5 + y.^4 - x.^4 - y.^3);
z = z+z*noise_p;
x_train=x;
y_train=y;
z_train=z;

clear x y z noise

n=100;
x = 2*(rand(n,1)-0.5);
y = 2*(rand(n,1)-0.5);
noise=noise_p*2*(rand(n,1)-0.5);
z = (x.^5 + y.^4 - x.^4 - y.^3);
z = z+z*noise_p;
x_test=x;
y_test=y;
z_test=z;

save trainingdata.mat x_test x_train y_test y_train z_test z_train


