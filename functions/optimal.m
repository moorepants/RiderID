function opt = optimal(bike)

    % Optimal controller
    % Set performance weightning Q and control effort R
    q1max = 0.1; Q33 = 1/q1max^2;
    T2max = 2.0; R11 = 1/T2max^2;  
    % Weighting matrices
%     Q = zeros(6); Q(3,3) = Q33; Q(5,5) = Q33;
    Q = zeros(4); Q(3,3) = Q33;
    R = zeros(1); R(1,1) = R11;
    % Controller
    [K,~,e] = lqr(bike(:,2),Q,R); disp(e);

    s = tf('s');
    opt.K = -K*[s*eye(2); eye(2)];
    
    opt.G.yu =  bike(3:4,2);
    opt.G.yw =  bike(3:4,3);
    opt.G.zu = -bike(3,2);
    opt.G.zw = -bike(3,3);

    opt.y =  minreal(opt.G.yw + opt.G.yu*((eye(1)-opt.K*opt.G.yu)\opt.K*opt.G.yw));
    opt.z = -opt.y(1);
    
    
    
    