function sim = modsim(npm,mod,simset)

t = simset.t;
w = simset.w;
Ts = simset.Ts;
Fs = simset.Fs;
N =  simset.N;
f =  simset.f;
 
g = npm.g;

En = ones(size(t,1),size(g,2)).*exp(2*pi*1j*rand(size(t),size(g,2)));
Svv = interp1(npm.f,npm.Svv,f);
V = sqrt(Svv).*En;
v = ifft(sqrt(N)*ifftshift(V,1)); v = sqrt(2)*real(v);

% Simulation by convolution of the FIR model and input force f.]
yfir = zeros(size(t,1),size(g,2));
for j = 1:size(g,2);
    yfir(:,j) = conv(w,[zeros(size(g(2:end,j))); g(:,j)],'same')/Fs;
end

% SImulation by parametric model'
ymod = lsim(mod.y,w,t);

y = ymod + v;

%% 

% N = simset.N;
% W = fftshift(1/sqrt(N)*fft(w),1); 
% V = fftshift(1/sqrt(N)*fft(v),1); 
% 
% [b, a] = butter(4,0.02);
% Svv = conj(V).*V; Svv = abs(Svv); Svv = filtfilt(b,a,Svv);
% Sww = conj(W).*W; Sww = abs(Sww);



%% Output

sim.N = N;
% sim.Svv = Svv;
% sim.Sww = Sww;
sim.w = w;
sim.t = t;
sim.y = y;
sim.v = v;
sim.yfir = yfir;
sim.ymod = ymod;
sim.f = f;