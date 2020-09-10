function [mapeigs] = eigenmap(xs,period,act_period,vector)
% EIGENMAP2   Find the eigenvalues of the system's Poincare return map
%
% Runs a numerical analysis on the initial conditions for a fixed point.
% The limit cycle code calls step2.m, which calls the function eqns3.dll.
%
% Last modified on 01/23/10 by Robert D. Gregg - rgregg@uiuc.edu
%

global flowdata
dim = flowdata.Parameters.dim;
    if nargin == 1
        period = 1;
        act_period = 1;
    elseif nargin == 2
        act_period = period;
    end

    if act_period > 2
        delta = 1E-4;
        deltadot = 1E-3;
    else
        delta = 1E-4;
        deltadot = 1E-3;
    end

    Omega = zeros(dim,length(vector(vector==1)));
    Y = zeros(dim,length(vector(vector==1)));

    if nargin < 2
        period = 1;
    end

    if nargin == 0
        fprintf('Error: must input initial state!\n')
    end

    j=1;
    for i=1:dim
        if vector(i) == 1
            if(i<=dim/2)
                x = xs; x(i) = x(i) - delta;
                Y(i,j) = delta;
            else
                x = xs; x(i) = x(i) - deltadot;
                Y(i,j) = deltadot;
            end
            flowdata.State.PE_datum = x(2);
            temp = 0;
            if isfield(flowdata.Parameters,'Eref_Update')
                flowdata.State.Eref = flowdata.Parameters.KPBC.Eref.(flowdata.State.c_phase);
                temp = flowdata.Parameters.Eref_Update.k;
                flowdata.Parameters.Eref_Update.k = 0;
            end
            v = walk(x,period); %FUNCTION CALL IS HERE
            if isfield(flowdata.Parameters,'Eref_Update')
                flowdata.Parameters.Eref_Update.k = temp;
            end
            Omega(:,j) = v'-xs';
            j=j+1;
        end
    end
    A = Omega/Y;
    mapeigs = eig(A);
    %fprintf('max(abs(eigenvalues))=%f\n',max(abs(mapeigs)));
end