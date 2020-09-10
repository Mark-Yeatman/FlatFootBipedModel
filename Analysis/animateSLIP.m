function animateSLIP(x, t, out_extra, timescale, moviename)
%
% ANIMATE2 Visualize the walker walking down a slope. May need to edit
% depending on the model.
%
% INPUT:
% + xcycle = vector of the states at each integration step. See walk.
% + movie = the movie recording option. If movie == '', no recording is
%   made. Otherwise, this string is used as the movie's file name.
%
% Notes:
% Avoid running anything computationally intesive when you use this
% animation.
%
% Written by Eric D.B. Wendel and Robert D. Gregg and Mark Yeatman

    global flowdata
    slope = flowdata.Parameters.Environment.slope;
    if nargin ==1
        t=1;
    else

    end
    if nargin <4
        timescale = 1;
    end
    if nargin <5
        moviename =[];
    end
    zoom = 1/5;
    grey = [0.3, 0.3, 0.3];
    brown = [0.396, 0.263, 0.129];
    % Create figure
    screenSize = get(0, 'ScreenSize');
    width = screenSize(3);
    left = 0;
    bottom = 0;
    height = screenSize(4);
    fig = figure('Position', [left bottom width height],...
                 'Color','w',...
                 'DoubleBuffer','on');
    set(fig,'KeyPressFcn',@key_press);
    %disp("Press q, with the figure having focus, to gracefully stop the animation.")
    set(gca,'NextPlot','replace','Visible','off')
    camera_shift = [0,0];
    
    % Initialize the movie
    FramesPerSec=60;  
    nextFrameTime = 0;

    if ~isempty(moviename)
        mov=VideoWriter(moviename,'MPEG-4');
        mov.FrameRate=FramesPerSec;
        mov.Quality=100;
        open(mov)
    end
    
    %initialize extra info
    if nargin >= 3
        step_num = 1;
        phase_num=1;
        phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
        total_steps = length(out_extra.t_impacts);
        last_impact = '';
        speed = out_extra.steps{step_num}.speed;
%         stiffness = out_extra.steps{step_num}.stiffness;
%         energy = out_extra.steps{step_num}.Eref;
        pf1 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_1;
        pf2 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_2;
        camera_shift = x(1,1:2);
    end
    
    for i=1:length(t)
        %Compute pose at i_th time step
        xi = x(i,:)';
        
        %compute step number and phase name
        if nargin >= 3
            %new step
            if t(i) > out_extra.t_impacts(step_num)
                if step_num < total_steps
                    last_impact = out_extra.steps{step_num}.phases{phase_num}.impact_name;
                    speed = out_extra.steps{step_num}.speed;
%                     stiffness = out_extra.steps{step_num}.stiffness;
%                     energy = out_extra.steps{step_num}.Eref;
                    step_num = step_num+1;
                    phase_num = 1;
                    phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
                    pf1 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_1;
                    pf2 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_2;
                end
            end
            %new phase
            if t(i) > out_extra.steps{step_num}.phases{phase_num}.tend
                last_impact = out_extra.steps{step_num}.phases{phase_num}.impact_name;
                speed = out_extra.steps{step_num}.speed;
%                 stiffness = out_extra.steps{step_num}.stiffness;
%                 energy = out_extra.steps{step_num}.Eref;
                phase_num = phase_num+1;
                phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
                pf1 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_1;
                pf2 = out_extra.steps{step_num}.phases{phase_num}.foot_pos_2;
            end
        end       

        if (t(i) >= nextFrameTime) || i == length(t) %skip some data points so that the movie actually plays in real time
            nextFrameTime = nextFrameTime + timescale/FramesPerSec;
            
            %Draw spring points
            hold off %clears previous content with next plot command
            %Draw mass
            plot(xi(1),xi(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
            grid on
            hold on

            %Update axis boundaries
            ymax =  1/zoom + camera_shift(2);
            ymin = -1/zoom + camera_shift(2);
            xmax =  1/zoom + camera_shift(1);
            xmin = -1/zoom + camera_shift(1);           

            %Draw the ground, the line intersects with xmin and xmax
            gx = [xmin,xmax];
            gy = [xmin*tan(slope), xmax*tan(slope)];
            line( gx, gy, 'Color',brown)

            %Info text           
            if nargin >= 3
                
                %plot feet
                if ~strcmp(phase_name,'Flight')
                    plot(pf1(1), pf1(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
                end

                if strcmp(phase_name,'DSupp')
                    plot(pf2(1), pf2(2), 'o', 'LineWidth',1,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
                end
                
                %plot springs
                if ~strcmp(phase_name,'Flight')
                    [xs,ys] = draw_spring(xi(1), xi(2), pf1(1), pf1(2), 6, flowdata.Parameters.SLIP.L0, 0.01);
                    plot(xs,ys,'LineWidth',2,'Color','g')
                end
                if strcmp(phase_name,'DSupp')
                    [xs,ys] = draw_spring(xi(1), xi(2), pf2(1), pf2(2), 6, flowdata.Parameters.SLIP.L0, 0.01);
                    plot(xs,ys,'LineWidth',2,'Color','g')
                end
                
%                 info_str = {strcat('step ' , num2str(step_num)), ...
%                             strcat('time: ' , num2str(t(i)) , ' s'), ...
%                             strcat('speed: ' , num2str(speed),' m/s'), ...
%                             strcat('stiffness: ',num2str(stiffness) ,' N/m'),...
%                             strcat('Reference Energy: ',num2str(energy) ,' J')};
                info_str = {strcat('step ' , num2str(step_num)), ...
                            strcat('phase ' , phase_name), ...
                            strcat('time: ' , num2str(t(i)) , ' s'), ...
                            strcat('speed: ' , num2str(speed),' m/s')};
                %plot touchdown height
                sx = [xmin,xmax];
                sy = [xmin*tan(slope) + flowdata.Parameters.SLIP.L0*sin(flowdata.State.alpha), xmax*tan(slope) + flowdata.Parameters.SLIP.L0*sin(flowdata.State.alpha)];
                %line( sx, sy, 'LineStyle','--', 'Color', 'r')
                        
                %if the biped gets out of frame, shift the bounds
                if xi(1) >xmax || xi(2) < ymin
                    %these are magic numbers, steplength*# of steps to get out of frame
                    camera_shift = [(xmax-xmin)*cos(-slope),(ymax-ymin)*sin(-slope)] + camera_shift;
                end
            else
                info_str = strcat('t = ' ,num2str(t(i)));
            end

            try
                delete(a);
            catch
            end
            a = annotation('textbox', [0.05, 0.5, 0.2, 0.2], 'String', info_str);
            a.FontSize = a.FontSize*2;
            if step_num > 5
                a.Color = 'blue';
            end
            axis equal
            %axis off
            axis([xmin, xmax, ymin, ymax]);
            drawnow;

            % Add movie frames?
            if ~isempty(moviename)
                F = getframe(gcf);
                writeVideo(mov,F);
            end
        end
    end
end

function key_press(src,event)
    global quit_animation
    if strcmp(event.Key,'q')
        quit_animation = true;
    end
end