%close all
%clear all
tic
sampleSize=25;
% yu=130; %ãÐÖµ

oldPath=pwd;
cd(folder+"/"+baseName);

A=imread("1.jpg");
I=rgb2gray(A);
thresh=adaptthresh(I);
bw=imbinarize(I,thresh);
% bw=bwareaopen(bw);
imshow(bw);

stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength','EquivDiameter','Orientation','Eccentricity');
centers = stats.Centroid;
[xstart,ystart,xend,yend]=drawLine(centers,stats.MajorAxisLength,stats.Orientation);

toc
function [xstart, ystart, xend, yend ]=drawLine(center,len,orientation)
    xstart=center(:,1)-cosd(orientation)/2.*len;
    ystart=center(:,2)+sind(orientation)/2.*len;% y is inverted.
    xend  =center(:,1)+cosd(orientation)/2.*len;
    yend  =center(:,2)-sind(orientation)/2.*len;
    for i=1:length(xstart)
        line([xstart(i),xend(i)],[ystart(i),yend(i)],'Linewidth',1);
    end
    hold on;
    scatter(center(:,1),center(:,2));
    hold off;
end