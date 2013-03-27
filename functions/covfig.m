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

%     set(gca,'XTickLabel',Xlegend)

    sdf('LatexSmall'); xlabel('i'); ylabel('j');

%            pos = get(h,'Position'); pos(3) = pos(3)/10;
%         set(h,'Position',pos);
    fig.hf = gcf;

end


% function NMDmacdiagram(X1,X2,M,neig,ylab)
% % function FEM_MACdiagram(X1,X2,M,neig);
% % 
% % MAC diagram 
% %
% % Inputs:
% %  X1   : set of eigenvectors
% %  X2   : set of eigenvectors
% %  M    : Mass matrix
% %  neig : number of eigenmodes
% 
% 
% if neig < 20
%     p = neig;
% elseif neig >= 20;
%     p = 20;
% end
%     
% Mac = X2(:,1:p)'*M*X1(:,1:p);
% 
% cla; hold on; box on;
% 
% for i = 1:p
%     for j = 1:p
%         A = abs(Mac(i,j));
%         s = (A);
%         xx = [i-s/2 i-s/2 i+s/2 i+s/2 i-s/2];
%         yy = [j-s/2 j+s/2 j+s/2 j-s/2 j-s/2];
%         patch(xx,yy,A);
%         plot(xx,yy,'k');
%     end
% end
% 
% axis equal; axis([0 p+1 0 p+1]); axis ij; grid off;
% colorbar; caxis([0 1]); colormap(flipud(bone));
% title('MAC diagram'); xlabel('Reference values'); ylabel(ylab);
% sdf('Latex');
