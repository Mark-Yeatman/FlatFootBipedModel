initialize;
addpath('AnalysisFunctions')
gainratios = diag([0,0,0,1,1,0.001,1,1]);
silent = true;
y = 0:50;
gains = y;
for i = 0:50
   kd = i/50*10;
   mapeigs = eigenmap2(xi);
   [~,key] = sort(abs(mapeigs));
   y(i+1) = mapeigs(key(end));
   gains(i+1) = kd;
end
plot(gains,abs(y))
xlabel('k (Gain)');
ylabel('max $\mid \Lambda \mid$');
setfigprops;
l1.LineWidth = 4;