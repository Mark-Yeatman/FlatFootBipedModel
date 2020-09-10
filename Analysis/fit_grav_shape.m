KPBC_SLIP_run2
z1out = out_extra.L1thetaCords;

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData(tout,z1out(:,1));

% Set up fittype and options.
ft = fittype( 'a*cos(b*x+p)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.446814008581436 0.98270516998706 0.697389870709253 0.957506835434298];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on
fitresult

m = flowdata.Parameters.Biped('m');
L0 = flowdata.Parameters.SLIP.L0;
A = fitresult.a;
phi = fitresult.p;
kfit = fitresult.b^2*m;
gfit = -(fitresult.c-L0)*kfit/m;
Efit = (A^2 + 2*(L0-m*gfit/kfit)^2)*kfit/2;