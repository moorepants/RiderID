function [mod] = riderfunc(X,s,j,mod)
% function [mod] = riderfunc(X,s,j,mod)
%
% Adds a rider model to the model structure
% 
% Parameters
% ----------
% X    : double, 1 x 8
%   	 Model parameters
% s    : symbol or transfer function, 1 x 1
%        Laplace operator
% j    : integer, 1 x 1
%        Model index
% mod  : Structure
%        Structure containing parametric model data. 
% 
% Returns
% -------
% mod  : Structure
%        Adds the rider related variables to the model structure,
%        including: model parameters X, transferfunction C and K, etc.
%        See also parametricmod.m for more information. 
%


    % Declarations/limitations
    omegac = 2*pi*2.17; %2*pi*2.17;
    Gnm = omegac^2/(s^2 + 2*sqrt(1/2)*omegac*s + omegac^2);

    % Time delay:
    delay = 1;
    %     if i>6
    %         z = -0.030*s;
    %         delay = (1+1/2*z+1/12*z^2)/(1-1/2*z+1/12*z^2);
    %     end
    
    % Gain model
    mod.X = X;
    pid = [1;1/s;s;s^2];
    mod.C =  mod.X(1:8)*[pid zeros(4,1); zeros(4,1) pid];
    mod.K =  mod.C*Gnm*delay;

    %     % Discretization
    %     Ts = 0.005;
    %     mod.K = c2d(mod.K,Ts);
    %     mod.G.yu = c2d(mod.G.yu,Ts);
    %     mod.G.yw = c2d(mod.G.yw,Ts);
 
    % Calculate closed loop system responses
    me = []; %#ok<NASGU>
    mod.y =  mod.G.yw + mod.G.yu*((eye(1)-mod.K*mod.G.yu)\mod.K*mod.G.yw);
    try mod.y =  minreal(mod.y); catch me; end %#ok<NASGU>
    mod.z = -mod.y(1);
