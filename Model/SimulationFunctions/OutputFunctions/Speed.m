function s = Speed(t,y,~)
    %SPEED Summary of this function goes here
    %   Detailed explanation goes here
    L = StepLength(t,y,'');
    s = L/(t(end)-t(1));
    myprint(strcat("\n\t\tSteplength: ", num2str(L,4),", Speed: ", num2str(s,4),"\n"));
end

