function  [npm,dat] = nonparametricmod(dat,set)

t = dat.t;
f = linspace(-1,1,set.N)'*set.Fs/2;
N = set.N;
npm.N = N;

% FIR model of input related noise:
fir = firestimation(dat); % Finite impulse response
npm.m = 2^10;
g = zeros(size(dat.y)); g(1:sum(fir.tau>=0),:) = fir.g(fir.tau>=0,:);
g_raw = zeros(size(dat.y)); g_raw(1:sum(fir.tau>=0),:) = fir.g_raw(fir.tau>=0,:);
% G = fftshift(1/sqrt(set.N)*fft(g),1); % FFT(v(t))

% Simulation by convolution of the FIR model and input force f.]
y = zeros(size(dat.y));
for i = 1:size(dat.y,2);
    y(:,i) = conv(dat.w,[zeros(size(g(2:end,1))); g(:,i)],'same')/set.Fs;
end

% Remnant
v = dat.y-y; % Remnant
V = fftshift(1/sqrt(set.N)*fft(v),1); % FFT(v(t))


Svv_raw = conj(V).*V;
m = 2^3+1; 
Svv = freqwinavg(Svv_raw,f,m);

    

% Digital bandpass filter
L = zeros(size(y));
L(f>=set.f1 & f<=set.f2,:) = 1;
L(f<=-set.f1 & f>=-set.f2,:) = 1;
% l = real(ifft(sqrt(N)*ifftshift(L,1)),'.-');

% % % % % Svv = conj(V).*V;
% % % % % mSvv = freqwinavg(Svv,f,2^4+1);
% % % % % 
% % % % % E = V./sqrt(mSvv);
% % % % % 
% % % % % lambda = diag(abs(1/N*E'*E)); 
% % % % % 
% % % % % loglog(f,abs([Svv mSvv]))
% % % % % 
% % % % % figure;
% % % % % 
% % % % % plot(f,abs(V./sqrt(mSvv)))
npm.v = v;
npm.t = t;
npm.y = y;
npm.f = f;
npm.V = V;
npm.L = L;
npm.Svv = Svv;

% 
% % Noise model
% modH = noisemod(npm); % Noise model
% modHd = c2d(modH,set.Ts);
% modH_inv = [1/modH(1);1/modH(2)];
% modHd_inv = c2d(modH_inv,set.Ts);
% 
% V_mod = squeeze(freqresp(modH,2*pi*f)).';
% v_mod = squeeze(impulse(modHd,t));
% V_inv = squeeze(freqresp(modH_inv,2*pi*f)).';
% v_inv = squeeze(impulse(modHd_inv,t));
% 
% % Find noise model
% lambda = v_mod(1,:);
% 
% h = v_mod./repmat(lambda,N,1);
% H = V_mod./repmat(lambda,N,1);
% h_inv = v_inv.*repmat(lambda,N,1);
% H_inv = V_inv.*repmat(lambda,N,1);
% 
% 
% % Simulation by convolution of the FIR model and input force f.]
% yp = zeros(size(dat.y)); ep = zeros(size(dat.y));
% yp_w = zeros(size(dat.y)); yp_y = zeros(size(dat.y));
% 
% for i = 1:size(dat.y,2);
%     yp_w(:,i) = conv(y(:,i),[zeros(size(y(2:end,1)));h_inv(:,i)],'same')/set.Fs;
%     yp_y(:,i) = dat.y(:,i) - conv(dat.y(:,i),[zeros(size(h_inv(2:end,1)));h_inv(:,i)],'same')/set.Fs;
%     yp(:,i) = yp_w(:,i) + yp_y(:,i);
%     ep(:,i) = dat.y(:,i) - yp(:,i);
% end


% Non parametric response results:

npm.t = t;
npm.y = y;
npm.f = f;
% npm.H = H;
% npm.h = h;
% npm.H_inv = H_inv;
% npm.h_inv = h_inv;
% npm.lambda = lambda;
npm.G = [];
npm.g = g;
npm.g_raw = g_raw;
% npm.yp = yp;
% npm.ep = ep;
