function fig = covfig(mod,sat,i,k)
% function fig = covfig(mod,sat,i,k)
%
% Returns a covariance figure.
%
% Parameters
% ----------
% mod :
% sat :
% i :
% k :
%
% Returns
% -------
% fig : figure handle

    figure(i); clf;
    hold on;

    mod = mod{1};


    p = sum(mod(k).sel);
    m = length(mod(k).X0);

    hold on; box on;


    s = .8;
    for x=1:m
        for y = 1:m
            xx = [x-s/2 x-s/2 x+s/2 x+s/2 x-s/2];
            yy = [y-s/2 y+s/2 y+s/2 y-s/2 y-s/2];
            plot(xx,yy,':','Color',ones(3,1)*0.8);
        end
    end

    x = 1:length(mod(k).X0); x = x(mod(k).sel); y = x;
    for i = 1:p
        for j = 1:p
            xx = [x(i)-s/2 x(i)-s/2 x(i)+s/2 x(i)+s/2 x(i)-s/2];
            yy = [y(j)-s/2 y(j)+s/2 y(j)+s/2 y(j)-s/2 y(j)-s/2];
            patch(xx,yy,abs(mod(k).covPn(i,j)));
            plot(xx,yy,'k');
        end
    end
    axis ij; grid off; axis(1/2+[0-(1-s)/2 m+(1-s)/2 0-(1-s)/2 m+(1-s)/2]);
    h = colorbar ; colormap(flipud(bone));
    title(['Model G' num2str(k) ': cov \theta, v=' num2str(sat.v,2) 'm/s']);

    set(gca,'XTick',(1:length(mod(k).X))');
        set(gca,'YTick',(1:length(mod(k).X))');

    sdf('LatexSmall'); xlabel('i'); ylabel('j');

    fig.hf = gcf;

end
