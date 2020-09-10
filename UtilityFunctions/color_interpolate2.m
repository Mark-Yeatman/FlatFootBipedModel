function cmap = color_interpolate2(color1,color2,norm_data)
    %color_interpolate Summary of this function goes here
    %   Detailed explanation goes here
    color1 = rgb2hsv(color1);
    color2 = rgb2hsv(color2);
    cmap = zeros(length(norm_data),3);
    for i =1:length(norm_data)
       cmap(i,:) = hsv2rgb(color1*(1 - norm_data(i)) + color2*norm_data(i));
    end
end

