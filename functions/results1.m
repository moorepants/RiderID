function res = results1(fil,fir)
% Testing the fir filter by simulating it using the measured input f.

    % Simulation by convolution of the FIR model and input force f.]
    res = fil;
    for i = 1:size(fil.y,2);
        res.y(:,i) = conv(fil.w,[zeros(fir.m2+fir.m1,1); fir.g(:,i)],'same')/fil.Fs;
    end
    
    % Error is difference between model and simulation output
    res.N = size(res.y,1);
    res.v = fil.y - res.y;
    res.legend = {'\phi','\delta'};
    res.ylim = 4/3*max(abs(res.y))'*([-1 1]+1/4);
    
    res.f = res.Fs/2*linspace(-1,1,res.N)';    
    res.V = fftshift(1/sqrt(res.N)*fft(res.v),1);
    res.Svv = conj(res.V).*res.V;
    
end