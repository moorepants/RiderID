function fig = resfig(npm,dat,set,i,T)


    if isnan(T);
        T = [dat.t(1) dat.t(end)];
        disp('No specific time specified');
    end

    tpulse = [];
    k = 1;
    while k <= length(dat.t);
        if abs(dat.w(k))>20
            tpulse(end+1) = k;
            k = k+500;
            disp(k)
        end
        k = k+1;
    end
    
    figure(i); clf; 
    subplot(4,1,1);
    title(['Output decomposition: y(t) = G(q)w(t) + v(t) for v=' num2str(set.v,2) 'm/s']);
        box on; ylabel('angle (rad)');  hold on;
        h = plot(dat.t,dat.y(:,2),'k');  % Total
         % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        legend(h,'y_\delta(t)');
        xlim(T); yl = ylim;
    subplot(4,1,2);
        box on; ylabel('angle (rad)');  hold on;
        h = plot(npm.t,npm.y(:,2),'k');  % Total
         % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        legend(h,'G_\delta(q)w(t)');
        xlim(T); ylim(yl);
    subplot(4,1,3);
        box on; ylabel('angle (rad)');  hold on;
        h = plot(npm.t,npm.v(:,2),'k');  % Total
         % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        legend(h,'v_\delta(t)');
        xlim(T); ylim(yl);
    subplot(4,1,4);
        h = plot(dat.t,dat.w(:,1),'k'); hold on;
         % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        ylabel('force (N)'); xlim(T);
        legend(h,'w(t)');
    xlabel('time (s)');
    sdf('Latex');
    
    
    
    fig.hf = gcf;