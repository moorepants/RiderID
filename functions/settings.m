function set = settings(dat)
% function set = settings(dat)
%
% dat: prefiltered run data;
% set: settings

%% Measurement Settings
set.Fs = dat.Fs; % Sampling Frequency
set.N = dat.N; % Number of datapoints
set.Ts = 1/dat.Fs; % Sampling time

%% Experiment Settings
set.v = dat.v; % Forward velocity

%% Filter settings
set.f1 = 0.05; % Lower frequency (Hz)
set.f2 = 10.00; % Upper frequency (Hz)
set.D  = 2^3;  % Average over D neighboring frequencies.
set.win = hanning(set.D); % Window type

%% Non parametric model settings
% set.fir.



set.Xlegend = {'k_{\phi p}','k_{\phi i}','k_{\phi d}','k_{\phi dd}',...
               'k_{\delta p}','k_{\delta i}','k_{\delta d}','k_{\delta dd}'};
