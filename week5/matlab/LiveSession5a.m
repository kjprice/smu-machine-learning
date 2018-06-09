clear;clc;close all

iverb=1;

load('AmbrosiaTulsaTraining.mat')

whos

WantedName={...
    'Lag_15_MaxDISPH','Lag_26_MinGRN','MinZ0H','Lag_9_MeanEFLUX',...
    'Lag_9_MaxEVPTRNS','Lag_12_MeanEVPTRNS','Lag_9_MeanEVPTRNS',...
    'Lag_14_MeanEVPTRNS','Lag_11_MeanEVPTRNS','Lag_12_MaxEVPTRNS',...
    'Lag_8_MaxEVPTRNS','Lag_11_MaxEVPTRNS','Lag_14_MaxEVPTRNS',...
    'Lag_30_MinTELAND','MeanTSH','Lag_29_MinTELAND','Lag_1_MeanTSH',...
    'MaxHLML','Lag_8_MaxEFLUX','Lag_29_MaxTELAND','MeanTUNST',...
    'Lag_1_MeanTUNST','Lag_8_MaxEVAP','MeanTWLT'...
    };


%--------------------------------------------------------------------------
% Set up the machine learning matrices
disp('Set up the machine learning matrices')
tic
command=['Y=Out;X=[In'];
for i=1:30
    command=[command ' TS_' num2str(i)];
end
command=[command '];'];
disp(command);
eval(command);
toc

%--------------------------------------------------------------------------
% Set up the variable names
disp('Set up the machine learning matrices')
tic
icount=0;
% time lag loop
for i=0:30
    % loop over variables for this time lag
    for j=1:length(namesTS)
        icount=icount+1;
        if i==0
            names{icount}=namesTS{j};
        else
            command=['names{icount}=namesTS_' num2str(i) '{j};'];
            if iverb
                disp(command);
            end
            eval(command);
        end
    end
    % loop over variables for this time lag
end
% time lag loop
toc

whos names

%--------------------------------------------------------------------------
% Drop rows with missing values
disp('remove rows with missing pollen values')
whos X Y
[row,col]=find(isnan(Y));
X(row,:)=[];
Y(row)=[];
whos X Y
N=length(Y);

%--------------------------------------------------------------------------
% Drop columns which are constant
disp('Drop columns which are constant or have NaN')
nx=size(X);
ikeep=[];
for i=1:nx(2)
    clear x iwant
    x=squeeze(X(:,i));
    if abs(range(x))>0 & length(find(isnan(x)))==0
        ikeep=[ikeep i];
    end
end
% just keep rows that have valid non-constant data
clear x
x=X(:,ikeep);
X=x;
clear x

clear keptnames
for i=1:length(ikeep)
    keptnames{i}=names{ikeep(i)};
end
clear names
names=keptnames;
clear keptnames

whos X Y

%--------------------------------------------------------------------------
% Create a table from the X array
Data=array2table(X,'VariableNames',names);
Data.Pollen=Y;

%--------------------------------------------------------------------------
% Set up the X & Y arrays
command=['Out=Y;In=double(['];
for i=1:length(WantedName)
    if length(WantedName{i})>0
        command=[command 'Data.' WantedName{i}];
        if i<length(WantedName)
            command=[command ' '];
        end
    end
end
command=[command ']);'];
disp(command)
eval(command);

Names=WantedName;

whos In Out

%--------------------------------------------------------------------------
% Create a data set for the regression learner app
All=[In Out];

save pollen-example-all.mat All

%--------------------------------------------------------------------------
% Now split up the data into a training and an independent validation
% portion
validation_fraction=0.1;

% write to the command window
disp(['Validation Fraction is: ' num2str(validation_fraction)])

nskip=floor(1/validation_fraction);
disp(['nskip is ' num2str(nskip)])
ichoose=1:nskip:length(Out);

% Training Data
In_train=In;
Out_train=Out;
In_train(ichoose,:)=[];
Out_train(ichoose)=[];

% Independent Validation Data
In_test=In(ichoose,:);
Out_test=Out(ichoose);    

save pollen-small.mat In Out In_train Out_train In_test Out_test Names



save pollen-example-all.mat All