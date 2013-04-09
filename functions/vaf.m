function v = vaf(y,y_est)
% function v = vaf(y,y_est)
%
% Variance Acounted For (VAF)
%
% Parameters
% ----------
% y     : double, n x 1
%         measured signal (n samples),  time series
% y_est : double, n x 1
%         modeled signal (n samples), time series
%
% Returns
% -------
% v     : double, 1 x 1
%         Variance Acounted For (VAF)
%

v = 100*(1-cov(y-y_est)./cov(y));

