function set = settings(dat)
% function set = settings(dat)
%
% Parameters
% ----------
% dat : structure
%   The prefiltered run data from `prefilter.m`.
%
% Returns
% -------
% set : structure
%   A structure containing various settings.
%   Fs : double, 1 x 1
%       The sampling frequency in Hertz.
%   N : double, 1 x 1
%       The number of samples.
%   Ts : double, 1 x 1
%       The sample period.
%   v : double, 1 x 1
%       The average speed over the run in meters per second.
%   f1 : double, 1 x 1
%       The filter lower cutoff frequency in Hertz.
%   f2 : double, 1 x 1
%       The filter upper cutoff frequency in Hertz.
%   D : double, 1 x 1
%       The number of neighboring frequencies to average over.
%   win : double, (length(D) + 1) x 1
%       The D point hanning window coefficients.
%   Xlegend : cell array of char, 1 x 8
%       The LaTeX string for each of the eight gains.

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
