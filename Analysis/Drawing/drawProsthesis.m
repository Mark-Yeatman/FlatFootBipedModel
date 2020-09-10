function [COM] = drawProsthesis(qi,flag)
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
    
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    nofig = ~strcmp(flag,'a'); 
    
    heelx = qi(1);
    heely = qi(2);
    
    % Determine the hip and feet positions in 2D space
    heelJoint =  [heelx,heely];
    toeJoint = Toe_St_pos_func(qi);
    ankJoint = Ankle_St_pos_func(qi);
    kneeJoint = Knee_St_pos_func(qi);
    hipJoint = Hip_pos_func(qi);
    
    %Set up lines to plot
    x_pros = [toeJoint(1,4) heelJoint(1) ankJoint(1,4) kneeJoint(1,4) hipJoint(1,4)];
    y_pros = [toeJoint(2,4) heelJoint(2) ankJoint(2,4) kneeJoint(2,4) hipJoint(2,4)];

    COM = COM_pos_func(qi);
    
    hold off %clears previous content with next plot command
    plot(x_pros, y_pros, 'Color', grey,'LineWidth',3)
    hold on

    plot(x_pros(1:end), y_pros(1:end), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
    plot(heelJoint(1), heelJoint(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') %reference frame point

    %Draw Center of Mass, 
    plot(COM(1),COM(2),'o', 'LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','k')
    
    %Draw Spring
%     R = flowdata.Parameters.Biped.R;
%     phi = flowdata.Parameters.Biped.phi;
%     L0 = flowdata.Parameters.SLIP.L0;
%     pC = [R.*cos(phi+qi(3))+qi(1),R.*sin(phi+qi(3))+qi(2),0];
%     [xs,ys]=spring(hipJoint(1,4), hipJoint(2,4), pC(1), pC(2), 6, 1.1*L0, 0.001);
%     plot(xs,ys,'LineWidth',2,'Color','g');
    
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

