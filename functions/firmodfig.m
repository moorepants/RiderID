function fig = firmodfig(npm,mod,dat,i,j)

    
    mod = mod{1};
    

    g = npm.g(1:npm.m-2^8,:);
    g_raw = npm.g_raw(1:npm.m-2^8,:);
   
    
    
    tau = npm.t(1:npm.m-2^8);
    
    [g_mod,~] = impulse(mod(j).y,tau);
    
    npm.ylim = 5/3*max(abs(npm.g))'*([-1 1]+1/5);
    
    ya = {0.007,0.03};

    figure(i); clf;
    subplot(1,2,1);
        h(1) = plot(tau,g_raw(:,1),'Color',0.8*ones(1,3)); hold on;
        h(2) = plot(tau,g(:,1),'Color',0.4*ones(1,3));
        h(3) = plot(tau,g_mod(:,1),'--','Color',0.4*ones(1,3));
        legend(h,'g_\phi(\tau) raw','g_\phi(\tau) filtered','g_\phi(\tau) model');
        xlim([tau(1),tau(end)]); ylim(ya{1}*([-1 1]+1/3));
%         text(3.5,-ya{1}/2,['v=' num2str(dat.v,2) ' m/s'],'HorizontalAlignment','Right');
         xlabel('\tau (s)');
%         ylabel('angle (rad)');
    subplot(1,2,2);
        h(1) = plot(tau,g_raw(:,2),'Color',0.8*ones(1,3)); hold on;
        h(2) = plot(tau,g(:,2),'Color',0.4*ones(1,3));
        h(3) = plot(tau,g_mod(:,2),'--','Color',0.4*ones(1,3));
        legend(h,'g_\delta(\tau) raw','g_\delta(\tau) filtered','g_\delta(\tau) model');
        xlim([tau(1),tau(end)]); ylim(ya{2}*([-1 1]+1/3)); 
        text(3.5,-ya{2}/2,['v=' num2str(dat.v,2) ' m/s'],'HorizontalAlignment','Right');
        ylabel('angle (rad)');
    xlabel('\tau (s)');
    sdf('Latex');
    
    fig.hf = gcf;