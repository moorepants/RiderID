function fig = datfig(dat,i,T)
% function fig = datfig(dat,i,T)
%
% Returns a raw data plot.
%
% Parameters
% ----------
% dat :
% i :
% T :

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
    
    figure(i);
    clf;
    subplot(3,1,1);
    title(['Perturbation run at v=' num2str(dat.v,2) ' m/s']); hold on; box on;
        plot([dat.t(1);dat.t(end)],[0;0],'k:');
        h = plot(dat.t,dat.y(:,1),'k'); hold on;
        % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        ylabel('angle (rad)'); xlim(T);
        legend(h,'\phi(t)');
    subplot(3,1,2);
        plot([dat.t(1);dat.t(end)],[0;0],'k:');hold on;
        h = plot(dat.t,dat.y(:,2),'k'); 
          % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        ylabel('angle (rad)'); xlim(T); 
        legend(h,'\delta(t)');
    subplot(3,1,3);
        plot([dat.t(1);dat.t(end)],[0;0],'k:'); hold on;
        h = plot(dat.t,dat.w(:,1),'k');
          % Pulse grid
        ylimit = ylim;
        for k = 1:length(tpulse);
            plot(repmat(dat.t(tpulse(k)),1,2),ylimit',':k');
        end
        ylabel('force (N)'); xlim(T);
        legend(h,'w(t)');
    xlabel('t (s)');
    sdf('Latex');
    fig.hf = gcf;
    
end
