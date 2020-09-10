function myprint(str)
    %myprint Only actually displays something using fprintf if the flowdata
    %silent flag is false
    %   
    global flowdata
    if ~flowdata.Flags.silent && (isstring(str) || ischar(str))
        fprintf(str); 
    end
end

