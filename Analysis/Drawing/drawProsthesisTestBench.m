function [COM] = drawProsthesisTestBench(qi,flag,i,t,out_extra)
    %drawProsthesis Plots a picture of a leg given state vector. Heel is
    %locater in the world frame
    %   xi = [x,y,global heel angle, ankle angle, knee angle]. Angles in
    %   radians.
    global flowdata
    persistent rollsweep
    
    if isempty(rollsweep)
        rollsweep= [];
    end
    slope = flowdata.Parameters.Environment.slope;
    params = flowdata.Parameters.Dynamics.asvector;
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    nofig = ~strcmp(flag,'a'); 
    
    heelx = qi(1);
    heely = qi(2);
    
    % Determine the hip and feet positions in 2D space
    heelJoint =  Heel_pos_func(qi,params);
    toeJoint = Toe_pos_func(qi,params);
    ankJoint = Ankle_pos_func(qi,params);
    kneeJoint = Knee_pos_func(qi,params);
    hipJoint = [0,0];
    
    %Set up lines to plot
    x = [toeJoint(1), heelJoint(1), ankJoint(1), kneeJoint(1), hipJoint(1)];
    y = [toeJoint(2), heelJoint(2), ankJoint(2), kneeJoint(2), hipJoint(2)];

    COM = COM_pos_func(qi,params);
    
    hold off %clears previous content with next plot command
    plot(x, y, 'Color', grey,'LineWidth',3)
    hold on

    plot(x(1:end), y(1:end), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
    plot(heelJoint(1), heelJoint(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') %reference frame point

    %Draw Center of Mass, 
    plot(COM(1),COM(2),'o', 'LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','k')
    
    %Draw Spring
    %R = flowdata.Parameters.Biped.R;
    %phi = flowdata.Parameters.Biped.phi;
    L0 = flowdata.Parameters.SLIP.L0;
    %pC = [R.*cos(phi+qi(3))+qi(1),R.*sin(phi+qi(3))+qi(2),0];
    px = flowdata.Parameters.Dynamics.asvector(end-1);
    py = flowdata.Parameters.Dynamics.asvector(end);
    [xs,ys] = draw_spring(toeJoint(1), toeJoint(2), px, py, 6, L0, 0.001);
    plot(xs,ys,'LineWidth',2,'Color','g');
    
    %plot 
%     rollsweep = [rollsweep,[pC(1);pC(2)]];
%     plot(rollsweep(1,:),rollsweep(2,:),'Color', 'c','LineWidth',1);
    
    %Draw the ground, the line intersects with xmin and xmax
    gx = [-100,100];
    gy = [-100*tan(slope),100*tan(slope)];
    line( gx, gy, 'Color',brown)
    
    if nofig %This is being called as a stand alone frame         
        axis equal
        axmag = 1;
        xmin = -axmag+COM(1);
        xmax =  axmag+COM(1);
        ymin = -axmag+COM(2);
        ymax =  axmag+COM(2);
        grid on  
        axis([xmin, xmax, ymin, ymax])
        drawnow();
    else %This is being called in an animation
        
    end
end

