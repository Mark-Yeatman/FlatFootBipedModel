function [output] = gainsearchgrid(xi,ratiomap)
%GAINSEARCH Find space of stable gains using bisection method
%   Detailed explanation goes here
    global gainratios kd
    steps = 17; %prime so that only period 1 or period n cycles should register as stable
    kdspace = [1,1.3,1.6000,2,2.6,3.2,4.2667,5.3333,6.4,12.8,25.6,37.6000,51.2];
    output = cell(length(kdspace),1);
    
    for i=1:length(kdspace) %grid kd
        kd = kdspace(i);
        
        exps = {length(ratiomap)};
        
        for j=1:length(ratiomap)
                gainratios = diag(ratiomap(j,:));
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
                exps{j} = {ratiomap(j,:),maxeig,eigs,walked};
        end       
        kdstruct = struct;
        kdstruct.gain = kd;
        kdstruct.exps = exps;
        output{i} = kdstruct;
        
    end
    
end

