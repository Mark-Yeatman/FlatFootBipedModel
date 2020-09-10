function [COM] = draw2Link(xi, flag, i, t, out_extra, step_num, phase_num)
    %DRAW4LINK Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    slope = flowdata.Parameters.Environment.slope;
    params = cell2mat(flowdata.Parameters.Biped.values());
    
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    isSnapShot = ~strcmp(flag,'a'); 
    
    foot_st = Foot_St_pos_func(xi,params);
    hip = Hip_pos_func(xi,params);
    foot_sw = Foot_Sw_pos_func(xi,params);
    
    %Set up lines to plot
    x_1 = [foot_st(1,4), hip(1,4)];
    y_1 = [foot_st(2,4), hip(2,4)];
    x_2 = [hip(1,4), foot_sw(1,4)];
    y_2 = [hip(2,4), foot_sw(2,4)];
    COM = COM_pos_func(xi,params);
    
    %Draw links, maintain leg swap in linestyle
    hold off %clears previous content with next plot command
    plot(x_1, y_1, 'Color',grey,'LineWidth',3)
    hold on
    plot(x_2, y_2,'k--', 'LineWidth',3)

    %Draw joint points
    plot(x_1(1), y_1(1), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') %reference frame point
    plot([x_1(2:end),x_2], [y_1(2:end),y_2], 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')

    %Draw Center of Mass, 
    plot(COM(1),COM(2),'o', 'LineWidth',1,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','k')
    
    %Draw Ellipse
%     theta = linspace(0,2*pi,150);
%     x_e = sqrt(sqrt(2))*cos(theta);
%     y_e = sqrt(sqrt(2))/2*sin(theta);
%     plot(x_1(1)+x_e,y_1(1)+y_e,'b')
    
    %Draw the ground, the line intersects with xmin and xmax
    gx = [-100,100];
    gy = [-100*tan(slope),100*tan(slope)];
    line( gx, gy, 'Color',brown)
    
    if isSnapShot %This is being called as a stand alone frame         
        axis equal
        xmin = -2+COM(1);
        xmax =  2+COM(1);
        ymin = -2+COM(2);
        ymax =  2+COM(2);
        grid on  
        axis([xmin, xmax, ymin, ymax]);
        %drawnow();
    else %This is being called in an animation
        
    end
end

