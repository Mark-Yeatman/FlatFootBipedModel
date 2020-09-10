function cmap = color_interpolate(color1,color2,steps)
    %color_interpolate Summary of this function goes here
    %   Detailed explanation goes here
    color1 = rgb2hsv(color1);
    color2 = rgb2hsv(color2);
    cmap = zeros(steps,3);
    v = linspace(0,1,steps);
    for i =1:steps
       cmap(i,:) = hsv2rgb(color1*(1 - v(i)) + color2*v(i));
    end
end

