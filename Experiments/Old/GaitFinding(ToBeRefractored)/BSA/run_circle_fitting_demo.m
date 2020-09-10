close all
% pseudo-data generation for circle-fitting
t=linspace(-pi,pi,10000);
x=sin(t);
y=cos(t);
noisex=.1*randn(1,10000);
noisey=.1*randn(1,10000);
x=x+noisex;
y=y+noisey;
data.x=x;
data.y=y;
% argmin  sum(abs((x-a).^2+(y-b).^2-r.^2)), where parameters are {a,b,r}
dim=3; % {a,b,r}
% set search space limits
low=[-10*ones(1,2) 0]; % r>0
up=10*ones(1,3);
maxcycle=1000; % increase maxcycle if required
bsa('fitcircle',data,30,dim,1,low,up,maxcycle)
% use ctrl+c for stopping BSA and solution-export to workspace of matlab
plot(x,y,'.r');
hold on
plot(globalminimizer(1),globalminimizer(2),'+k','markersize',50)
plotcircle(globalminimizer(1),globalminimizer(2),globalminimizer(3),'-k')
daspect([1 1 1]);shg