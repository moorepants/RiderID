function [sym] = symsens(mod)
% function [mod] = sensitivity(mod)
%
% input:  mod
% output: mod
%
    % Read out model
    X.num = mod.X(mod.X~=0); % X;
    sym.G.yu = lti2sym(mod.G.yu);
    sym.G.yw = lti2sym(mod.G.yw);
    sym.G.zu = lti2sym(mod.G.zu);
    sym.G.zw = lti2sym(mod.G.zw);
    
    % Symbolic definitions
    syms s;
    syms X1 X2 X3 X4 X5 X6 X7 X8 real;
    sym.X = [X1 X2 X3 X4 X5 X6 X7 X8]; %#ok<*NODEF>
    %X.sym = X.sym(1:length(X.num));

    sym = riderfunc(sym.X,s,mod.i,sym);   

    % Symbolic Sensitivity Expressions
    dKdX = (jacobian(sym.K,sym.X));
    dydX = (jacobian(sym.y,sym.X));
    dKdXn = dKdX.*repmat(sym.X,size(sym.y,1),1);
    dydXn = dydX.*repmat(sym.X,size(sym.y,1),1);
    
    for j = 1:2
        d2KdX2(:,:,j) = jacobian(dKdX(j,:),sym.X); %#ok<AGROW>
        d2ydX2(:,:,j) = jacobian(dydX(j,:),sym.X); %#ok<AGROW>
        d2KdXn2(:,:,j) = d2KdX2(:,:,j).*(sym.X'*sym.X); %#ok<AGROW>
        d2ydXn2(:,:,j) = d2ydX2(:,:,j).*(sym.X'*sym.X); %#ok<AGROW>
    end
    
    sym.dydXn = dydXn;
    sym.dKdXn = dKdXn;
    sym.d2ydXn2 = d2ydXn2;
    sym.d2KdXn2 = d2KdXn2;
    
    
%      % Substitution of parameter values;
%     X1 = mod.X(1); X2 = mod.X(2); X3 = mod.X(3);
%     X4 = mod.X(4); X5 = mod.X(5); X6 = mod.X(6);
%     X7 = mod.X(7); %#ok<*NASGU>
%     
%     dKdXn = subs(sym.dKdXn);
%     dydXn = subs(sym.dydXn);
%     d2KdXn2 = subs(sym.dK2dXn2);
%     d2ydXn2 = subs(sym.dy2dXn2);
    
    if exist('symresults.m', 'file')
        delete symresults.m
    end
    diary symresults.m
        disp('dydXn_tmp = ['), disp(dydXn), disp('];');
        disp('dKdXn_tmp = ['), disp(dKdXn), disp('];');
    diary off
    
%     
%     T1 = sym2str(dKdX);
%     T2 = sym2str(dydX);
% 
%     % Frequency response function
%     Fs = 200;
%     N = 2^11;
% 
%   
% 
%     
%     n = 2^7;
%     f = logspace(-2,2,n);
% 
% 
%     % Substitution of parameter values;
%     X1 = mod.X(1); X2 = mod.X(2); X3 = mod.X(3);
%     X4 = mod.X(4); X5 = mod.X(5); X6 = mod.X(6);
%     X7 = mod.X(7); %#ok<*NASGU>
% 
%     % Preallocating memory space for sensitivity frequency response
%     frf.dKdX = zeros([size(dKdX),n]);
%     frf.dydX = zeros([size(dydX),n]);
% 
%     for i = 1:n
%         disp([num2str(i) '/' num2str(n)])
%         s = 1i*2*pi*f(i);
%         frf.dKdX(:,:,i) = eval(T1);
%         frf.dydX(:,:,i) = eval(T2);
%     end
% 
%    % Normalized sensitivities
%     frf.dKdXn = frf.dKdX.*repmat(mod.X,[size(frf.dKdX,1),1,n]);
%     frf.dydXn = frf.dydX.*repmat(mod.X,[size(frf.dydX,1),1,n]);
% 
%     
%         
%    frf.f = f;
%    frf.n = n;

end
