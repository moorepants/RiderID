% What do we optimize in bicycle control (on a treadmill)
% search for otpimal values for Q and R
addpath('functions');

global v K Klqr

load('data/ResultsvKFromPeter19dec2012.txt')
vK = ResultsvKFromPeter19dec2012;
% vK:
% ID  v   kpp   kpd   kdi   kdd   VAF
%  1  2    3     4     5     6     7
% but the state vector is
% dphi ddelta phi delta idelta
% so the index for vK will be:
%  4      6    3    0     5

[n,m] = size(vK);

for k = 1:n

  id = vK(k,1);
  v = vK(k,2);
  %     kpd      kdd    kpp    kdp  kdi
  K = [vK(k,4) vK(k,6) vK(k,3)  0  vK(k,5)];
  % The general index is
  % ID v kpp kpd kdp kdi kdd FAV/J


  %pars0 = [0 0 1 0 20 0.01];
  format shorte

  pars0 = [1 1 1 1 1 1];
  options = optimset('TolX',1e-6);

  [X,FVAL,EXITFLAG,OUTPUT] = fminsearch(@Joptv2,pars0,options)

  % transform scale from int(delta dt) to psi = v/w*int(delta dt)
  % and take the absolute values because we use X.^2 in the optimiziation
  % were X stands for 1/x_max
  w = 1.0759;
  sc = [1 1 1 1 v/w 1];
  XS = sc.*X;

  v
  K
  IXS = 1./abs(XS)
  % normalize with respect to the max tau_\delta value
  IXSN = IXS./IXS(6)

  Rid(k) = id;
  Rv(k) = v;
  RK(k,:) = K;
  RKlqr(k,:) = -Klqr;
  Rxhat(k,:) = IXSN;
  RFVAL(k) = FVAL;
  RVAF(k) =  vK(k,7);
end

%%
set(0,'DefaultLineLineWidth',3);
figure
semilogy(Rxhat.','-o')
%plot(Rxhat.','-o')
grid on

for k=1:n
  text(1.05,Rxhat(k,1),sprintf('%g',Rid(k)))
  text(2.05,Rxhat(k,2),sprintf('%g',Rv(k)))
end

clear Table1 Table2 Table3 Table4
% create some Tables
% The order for the presentation is
% kpp kpd kdp kdi kdd
%  1   2   3   4   5
% The general math model order is
% kpd kdd kpp kdp kdi
%  1   2  3   4   5

loc1 = [3 1 5 2];
loc2 = [3 1 4 5 2];

for k=1:n
  Table1(k,:) = [Rid(k) Rv(k) RK(k,loc1) RVAF(k)];
  Table2(k,:) = [Rid(k) Rv(k) RKlqr(k,loc2) RFVAL(k)];
  Table3(k,:) = [Rid(k) Rv(k) 100.*(-RK(k,loc1)+RKlqr(k,loc1))./RK(k,loc1) RFVAL(k)];
  Table4(k,:) = [Rid(k) Rv(k) log10(Rxhat(k,:)) RFVAL(k)];
end

save Tables.mat Table1 Table2 Table3 Table4
