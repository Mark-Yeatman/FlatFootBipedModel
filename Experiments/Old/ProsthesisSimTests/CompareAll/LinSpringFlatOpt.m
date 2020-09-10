global prob
for b = 1:3
    switch b
            case{1}
            prob = 'knee';
            %Just knee                
            human_torques = knee_filt;             
        case{2}
            %Just Ankle
            prob = 'ankle';
            human_torques = ankle_filt;    
        case{3}
            %Both
            prob = 'both';
            human_torques = [ankle_filt,...
                             knee_filt];
    end
    guess = [k_0 * Gaitcycle.(s).subjectdetails{4,2} / m_0;
             Spring_Length_Heel_func(xstart')
             lf];
         
    options = optimoptions('fmincon','Algorithm','sqp');
    problem.options = options;
    problem.solver = 'fmincon';
    problem.x0 = guess;
    problem.objective = @LinSpringFlatCost;
    problem.lb = [0,0,0];
    problem.ub = [1e6,1.5*guess(2),1.25*lf];
         
    %find the optimal lengths and stiffnesses     
    opt_parameters = fmincon(problem);
    OptData.LinSpringFlat.(s).(prob).params.k1 = opt_parameters(1);
    OptData.LinSpringFlat.(s).(prob).params.L0 = opt_parameters(2);
    OptData.LinSpringFlat.(s).(prob).params.lf = opt_parameters(3);

    %Compute 'optimal' torque output
    u = zeros(length(human_trajectories),2);
    for i = 1:length(ti)  
        %hmid point spring
        flowdata.Parameters.SLIP.L0 = OptData.LinSpringFlat.(s).(prob).params.L0;
        flowdata.Parameters.SLIP.k = OptData.LinSpringFlat.(s).(prob).params.k1;
        lf_opt = OptData.LinSpringFlat.(s).(prob).params.lf; 
        flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf_opt, R, phi];
        ui = LinSpring_Flat(human_trajectories(i,:)' );
        u(i,:) = ui(4:5)';
    end
    OptData.LinSpringFlat.(s).(prob).u = u;
    OptData.LinSpringFlat.(s).(prob).R2 = rsquared(human_torques, u);
    %% Visualization
    axes(AxisArray{j,1})
    hold on
    plot(ti,u(:,1),'DisplayName',strcat('SF_{',prob,'}'));

%     info_str = {strcat('k1: ' , num2str(k1)), ...
%                 strcat('k2: ' , num2str(k2)), ...
%                 strcat('L1: ' , num2str(L0_1)), ...
%                 strcat('L2: ' , num2str(L0_2))};

    %a = annotation('textbox', [0.05, 0.45, 0.1, 0.1], 'String', info_str);

    axes(AxisArray{j,2})
    hold on
    plot(ti,u(:,2),'DisplayName',strcat('SF_{',prob,'}'));
    
end