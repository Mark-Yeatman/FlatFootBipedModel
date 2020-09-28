function animate(drawfunc, x, t, out_extra, timescale, moviename)
% Written by Mark Yeatman
    clear(func2str(drawfunc));
    global flowdata quit_animation
    quit_animation = false;
    slope = flowdata.Parameters.Environment.slope;

    if nargin <5
        timescale = 1;
    end
    if nargin <6
        moviename =[];
    end

    % Create figure
    screenSize = get(0, 'ScreenSize');
%     width = screenSize(3)*1/2;
%     left = screenSize(3)/4;
%     bottom = screenSize(4)/4;
%     height = screenSize(4)*1/2;
    width = screenSize(3);
    left = 0;
    bottom = 0;
    height = screenSize(4);
    fig = figure('Position', [left bottom width height],...
                 'Color','w',...
                 'DoubleBuffer','on');
    set(fig,'KeyPressFcn',@key_press);
    disp("Press q, with the figure having focus, to gracefully stop the animation.")
    set(gca,'NextPlot','replace','Visible','off')
    %COM = drawfunc(x(1,:)','a'); %'a' is for animation
    COM = drawfunc(x(1,:)','a',1,t(1),out_extra, 1, 1); %'a' is for animation
    camera_shift = [COM(1),COM(2)];
    axmag = 5;
    ymax =  axmag + camera_shift(2);
    ymin = -axmag + camera_shift(2);
    xmax =  axmag + camera_shift(1);
    xmin = -axmag + camera_shift(1); 
    
    % Initialize the movie
    FrameTotal = length(t);
    FramesPerSec = 60;%360;
    nextFrameTime = 0;

    if ~isempty(moviename)
        mov = VideoWriter(moviename);
        mov.FrameRate = FramesPerSec;
        mov.Quality = 100;
        open(mov)
    end
    
    %initialize extra info
    if ~isempty(out_extra)
        step_num = 1;
        phase_num=1;
        phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
        if isfield(out_extra.steps{step_num}.phases{phase_num},'configs')
            config_name = strjoin(out_extra.steps{step_num}.phases{phase_num}.configs);
        else
            config_name = '';
        end
        total_steps = length(out_extra.t_impacts);
        last_impact = '';
    end
    
    for i=1:FrameTotal       
        %compute step number and phase name
        if quit_animation
           break; 
        end
        if ~isempty(out_extra)
            %new step
            if t(i) > out_extra.t_impacts(step_num)
                if step_num < total_steps
                    
                    step_num = step_num+1;
                    phase_num = 1;
                    phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
                    if isfield(out_extra.steps{step_num}.phases{phase_num},'configs')
                        config_name = strjoin(out_extra.steps{step_num}.phases{phase_num}.configs);
                    else
                        config_name = '';
                    end
                    if isfield(out_extra.steps{step_num}.phases{phase_num},'terminal_impact')
                        last_impact = out_extra.steps{step_num}.phases{phase_num}.terminal_impact;
                    else
                        last_impact = '';
                    end
                end
            end
            %new phase
            if ( t(i) > out_extra.steps{step_num}.phases{phase_num}.t_end ) && ( phase_num < length(out_extra.steps{step_num}.phases) ) 
                phase_num = phase_num+1;
                phase_name = out_extra.steps{step_num}.phases{phase_num}.phase_name;
                if isfield(out_extra.steps{step_num}.phases{phase_num},'configs')
                    config_name = strjoin(out_extra.steps{step_num}.phases{phase_num}.configs);
                else
                    config_name = '';
                end
                if isfield(out_extra.steps{step_num}.phases{phase_num},'terminal_impact')
                    last_impact = out_extra.steps{step_num}.phases{phase_num}.terminal_impact;
                else
                    last_impact = '';
                end
            end
        end
        
        if (t(i) >= nextFrameTime) && i <= FrameTotal %skip some data points so that the movie actually plays in real time
            nextFrameTime = nextFrameTime + timescale/FramesPerSec;
            
            %Draw the Biped
            COM = drawfunc(x(i,:)','a',i,t,out_extra, step_num, phase_num); %'a' is for animation
            %COM = drawfunc(x(i,:)','a'); %'a' is for animation
            
            if COM(1)>xmax || COM(2)<ymin
                camera_shift =  axmag*[cos(-slope),sin(-slope)] + camera_shift;
            end
            
            if COM(1)<xmin 
                camera_shift = -axmag*[cos(-slope),sin(-slope)] + camera_shift;
            end
            
            %Info text annotation
            if ~isempty(out_extra)
                info_str = {['step ' , num2str(step_num)], ...
                            ['phase ' , num2str(phase_num)], ...
                            ['t =' , num2str(t(i))], ...
                            ['phase: ' , phase_name] ...
                            ['config: ', config_name],...
                            ['last impact: ',last_impact]};
            
                try
                    delete(a);
                catch
                end
                a = annotation('textbox', [0.05, 0.5, 0.1, 0.1], 'String', info_str);
            else
                info_str = {strcat('t =' , num2str(t(i)))};             
                try
                    delete(a);
                catch
                end
                a = annotation('textbox', [0.05, 0.5, 0.1, 0.1], 'String', info_str);
            end
            
            %Update axis boundaries
            ymax =  axmag + camera_shift(2);
            ymin = -axmag + camera_shift(2);
            xmax =  axmag + camera_shift(1);
            xmin = -axmag + camera_shift(1); 
            
            axis equal
            grid on
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
    close(gcf())
end

function key_press(src,event)
    global quit_animation
    if strcmp(event.Key,'q')
        quit_animation = true;
    end
end