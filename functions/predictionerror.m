function mod = predictionerror(mod,res,fil,fir)

Ts = 1/fil.Fs;

q = tf('q',TS);

h = ifft(re

h = impulse(rem.H);


invH = real(ifft(sqrt(res.N)*ifftshift(1./res.H_mod,1)));


H = real(ifft(sqrt(res.N)*ifftshift(res.H_mod,1)));
