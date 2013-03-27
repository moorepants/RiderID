clear all; close all; clc;

s = tf('s');

z = -0.030*s;

sys0 = 1/(1+0.1*s);

sys1 = sys0*exp(z);
sys2 = sys0*(1+1/2*z+1/12*z^2)/(1-1/2*z+1/12*z^2);

%% Time

t = linspace(0,1/5,201);
[y0,t] = impulse(sys0,t);
[y1,t] = impulse(sys1,t);
[y2,t] = impulse(sys2,t);


figure(1);
h(1) = plot(t,y1,'k-'); hold on; title('Impulse response of H=1/(1+0.1*s) with different time delays');
h(2) = plot(t,y0,'k-.'); 
h(3) = plot(t,y2,'k--');
legend(h,'H*e^{-\tau_ds}','H','H*pade(e^{-\tau_ds},2)');

ylim([-5 15]);
xlabel('time (s)'); ylabel('Amplitude (-)');
sdf('Latex');

%% FReq

f = logspace(-2,2,201);

[Y0] = squeeze(freqresp(sys0,2*pi*f));
[Y1] = squeeze(freqresp(sys1,2*pi*f));
[Y2] = squeeze(freqresp(sys2,2*pi*f));

figure(2); clf;
h(1) = semilogx(f,phase(Y1),'k-');
hold on; title('Frequency response of H=1/(1+0.1*s) with different time delays');
h(1) = semilogx(f,phase(Y0),'k-.');
h(1) = semilogx(f,phase(Y2),'k--');
legend(h,'H*e^{-\tau_ds}','H','H*pade(e^{-\tau_ds},2)');
ylim([-10 5]);
xlabel('frequency (Hz)'); ylabel('phase (rad)');
sdf('Latex');




% bode(sys,sys1,sys2);