function [g,tau] = markovparm2(y,u,m1,m2)
% function [g,tau] = markovparm2(y,u,m1,m2)
%
% This is where the non parametric magic happens!
% Estimates a finite number of Markov parameters g(tau) based on input u
% and output y. the model is effectively an m*2+1 order FIR model.
% Since the process enhances an inverse operation, the estimation
% may be slow for large datasets. The input u is assumed to be zero outside
% the measurement scope. This is seemed valid to us, since we have not
% applied lateral peturbations shortly before and after the measurement.
%
% Parameters
% ----------
% y  : double, n x 2
%      Output Roll and Steering angle, time histories.
% u  : double, n x 1
%      Input, lateral perturbation force (w), time histories
% m1 : Integer, 1 x 1
%      Start sample number of FIR window (integer)
% m2 : Integer, 1 x 1
%      End sample number of FIR window (integer)
%
% Returns
% -------
% g   : double, (m2+1-m1) x 2
%       Fir coefficients, time history
% tau : double, (m2+1-m1) x 1
%       Corresponding discrete lead/lag time of FIR coefficients
%


n = length(y);
tau = (m1:m2)';
U = zeros(n,length(tau));
Y = zeros(n,1);

for i = 1:n
    for j = m1:m2
        if (i-j >= 1) && (i-j <= n)
            U(i,j-m1+1) = u(i-j);
        else
            U(i,j-m1+1) = 0;
        end
    end
    Y(i,:) = y(i);
end
g = (U'*U)\U'*Y;
