function dat = prefilter(raw)
% function dat = prefilter(raw)
%
% Massages the data from the Davis Experiments. It subtracts the mean of the
% outputs, subtracts the linear drift from the lateral force, and selects a
% range of data.
%
% Parameters
% ----------
% raw : structure
%   The data structure generated from `davisdat.m`.
%
% Returns
% -------
% dat : structure
%   The filtered and truncated data.
%   filename : string
%       The path to the original data file.
%   Fs : double, 1 x 1
%       The sample rate in hertz.
%   v : double, 1 x 1
%       The average speed over the duration of the run.
%   t : double, n x 1
%       The time vector.
%   y : double, n x 2
%       The output, roll angle and steer angle, time histories.
%   N : integer, 1 x 1
%       The number of time samples.
%   w : double, n x 1
%       The input, lateral force.

    % Prefilter Settings
    m = 2^10;
    wn = 0.1;

    % Copy data
    dat = raw;

    ii = find(abs(dat.w)>50);

    if min(ii)-m <= 1
        i1 = min(ii)+100;
    else
        i1 = 1;
    end

    if max(ii)+m >= dat.N
        i2 = max(ii)-100;
    else
        i2 = dat.N;
    end

    dat.filename = raw.filename;
    dat.t = raw.t(i1:i2,:);
    dat.w = raw.w(i1:i2,:);
    dat.y = raw.y(i1:i2,:);
    dat.N = size(dat.w,1);

    dat.y = dat.y-repmat(mean(dat.y),dat.N,1);

    % Remove drift from sensor in linear sense
    w = dat.w;
    w1 = mean(dat.w(1:m));
    w2 = mean(dat.w(end-m:end));

    coef = [1 1; 1 dat.N]\[w1; w2];
    f = coef(1) + coef(2)*(1:dat.N)';
    dat.w = w-f;

    dat.t =  dat.t-dat.t(1);

end
