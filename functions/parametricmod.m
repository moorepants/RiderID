function [mod] = parametricmod(npm,dat,set)
% function [mod] = parametricmod(npm,dat,set)
% 
% Script for parametric fitting the impulse response data.
%
% Parameters
% ----------
% npm : structure with non parametric model data, see nonparametricmod.m
% dat : structure with measurement data, see davisdat.m and prefilter.m
% set : structure with measurement settings, see settings.m
%
% Returns
% -------
% mod : Structure
%   Structure containing parametric model data:
%   G  : Structure
%        Contains the bicycle transfer function objects
%   X  : double, 8 x 1
%        Model parameters; k_phi, k_phidd, k_delta, etc.
%   X0 : double, 8 x 1
%        Initial model parameters
%   sem : double, 8 x 1
%        Standard Error of the Mean 
%   covP : double, 8 x 8
%        Parameter Covariance Matrix
%   covPn : double, 8 x 8
%        Normalized Covariance Matrix
%   sel : logic, 8 x 1
%        Selected (active) parameters X
%   vaf : double, 1 x 1
%        Variance Acounted For, percentage
%   y : double, n x 2
%       Parametric model roll and steering output, time series
%   C : transfer function, 1 x 2
%       Rider controller without time delay and neuromuscular delay
%   K : transfer function, 1 x 2
%       Rider controller with time delay and neuromuscular delay
%   ...
%   ... and some less interesting stuff ...
%

    % Load initial parameters
    % Preallocating some field names (prevents trouble)
    mod = struct('G',[],'K',[],'X',[],'X0',[],'z',[],'y',[],'C',[]);
    mod = parameters(dat.filename,mod);

    % For each model structure
    for j = 1:length(mod);
        
    % Initial parameters based on optimal control theory:
    bike = davisbike(set.v); % Bicycle model from Davis
    % K = optimal(bike); keyboard;

%     % Randomized Initial Parameter search -> Brute force approach
%     mod(j).G.yu =  bike(3:4,2);
%     mod(j).G.yw =  bike(3:4,3);
%     mod(j).G.zu = -bike(3,2);
%     mod(j).G.zw = -bike(3,3);
%     for k = 1:500
%        X0{k} = mod(j).X0.*(1+0.5.*(randn(size(mod(j).X0))-0.5));
%        X0n = ones(size(X0{k}));
%         theta0n = X0n(logical(X0{k}));  %#ok<*AGROW>
%                 en  = norm(errorfunc(theta0n,X0{k},1,npm,j,mod(j),dat));
%         V(k) = en'*en;
%      end
%      [Vmin,index] = min(V);
%      disp(Vmin);
%      disp(X0{index});
%      keyboard;

       if sum(mod(j).X0);
            
            % Bike
            mod(j).G.yu =  bike(3:4,2);
            mod(j).G.yw =  bike(3:4,3);
            mod(j).G.zu = -bike(3,2);
            mod(j).G.zw = -bike(3,3);
            
            % Normalizing variables using initial parameter conditions.
            X0 = mod(j).X0;
            X0n = ones(size(X0));
            theta0 = X0(logical(X0));  %#ok<*AGROW>
            theta0n = X0n(logical(X0));  %#ok<*AGROW>
            e0  = norm(errorfunc(theta0n,X0,1,npm,j,mod(j),dat));
            % Optimize model using the LSQNONLIN algorithm if flag is set to 1        
            [thetan,resnorm,en,exitflag,output,~,Jn] = ...
                lsqnonlin(@(thetan)errorfunc(thetan,X0,e0,npm,j,mod(j),dat),...
                  theta0n);
            
            % Unnormalizing output
            e = en.*e0;
            N = length(e);
            J = Jn./repmat(theta0,size(Jn,1),1).*e0;
            Xn = zeros(size(X0)); Xn(logical(X0)) = thetan;
            X = Xn.*X0;
            theta = thetan.*theta0;
            
            % Optimization output
            mod(j).covP = abs(1/N*(e'*e)*inv(J'*J)); %#ok<MINV>
            mod(j).covPn = full(mod(j).covP)./(theta'*theta);
            mod(j).sem = full(sqrt(diag(inv(J'*J))*sum(e.^2)/N));
            mod(j).resnorm = resnorm;
            mod(j).exitflag = exitflag;
            mod(j).output = output;
            mod(j).sel = logical(X0);

            
            % Model output
            mod(j).i = j;
            mod(j) = riderfunc(X,tf('s'),j,mod(j));

            delta_mod = lsim(mod(j).y(2),dat.w,dat.t);
            delta = npm.y(:,2);

            mod(j).vaf = vaf(delta,delta_mod);
                        
        end
    end        
end


% Optimal controller
function K = optimal(bike) %#ok<DEFNU>
    % Set performance weightning Q and control effort R
    q1max = 0.1; Q33 = 1/q1max^2;
    T2max = 2.0; R11 = 1/T2max^2;  
    % Weighting matrices
%     Q = zeros(6); Q(3,3) = Q33; Q(5,5) = Q33;
    Q = 1*eye(4); Q(3,3) = Q33;
    R = zeros(1); R(1,1) = R11;
    % Controller
    [K,~,e] = lqr(bike(:,2),Q,R); disp(e);
end

% Error definition
function en = errorfunc(thetan,X0,e0,npm,j,mod,dat)
    Xn = zeros(size(X0)); Xn(logical(X0)) = thetan;
    X = Xn.*X0; % Renormalizing
    mod = riderfunc(X,tf('s'),j,mod); % X,s,i,mod
    delta_mod = lsim(mod.y(2),dat.w,dat.t);
    delta = npm.y(:,2);
    e = 1/npm.N*(delta - delta_mod);
    en = e/e0;
    disp(sum(en.^2));
end
