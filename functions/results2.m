function res = results2(res,rem)


res.V_mod = squeeze(freqresp([rem.H(1) rem.H(2)],2*pi*res.f)).';
res.v_mod = real(ifft(sqrt(res.N)*ifftshift(res.V_mod,1)));


% Find noise model
res.lambda = res.v_mod(1,:);
res.h_mod = res.v_mod./repmat(res.lambda,res.N,1);
res.H_mod = res.V_mod./repmat(res.lambda,res.N,1);


% % Symmetric random phase generation
% tmp = exp(1i*2*pi*rand(N2floor,size(res.H_mod,2)));
% res.E = [tmp; zeros(1,size(res.H_mod,2)); flipud(conj(tmp))];

% 
% close all
% loglog(res.f,abs(res.H_mod),':'); hold on;
% loglog(res.f,abs(res.V))
% 
% close all
% for i = 1:2
%     figure(1);
%     subplot(2,1,i);
%     plot(res.v_mod(:,i),':'); hold on;
%     plot(res.v(:,i));
%     
%     figure(2);
%     subplot(2,1,i);
%     hist([res.v_mod(:,i) res.v(:,i)],21)
% end