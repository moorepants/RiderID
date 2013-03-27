% function sys = schommel(parms)

clear all; close all; clc;

% Symbols
syms m g h r t real;
syms theta thetad thetadd phi phid phidd real;
syms y yd ydd z zd zdd  real;
syms Ttheta real;
syms lambda real;

d = r/2*sqrt(2);
e = r/2*sqrt(2);

% Create state vectors
q   = [phi  theta]';
qd  = [phid  thetad]';
qdd = [phidd  thetadd]';

n = length(q);

% Equations of Motion
Mij = diag([m m m*e^2 ]);
fi  = [0 m*g 0]';

c1 = cos(phi);
s1 = sin(phi);
c2 = cos(theta+phi);
s2 = sin(theta+phi);

y =  h*s1 - d*s2;
z = -h*c1 + d*c2;

xi = [y;z;theta+phi];

%% Lagrange
% 
% M = Mij;
% u = xi;

% % create kinetic energy
% T0 = 1/2*(jacobian(u,t))'*M*jacobian(u,t);
% T1 =     (jacobian(u,t))'*M*jacobian(u,q)*qd;
% T2 = 1/2*(jacobian(u,q)*qd)'*M*jacobian(u,q)*qd;
% 
% T = T0 + T1 + T2;
% V = -2*m*g*z;


% Lagrange equation
% dT_qd = jacobian(T,qd).';
% dT_q  = jacobian(T,q).';
% dV_q  = jacobian(V,q).';

% Total differentation of dT_dq with respect to time:
% dT_dq_t = jacobian(dT_qd,t) + jacobian(dT_qd,q)*qd + jacobian(dT_qd,qd)*qdd;

% Add up terms to form the Lagrangian equations:
% Lagrangian = simplify(dT_dq_t - dT_q + dV_q);

%% TMT method

% Transformation matrix
Fi_r = jacobian(xi,q);

% Transformation
Msr = Fi_r.'*Mij*Fi_r;
gj  = jacobian(Fi_r*qd,q)*qd; % Convective terms
fs  = Fi_r.'*(fi -Mij*gj);

% Free equations of motion
Msr = simplify(Msr);
fs  = simplify(fs);

%% Constraints

% Constraints
Dk = phi;

% Partial derivatives of Dk with respect to xi
Dk_s =  jacobian(Dk,q)';
Dk_r =  jacobian(jacobian(Dk,q)*qd,qd);
fk   = -jacobian(jacobian(Dk,q)*qd,q)*qd;

%% Constrained equations

% Setting up the equations
Q     = [Msr Dk_s; Dk_r zeros(length(Dk))];
f     = [fs; fk];

% g = parms.g;
% m = parms.m;
% e = parms.e;
% h = parms.h;
% d = parms.d;


% Linearize
phi = 0; phid = 0; theta = 0; thetad = 0;

M = subs(jacobian(Msr*qdd-fs,qdd));
C = subs(jacobian(Msr*qdd-fs,qd));
K = subs(jacobian(Msr*qdd-fs,q));

% sys.A = subs([-M(1,2)\C(1,2) -M(1,2)\K(1,2); eye(1) zeros(1);]);
% sys.B = subs([ M(1,2)\eye(1); zeros(1)]);
% sys.C = [ 0 1];
% sys.D = zeros(1,1);
%     
%     % Combine A,B,C and D matrices into a state space object.
% sys.theta = ss(sys.A,sys.B,sys.C,sys.D);




