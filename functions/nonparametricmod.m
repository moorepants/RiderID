function  [npm] = nonparametricmod(dat,set)
% function  [npm] = nonparametricmod(dat,set)
%
% Parameters
% ----------
% dat : structure
%   The prefiltered data from `prefilter.m`.
% set : structure
%   The settings from `settings.m`.
%
% Returns
% -------
% npm : structure
%   The non-parametric response results.
%   N : double, 1 x 1
%       The number of samples.
%   v : double, n x 2
%       Remnant/noise for roll and steer, time series
%   t : double, n x 1
%       Time signal for non parametric time series output
%   y : double, n x 2
%       Non parametric model output roll and steer, time series
%   g : double, n x 2
%       Filtered FIR coefficients, delta time series
%   g_raw : double, n x 2
%       Unfiltered (raw) FIR coefficients. delta time series
%

t = dat.t;
N = set.N;
npm.N = N;

% FIR model of input related noise:
fir = firestimation(dat); % Finite impulse response
g = zeros(size(dat.y)); g(1:sum(fir.tau>=0),:) = fir.g(fir.tau>=0,:);
g_raw = zeros(size(dat.y)); g_raw(1:sum(fir.tau>=0),:) = fir.g_raw(fir.tau>=0,:);

% Simulation by convolution of the FIR model and input force f.]
y = zeros(size(dat.y));
for i = 1:size(dat.y,2);
    y(:,i) = conv(dat.w,[zeros(size(g(2:end,1))); g(:,i)],'same')/set.Fs;
end

% Remnant
dat.y-y; % Remnant

% Non parametric response results:
npm.v = v;
npm.t = t;
npm.y = y;
npm.g = g;
npm.g_raw = g_raw;
