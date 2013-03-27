function fig = firfig_gain(npm,mod,dat,i,j)

    %% Definitions
    mod = mod{1};
    g = npm.g(1:npm.m-2^8,:);
    g_raw = npm.g_raw(1:npm.m-2^8,:);
  
    %% Steertorque calculations
   s = tf('s');
   omegac = 2*pi*2.17; 
   Gnm = omegac^2/(s^2 + 2*sqrt(1/2)*omegac*s + omegac^2);
   pid = [1;1/s;s;s^2];
   
   sel = logical(mod(j).X)
   k =  diag(mod(j).X(1:8))*[pid zeros(4,1); zeros(4,1) pid]*Gnm;
    
    
   tau = npm.t(1:12:npm.m-2^8); 
   
   [g_mod,~] = impulse(mod(j).y,tau);
   [T_mod,~] = lsim(mod(j).K,g_mod,tau);
   [gains,~] = lsim(k,g_mod,tau);

  
   k_mod = gains(:,sel);
   
   leg = {'Tk_{\phi p}','Tk_{\phi i}','Tk_{\phi d}','Tk_{\phi dd}',...
      'Tk_{\delta p}','Tk_{\delta i}','Tk_{\delta d}','Tk_{\delta dd}'};
   styles = '+o*.xsd^';


    %% Figure
    ya = {0.007,0.03};
    figure(i); clf;
    subplot(4,1,1);
    title(['Finite Impulse Response for v=' num2str(dat.v,2) ' m/s']); hold on; box on;
        h = plot(tau,g_mod(:,1),'k');
        xlim([tau(1),tau(end)]); ylim(ya{1}*([-1 1]+1/3));
        legend(h,'\phi');
        ylabel('angle (rad)');
    subplot(4,1,2);
        h = plot(tau,g_mod(:,2),'k');
        xlim([tau(1),tau(end)]); ylim(ya{2}*([-1 1]+1/3)); 
        legend(h,'\delta');
        ylabel('angle (rad)');
   subplot(4,1,3:4);    
        h = plot(tau,k_mod,'-','Color',0.6*ones(3,1));hold on;
        for k=1:length(h); set(h(k),'Marker',styles(k)); end;
         h0 = plot(tau,T_mod,'k'); 
        legend([h0;h],[{'T_{\delta,u}'},leg(sel)]);
        ylabel('torque (Nm)');
        xlim([tau(1),tau(end)]); ylim(0.5*([-1 1])); 
    xlabel('\tau (s)');
    sdf('Latex');
    
    fig.hf = gcf;