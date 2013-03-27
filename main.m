% Davis data analysis and identification
clear; close all; clc; addpath('functions');

% Loading data
try % loading data file
    load('data/data.mat');
catch me
    disp(me);
    disp('No Data Detected -> Processing...');
    % Calculations:
    r = dir('data/measurements');
    filelist = {r(3:end).name}; clear r;
    for i = 1:length(filelist)
        disp([num2str(i) '/' num2str(length(filelist))]);
        raw(i) = davisdat(filelist{i}); % #ok<SAGROW> % Load davis Dat
        dat(i) = prefilter(raw(i)); %  %#ok<SAGROW>% Filtering davis data
        set(i) = settings(dat(i)); % %#ok<SAGROW> % Measurement settings, etc.
        npm(i) = nonparametricmod(dat(i),set(i)); % %#ok<SAGROW> % Nonparameteric modelling
        mod(i) = {parametricmod(npm(i),dat(i),set(i))}; % %#ok<SAGROW>% Parameteric modelling
    end
    save('data/data.mat');
end

%% Plotting

% Select which meaurement and corresponding parametric model for plotting:
i = 1; % measurement number
j = 5; % parameteric model number

% Define timespan for plotting time domain results:
timespan = [dat(i).t(1) dat(i).t(end)]; % or: timespan = [25 60];

% Output figures:
fig(1) = datfig(dat(i),1,NaN); % Raw data plot
fig(2) = firfig(npm(i),dat(i),2); % FIR plot
fig(3) = resfig(npm(i),dat(i),set(i),3,timespan); % Decomposition plot
fig(4) = modfig(npm(i),dat(i),mod(i),set(i),4,j,timespan); % Parametric model plot
fig(5) = firmodfig(npm(i),mod(i),dat(i),i,j); % Parametric and non-parametric FIR plot
fig(6) = covfig(mod(i),set(i),i,j); % Covariance figures
