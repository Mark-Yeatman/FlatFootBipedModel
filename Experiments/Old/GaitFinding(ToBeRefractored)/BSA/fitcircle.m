function out=fitcircle(population,data)
xdata=data.x;
ydata=data.y;
n=size(population,1);
out=rand(n,1); % peer-memory for matlab
for i=1:n
    a=population(i,1);
    b=population(i,2);
    r=population(i,3);
    out(i)=sum( abs((xdata-a).^2+(ydata-b).^2-r.^2 )); % circle-equation based objective function
end
out=out'; % out should be a column-vector
    