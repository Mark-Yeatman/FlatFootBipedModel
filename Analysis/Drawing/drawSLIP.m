function [COM] = drawSLIP(xi,flag)
    %DRAW4LINK Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    slope = flowdata.Parameters.Environment.slope;
    
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    nofig = ~strcmp(flag,'a'); 
    
    %Draw COM point
    COM = xi(1:2);
    plot(xi(1), xi(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') 
    
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

