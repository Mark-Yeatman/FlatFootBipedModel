function [output] = gainsearchgrid(xi)
%GAINSEARCH Find space of stable gains using bisection method
%   Detailed explanation goes here
    global gainratios kd
    steps = 19; %prime so that only period 1 or period n cycles should register as stable
    
    kd = 1.5;
    gainratios = diag([0,0,0,1,1,1,1,1]);
    ratiospace = [0,0.1,0.25,0.5,0.75,0.9,1];
    kdspace = linspace(0,1.5,10);
    output = cell(length(kdspace),1);
    
    for i=length(kdspace):-1:1 %grid kd
        kdstruct = struct;
        kd = kdspace(i);
        kdstruct.gain = kd;
        kdstruct.exps = {5,length(ratiospace)};
        ratios = [0,0,0,1,1,1,1,1];
        for j=8:-1:3% grid joints
            for k=length(ratiospace):-1:1 %grid gains
                ratios(j) = ratiospace(k);
                gainratios = diag(ratios);
                try
                    fState = walk2(xi,steps); 
                catch
                    fState = [];
                end
                walked = ~isempty(fState);
                if walked
                    try
                        eigs = eigenmap2(fState);
                        maxeig = max(abs(eigs));
                    catch
                        maxeig = inf;
                        eigs = [];
                    end
                else
                    maxeig = inf;
                    eigs = [];
                end
                kdstruct.exps{j,k} = {ratios,maxeig,eigs,walked};
            end
        end
        output{i} = kdstruct;
    end
    
end

