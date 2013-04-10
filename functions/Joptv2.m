function J=Jopt(pars)
%pars(1:5).^2=diag(Q)
%pars(6).^2=diag(R)
global v K Klqr

%clear all; close all; clc;

%% Parameters

% % Coefficient matrices;
% M0 = [131.5085 2.6812; 2.6812 0.2495];
% K0 = [-116.19 -2.7633; -2.7633 -0.94874];
% K2 = [0 102.02; 0 2.5001];
% C1 = [0 42.748; -0.31806 1.6022];
% Coefficient matrices;

M0 = [ 133.31668525,    2.43885691;  2.43885691,   0.22419262];
C1 = [   0.0       ,   44.65783277; -0.31500940,   1.46189246];
K0 = [-116.73261635,   -2.48042260; -2.48042260,  -0.77434358];
K2 = [   0.0       ,  104.85805076;  0.00000000,   2.29688720];

% Hfw = [0.91; 0.014408]; % dfx/dTq

% External parameter;
g = 9.81;


% External parameters;
% Vs = [3.2 4.3 7.4];
% g = 9.81;

% Gains K v=3.2 (reduced 4 parameter model) 
% state = [diff(phi,t),diff(delta,t), phi, delta, int(delta,t)]';
% the following parameter are defined such that they match this state.
% Ks = [32.9892 -3.2502 36.8145 0  89.4486
%       33.79   -2.74   29.58   0 195.40
%       41.56   -10.56  59.20   0 816.11];
% LQR weight values
% state = [dphi ddelta phi delta idelta]
% xhat_i are maximum alowable values fro state variable x_i
% Q(i,i) = 1/xhat_i^2
Q = diag(pars(1:5).^2);
% control u=[Tdelta]
% R(1,1) = 1/tauhat^2
R = pars(6)^2;


% vid=3;
% v=Vs(vid);
% K=Ks(vid,:);

% State Space description of uncontrolled bicycle
A = [-M0\C1*v -M0\(K0*g + K2*v^2) zeros(2,1)
     1 0 0 0 0
     0 1 0 0 0
     0 0 0 1 0];
B = [ M0\[0;1]; zeros(3,1)];
C = eye(5);
D = zeros(5,1);

% determine Klqr according to LQR algorithm
[Klqr,Slqr,elqr] = lqr(A,B,Q,R)

pars

[K;-Klqr]

% only look at the gains according to loc 
% state = [dphi ddelta phi delta idelta]
loc = logical([1 1 1 1 1]);

tmp = (K(loc)+Klqr(loc));
J = tmp*tmp.'
end

