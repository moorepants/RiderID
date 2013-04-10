function fir = firestimation(dat)
% function fir = firestimation(dat)
%
% Returns the Finite Impuluse Response (FIR) from time domain data.
%
% Input:
% - dat; structure which contains the time domain data of a measurement.
%
% Output:
% - fir; structure which contains the fir response data of a measurements.
%

    % Settings
    m1 = -2^9+2^8; % tau_min samples
    m2 =  2^9+2^8; % tau_max samples
    wn =  0.05; % Nyquist normalized datter factor

    % FIR finite impulse response function g(tau)
    N = size(dat.y,2);

    % Timeshift vector tau
    DeltaT = 1./dat.Fs;
    tau = DeltaT*(m1:m2)';
    M = length(tau);

     % FIR windowing
    shift = 2^6; 
    win = zeros(size(tau)); win(tau>0) = 1; win(end-shift:end) = 0;
    win((m2+1:end)-shift) = 1/2*(1+cos((0:-m1)*pi/(-m1))); 

    % datter parameters
    [b, a] = butter(4,wn);

    % For every output y
    g = zeros(M,N); g_raw = zeros(M,N);
    for i = 1:N
        g_raw(:,i) = markovparm2(dat.y(:,i),dat.w,m1,m2)/DeltaT;
        g(:,i) = filtfilt(b,a,g_raw(:,i));
        g(:,i) = g(:,i).*win;
    end

    % Output
    fir.m1 = m1;
    fir.m2 = m2;
    fir.tau = tau;
    fir.g_raw = g_raw;
    fir.g = g;
    fir.legend = {'g_\phi','g_\delta'};

end
