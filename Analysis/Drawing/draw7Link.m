function [COM] = draw7Link(xi,flag, i, t, out_extra, step_num, phase_num)
    %DRAW4LINK Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    slope = flowdata.Parameters.Environment.slope;
    
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    nofig = ~strcmp(flag,'a'); 
    
    heelx = xi(1);
    heely = xi(2);
    heeltheta = xi(3);
    st_a = xi(4); 
    st_k = xi(5); 
    hip = xi(6);
    sw_k = xi(7);
    sw_a = xi(8);
    st_a = st_a + heeltheta;
    st_k = st_k + st_a;
    hip = hip + st_k;
    sw_k = sw_k + hip;
    sw_a = sw_a + sw_k;
    
    % Determine the hip and feet positions in 2D space
    heelJoint =  [heelx,heely];
    toeJoint = Toe_St_pos_func(xi);
    ankJoint = Ankle_St_pos_func(xi);
    kneeJoint = Knee_St_pos_func(xi);
    hipJoint = Hip_pos_func(xi);
    swkneeJoint = Knee_Sw_pos_func(xi);
    swankJoint = Ankle_Sw_pos_func(xi);
    swheelJoint = Heel_Sw_pos_func(xi);
    swtoeJoint =  Toe_Sw_pos_func(xi);
    
    %Set up lines to plot
    x_pros = [toeJoint(1,4) heelJoint(1) ankJoint(1,4) kneeJoint(1,4) hipJoint(1,4)];
    y_pros = [toeJoint(2,4) heelJoint(2) ankJoint(2,4) kneeJoint(2,4) hipJoint(2,4)];
    x_bod = [hipJoint(1,4) swkneeJoint(1,4) swankJoint(1,4) swheelJoint(1,4) swtoeJoint(1,4)];
    y_bod = [hipJoint(2,4) swkneeJoint(2,4) swankJoint(2,4) swheelJoint(2,4) swtoeJoint(2,4)];

    COM = COM_pos_func(xi);
    
    %pointArray{1} = [x_1;y_1];
    %pointArray{2} = [x_2;y_2];
    
    %Draw springs
%     if plotspring
%         [xs,ys]=spring(hip(1,4), hip(2,4), foot_st(1,4), foot_st(2,4), 3, 1, 0.01);
%         plot(xs,ys,'LineWidth',2,'Color','g')
%         if strcmp(phase_name,'DSupp')
%             [xs,ys]=spring(hip(1,4), hip(2,4), foot_sw(1,4), foot_sw(2,4), 3, 1, 0.01);
%             plot(xs,ys,'LineWidth',2,'Color','g')
%         end
%     end
    hold off %clears previous content with next plot command
    plot(x_pros, y_pros, 'Color', grey,'LineWidth',3)
    hold on
    plot(x_bod, y_bod,'k--', 'LineWidth',3)

%     % Draw joint points
%     plot(ankJoint(1), ankJoint(2), 'o','LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','y')
%     plot(kneeJoint(1), kneeJoint(2), 'o','LineWidth',1.5,'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','y')
%     plot(hipJoint(1), hipJoint(2), 'o:','LineWidth',2.5,'MarkerSize',12,'MarkerEdgeColor','k','MarkerFaceColor','y')%[.49 1 .63]
%     plot(swkneeJoint(1), swkneeJoint(2), 'o:','LineWidth',1.5,'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','y')
%     plot(swankJoint(1), swankJoint(2), 'o:','LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','y')             

    plot([x_pros(1:end),x_bod(1:end)], [y_pros(1:end),y_bod(1:end)], 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
    plot(heelJoint(1), heelJoint(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') %reference frame point


    %Draw Center of Mass, 
    plot(COM(1),COM(2),'o', 'LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','k')
    
    %Draw the ground, the line intersects with xmin and xmax
    gx = [-100,100];
    gy = [-100*tan(slope),100*tan(slope)];
    line( gx, gy, 'Color',brown)
    
    if nofig %This is being called as a stand alone frame         
        axis equal
        xmin = -2+COM(1);
        xmax =  2+COM(1);
        ymin = -2+COM(2);
        ymax =  2+COM(2);
        grid on  
        axis([xmin, xmax, ymin, ymax]);
        drawnow();
    else %This is being called in an animation
        
    end
end

