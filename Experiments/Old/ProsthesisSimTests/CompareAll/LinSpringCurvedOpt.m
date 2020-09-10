global prob
for b = 1:3
    %Optimize for just knee   
    switch b
        case{1}
            prob = 'knee';
            %Just knee           
            human_torques = [Gaitcycle.(s).(trial).kinetics.jointmoment.right.knee.x_mean(1:cut_i)*scale];             
        case{2}
            %Just Ankle
            prob = 'ankle';
            human_torques = [Gaitcycle.(s).(trial).kinetics.jointmoment.right.ankle.x_mean(1:cut_i)*scale];    
        case{3}
            %Both
            prob = 'both';
            human_torques = [Gaitcycle.(s).(trial).kinetics.jointmoment.right.ankle.x_mean(1:cut_i)*scale,...
                              Gaitcycle.(s).(trial).kinetics.jointmoment.right.knee.x_mean(1:cut_i)*scale];
    end
    guess = [k_0 * Gaitcycle.(s).subjectdetails{4,2} / m_0;
             Spring_Length_Curved_func(xstart');
             0.3*(ls+lt);
             0];

    options = optimoptions('fmincon','Algorithm','sqp');
    problem.options = options;
    problem.solver = 'fmincon';
    problem.x0 = guess;
    problem.objective = @LinSpringCurvedCost;
    problem.lb = [0,0,0.1,-pi/4];
    problem.ub = [1e6,1.5*guess(2),0.5, pi/4];
         
    %find the optimal lengths and stiffnesses     
    opt_parameters = fmincon(problem);
    OptData.LinSpringCurved.(s).(prob).params.k1 = opt_parameters(1);
    OptData.LinSpringCurved.(s).(prob).params.L0 = opt_parameters(2);
    OptData.LinSpringCurved.(s).(prob).params.R = opt_parameters(3);
    OptData.LinSpringCurved.(s).(prob).params.phi = opt_parameters(4);

    %Compute 'optimal' torque output
    u = zeros(length(human_trajectories),2);
    for i = 1:length(ti)  
        %hmid point spring
        flowdata.Parameters.SLIP.L0 = OptData.LinSpringCurved.(s).(prob).params.L0;
        flowdata.Parameters.SLIP.k = OptData.LinSpringCurved.(s).(prob).params.k1;
        flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf, opt_parameters(3), opt_parameters(4)];
        ui = LinSpring_Curved(human_trajectories(i,:)' );
        u(i,:) = ui(4:5)';
    end
    OptData.LinSpringCurved.(s).(prob).u = u;
    OptData.LinSpringCurved.(s).(prob).R2 = rsquared(human_torques, u);
    %% Visualization
    axes(AxisArray{j,1})
    hold on
    plot(ti,u(:,1),'DisplayName',strcat('SC_{',prob,'}'));

%     info_str = {strcat('k1: ' , num2str(k1)), ...
%                 strcat('k2: ' , num2str(k2)), ...
%                 strcat('L1: ' , num2str(L0_1)), ...
%                 strcat('L2: ' , num2str(L0_2))};

    %a = annotation('textbox', [0.05, 0.45, 0.1, 0.1], 'String', info_str);

    axes(AxisArray{j,2})
    hold on
    plot(ti,u(:,2),'DisplayName',strcat('SC_{',prob,'}'));
    
end