function out=imageclustering(population,data)
[n,d]=size(population); % d=clusternumber*bandnumber
clusternumber=data.clusternumber; 
imj=double(data.image);
[a,b,bandnumber]=size(imj);   
imjdata=reshape(imj,a*b,bandnumber);

out=rand(n,1); % pre-memory for matlab

for i=1:n
    centers=reshape(population(i,:),clusternumber,bandnumber);
    s=dist(imjdata,centers');
    [svalue,notused]=min(s,[],2);
    out(i)=sum(svalue(:));        
end
