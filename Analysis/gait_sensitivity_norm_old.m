function [gaitnorm,A,B,C,D] = gait_sensitivity_norm_old(x0,g0,period)
%
% Runs a numerical analysis on the initial conditions for a fixed point.
% See: A Disturbance Rejection Measure for Limit Cycle Walkers: The Gait Sensitivity Norm, Daan G. E. Hobbelen and Martijn Wisse
%   for detailed explanation of algorithm
% Last modified on 04/10/2020 by Mark Yeatman

% Note: There's some hardcoded values in here specific to the flat foot
% walker problem. Hopefully I'll come back and generalize this. 

% According to the paper, the way to use this value is to compare
% 1/gaitnorm. A high value indicates more robust. 
global flowdata
    
    %Run (5) steps to find "the real" fixed point. If you're varying parameters and using
    %the same x0 all the time, this is probably necessary. 
   
    if nargin == 1 
        [x0,~,~,out_extra] = walk(x0,5); 
        g0 = [out_extra.steps{end}.steplength; out_extra.steps{end}.steplength / out_extra.steps{end}.speed;]';
        period = 1;
    end

    if nargin == 0
        fprintf('Error: must input initial state!\n')
    end
    
    perturb_v = 1E-4;
    perturb_v_dot = 1E-3;

    %dv = zeros(length(x0),1);
    %delta_x = zeros(length(x0),length(x0));
    elen = 2;
    A = zeros(length(x0),length(x0)); %length(x0) x length(x0)
    B = zeros(length(x0),elen); %length(x0) x size(e);
    C = zeros(length(g0),length(x0)); % size(g) x length(x0);
    D = zeros(length(g0),elen);  % size(g) x size(e);
    gnorm = [0.1,0.1];
    
    %state space perturbation
    for i=1:length(x0)
        x = x0; 
        if(i<=length(x0)/2)
            x(i) = x(i) - perturb_v;
            delta_x = perturb_v;
        else 
            x(i) = x(i) - perturb_v_dot;
            delta_x = perturb_v_dot;
        end
        [x_p,~,~,out_extra] = walk(x,period); %simulation function call!
        g_p = [out_extra.steps{end}.steplength;out_extra.steps{end}.steplength / out_extra.steps{end}.speed;]';%step length, step time, minimum ground clearance heel over the stride

        dv = x_p'-x0';
        dg = g_p'-g0';
        A(:,i) = dv/delta_x;
        C(:,i) = dg/delta_x;
    end

    
    %disturbance e 
    slope = flowdata.Parameters.Environment.slope;
    e = 0;
    slopedelta = 1;
    perturb = zeros(size(x0));
    for i = 1:elen
        x = x0; 
        if i == 1 %slope variation +1 rad
            slope = slope+deg2rad(slopedelta);
            flowdata.Parameters.Environment.slope = slope;
            e = slopedelta;           
        elseif i == 2 %slope variation -1 rad
            slope = slope-deg2rad(2*slopedelta);
            flowdata.Parameters.Environment.slope = slope;
            e = -slopedelta;
        end
        [x_p,~,~,out_extra] = walk(x+perturb,period); %simulation function call!
        g_p = [out_extra.steps{end}.steplength;out_extra.steps{end}.steplength / out_extra.steps{end}.speed;]'; %step length, step time, ground clearance heel at x(6) = -0.1
        dv = x_p'-x0';
        dg = (g_p'-g0')./gnorm';
        B(:,i) = dv/e;
        D(:,i) = dg/e;
    end
    flowdata.Parameters.Environment.slope = slope+deg2rad(slopedelta);
    %25 iterations is somewhat arbitrary, the formula calls for the sum
    %from i=1 : inf, but you're got to stop somewhere. Ideally termination criteria should be
    %based on the eigenvalues of A. But I'm lazy.
    part = 0;
    for i=1:25
        part = part + trace( B' * A'^i * (C' * C) * A^i * B);
    end
    gaitnorm = trace(D'*D) + part;

end