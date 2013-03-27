function est = covest(sim,mod,simset)
% function cov = covest(sim,mod{i}.sym);
%
% Estimates the covariance given a input, noise and sensitiviity model.
%
% Parameters
% ----------
% sim : structure
%   Should have the input, w, and the noise, v, time series.
% mod :
%
% simset :
%
% Returns
% -------
% est : structure
%   covar : double
%       The covariance.

sym = mod.sym;

f = simset.f;
v = sim.v;
w = sim.w;

N = simset.N;
W = fftshift(1/sqrt(N)*fft(w),1);
V = fftshift(1/sqrt(N)*fft(v),1);

[b, a] = butter(4,0.02);
Svv = conj(V).*V; Svv = abs(Svv); Svv = filtfilt(b,a,Svv);
Sww = conj(W).*W; Sww = abs(Sww);

sel = find(Sww>1);

X = mod.X;
X1 = X(1);  X2 = X(2);  X3 = X(3);  X4 = X(4); %#ok<*NASGU>
X5 = X(5);  X6 = X(6);  X7 = X(7);  X8 = X(8);

tmp = zeros(length(X),length(X),length(sel));
for i = 1:length(sel);
    disp(['Calculating Fisher sum: ',num2str(i),'/',num2str(length(sel))]);
    s = 2*pi*f(sel(i));
    dGdXn = eval(sym.dydXn);
    tmp(:,:,i) = Sww(sel(i),1)./Svv(sel(i),2).*dGdXn'*dGdXn;
end
fisher = N*sum(tmp,3);
covar = inv(fisher);

est.cov = covar;
est.fis = fisher;
