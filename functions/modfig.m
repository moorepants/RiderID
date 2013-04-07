function fig = modfig(npm,dat,mod,set,i,j,T)
% function fig = modfig(npm,dat,mod,set,i,j,T)
%
% Returns a figure with both nonparametric and parameteric
% time results.
%
% Parameters
% ----------
% npm ; structure with nonparametric data
% dat ; structure with time domain data
% mod ; structure with parametric model data
% set ; structure with measurement settings
% i ; integer 1 x 1, measurement number
% j ; integer 1 x 1, parametric model number
% T ; double 2 x 1, time span [T_start, T_end]
%
% Returns
% -------
% fig ; handle to figure object
%



    if isnan(T);
        T = [dat.t(1) dat.t(end)];
        disp('No specific time specified');
    end

    mod = mod{1};
    delta_mod = lsim(mod(j).y(1),dat.w,dat.t);

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
