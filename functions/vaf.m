function v = vaf(y,y_est)
 
v = 100*(1-cov(y-y_est)./cov(y));

