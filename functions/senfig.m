function fig = senfig(mod,sim,tmp,i,j,npm,dat);

sen = mod{1}(j).sen;

sel = find(sim.Sww>1);
bw = sim.f(sel);

Xsel = (mod{1}(j).X0~=0)
sen.f_bw = bw(bw>0)';


Svv = interp1(npm.f,npm.Svv,sen.f);
      
styles = '+o*.xsd^';

dy1dXs = conj(squeeze(sen.dydXn(1,:,:))).*squeeze(sen.dydXn(1,:,:)); 
dy2dXs = conj(squeeze(sen.dydXn(2,:,:))).*squeeze(sen.dydXn(2,:,:)); 
  
%% Sensitivity plot
figure(8); clf;
h = loglog(sen.f,abs(squeeze(sen.dydXn(2,:,:)))','k'); hold on;
    title(['Normalized sensitivity |dG_\delta/d\theta|^2, v=' num2str(dat.v,2) ' m/s']);
    for k=1:length(h); set(h(k),'Marker',styles(k)); end;
    xlim([0.1,20]);ylim([1e-6 10e-2])
    legend(h,tmp.Xlegend{Xsel},3);
    ylabel('|dG_\delta/d\thetan|^2d  (rad/N)'); 
xlabel('frequency (Hz)');
sdf('Latex');


    fig.hf = gcf;