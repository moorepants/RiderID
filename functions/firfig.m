function fig = firfig(npm,dat,i)
% function fig = firfig(npm,dat,i)
% 
% Returns a FIR figure 
% 
% Parameters
% ----------
% npm ; structure with nonparametric data
% dat ; structure with time domain data
% i   ; integer measurement number
%
% Returns
% -------
% fig ; handle to figure object
%

    g = npm.g(1:npm.m-2^8,:);
    g_raw = npm.g_raw(1:npm.m-2^8,:);
    
    
    tau = npm.t(1:npm.m-2^8)-npm.t(1);
    npm.ylim = 5/3*max(abs(npm.g))'*([-1 1]+1/5);
    
    ya = {0.007,0.03};

    figure(i); clf;
    subplot(2,1,1);
    title(['Finite Impulse Response for v=' num2str(dat.v,2) ' m/s']); hold on; box off;
        plot(tau,zeros(size(tau)),':','Color',0.8*ones(1,3)); hold on; box off;
        h(1) = plot(tau,g_raw(:,1),'Color',0.8*ones(1,3));
        h(2) = plot(tau,g(:,1),'Color',0.4*ones(1,3));
        legend(h,'g_\phi(\tau) raw','g_\phi(\tau) filtered');
        xlim([tau(1),tau(end)]); ylim(ya{1}*([-1 1]+1/3)); 
        ylabel('angle (rad)');
    subplot(2,1,2);
        plot(tau,zeros(size(tau)),':','Color',0.8*ones(1,3)); hold on; box off;
        h(1) = plot(tau,g_raw(:,2),'Color',0.8*ones(1,3));
        h(2) = plot(tau,g(:,2),'Color',0.4*ones(1,3));
        
        legend(h,'g_\delta(\tau) raw','g_\delta(\tau) filtered');
        xlim([tau(1),tau(end)]); ylim(ya{2}*([-1 1]+1/3)); 
        ylabel('angle (rad)');
    xlabel('\tau (s)');
    sdf('Latex');
    
    fig.hf = gcf;
