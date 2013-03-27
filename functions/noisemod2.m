function rem = noisemod2(npm)


    f = npm.f(npm.f>0,:); % frequency (Hz)
    V = npm.V(npm.f>0,:); % noise spectrum  v(j\omega)

    gamma = npm.L(npm.f>0,:);

    X0 = [    0.0204    1.8815    0.1745    0.0216    0.0025   22.5881    0.0743    0.0167];
    V0_mod = V_modfunc(X0,f);

     

    X0n = ones(size(X0));
    e0 = error_freq(X0n,V,@V_modfunc,gamma,f,X0);

    lsqfunc = @(Xn)error_freq(Xn,V,@V_modfunc,gamma,f,X0);
    Xn = lsqnonlin(lsqfunc,X0n);
    X = Xn.*X0;
    
    V_mod = V_modfunc(X,f);
    
    loglog(f,[abs(V) abs(V_mod) abs(V0_mod)]);
    
 

    s = tf('s');
    
    H = [X(1)*(1+X(2)*s)/(1 + X(3)*s)^4*(1+X(4)*s)^2 ...
         X(5)*(1+X(6)*s)/(1 + X(7)*s)^6*(1+X(8)*s)^4;];      
    Hd = c2d(H,1/200);
    disp(isstable(1/Hd(1)));
    disp(isstable(1/Hd(2)));

end

% Error definition
function e = error_freq(Xn,V,V_modfunc,gamma,f,X0)
    X = Xn.*X0;
    V_mod = V_modfunc(X,f);
    e = reshape(sqrt(1./repmat(f,1,2)).*gamma.*...
        abs(log(V./V_mod)),numel(V),1);
end

function V_mod = V_modfunc(X,f)

    s = 1j*2*pi*f;
      
     V_mod = [X(1).*(1+X(2).*s)./(1 + X(3).*s).^4.*(1+X(4).*s).^2 ...
              X(5).*(1+X(6).*s)./(1 + X(7).*s).^6.*(1+X(8).*s).^4;];    

end

