function fig = modfig(npm,dat,mod,set,i,j,T)

    if isnan(T);
        T = [dat.t(1) dat.t(end)];
        disp('No specific time specified');
    end

    mod = mod{1};

%     M = length(mod);
%     delta_mod = zeros(dat.N,M);
%     for j = 1:5
        delta_mod = lsim(mod(j).y(1),dat.w,dat.t);
%     end

    models = (['G' num2str(j) '_\delta(q,\theta)w(t)']);
    
    figure(i); clf;
    title(['Parametric model fitting results for v=' num2str(set.v,2) 'm/s']);
    box on; ylabel('angle (rad)');  hold on;
    h1 = plot(npm.t,npm.y(:,1),'k'); 
    h2 = plot(dat.t,delta_mod,'k--');
    h = [h1;h2];
    legend(h,'G_\delta(q)w(t)',models,1);
    xlim(T);
    xlabel('time (s)');
    sdf('Latex');
    
    fig.hf = gcf;
end