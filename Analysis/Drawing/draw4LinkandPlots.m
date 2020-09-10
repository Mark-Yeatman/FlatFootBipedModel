function [COM] = draw4LinkandPlots(xi,flag,i,t,out_extra)
    %DRAW4LINK Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    slope = flowdata.Parameters.Environment.slope;
    
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    
    nofig = ~strcmp(flag,'a'); 
    
    foot_st = Foot_St_pos_func(xi);
    knee_st = Knee_St_pos_func(xi);
    hip = Hip_pos_func(xi);
    knee_sw = Knee_Sw_pos_func(xi);
    foot_sw = Foot_Sw_pos_func(xi);
    
    %Set up lines to plot
    x_1 = [foot_st(1,4), knee_st(1,4), hip(1,4)];
    y_1 = [foot_st(2,4), knee_st(2,4), hip(2,4)];
    x_2 = [hip(1,4), knee_sw(1,4), foot_sw(1,4)];
    y_2 = [hip(2,4), knee_sw(2,4), foot_sw(2,4)];
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
    
    %Draw links, maintain leg swap in linestyle
    ax1 = subplot(2,1,1);
    hold off %clears previous content with next plot command
    plot(x_1, y_1, 'Color',grey,'LineWidth',3)
    hold on
    plot(x_2, y_2,'k--', 'LineWidth',3)

    %Draw joint points
    plot(x_1(1), y_1(1), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k') %reference frame point
    plot([x_1(2:end),x_2], [y_1(2:end),y_2], 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')

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
        %drawnow();
    else %This is being called in an animation
        
    end
    subplot(2,1,2)
    hold off
    plot(t,out_extra.GRF)
    hold on 
    plot(t(i),out_extra.GRF(i,:) ,'ro')
    title('ground Reaction Forces')
    legend("F1_{T}","F1_{N}","F2_{T}","F2_{N}",'Location', 'eastoutside')
    xlabel("time")
    ylabel("force")
    
    axes(ax1);
end

