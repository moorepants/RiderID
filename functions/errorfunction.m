
% Error definition
function Vn = errorfunction(thetan,X0,V0,i,mf,mod,mSvv,mSww,mG,N)
    Xn = zeros(size(X0)); Xn(logical(X0)) = thetan+0.01;
    X = Xn.*X0; % Renormalizing
    disp(X);
    tmp = riderfunc(X,tf('s'),i,mod); % X,s,i,mod
    mGmod = squeeze(freqresp(tmp.y,2*pi*mf)).';
    
    V = 1/N*sum(conj(mG(:,2) - mGmod(:,2)).*(mG(:,2) - mGmod(:,2)).*mSww(:,2)./mSvv(:,2));
    
    Vn = V/V0;
end