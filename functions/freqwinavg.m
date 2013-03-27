function mS = freqwinavg(S,f,m)

    N = size(S,1);
    win = repmat(ones(m,1),1,size(S,2));
    mf = floor(m/2); 
    S0 = S(f>0,:); N0 = size(S0,1); mS0 = zeros(size(S0));
    for i = 1:N0
        if i<mf+1
            value = sum(S0(mf+2-i:m,:).*win(mf+2-i:m,:),1)./sum(win,1);
        elseif i>N0-mf-1
            value = S(end,:);
        else
            value = sum(S0(i-mf:i+mf,:).*win,1)./sum(win,1);
        end
        mS0(i,:) = value;
    end
    mS = [flipud(conj(mS0)); S(f==0,:); mS0];
    
end