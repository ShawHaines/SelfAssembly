close all;
% folder="Video1";
% cd(folder);
% Determins whether to plot the results.
showGraph=false;
%% Read image
% fileName="./4.png";
img=rgb2gray(imread(fileName));
imageSize=size(img);
% rotate if not horizontal
if imageSize(1)>imageSize(2)
    % elegant!
    img=img';
end
% resize to fit all pictures.
img=imresize(img,[NaN,1280]);
if showGraph
    figure;
    imshow(img);
end
%% Image processing
% adjust the contrast.
contrast=imadjust(img);
if showGraph
figure;
imshow(contrast);
title("contrast");
end
img=contrast;
% % sharpen.
% sharpen=imsharpen(img);
% figure;
% imshow(sharpen);
% title("sharpened");
%% Binarize
% threshold=0.6;
% sensitivity is very tricky...
% bw=imbinarize(img,'adaptive','Sensitivity',0.75);
bw=imbinarize(img);
% bw=imbinarize(img,threshold);
if showGraph
figure;
imshow(bw);
end
%% Morphological
% Again very tricky...
SE=strel('disk',60);
processed=imopen(bw,SE);
% figure;
% imshow(processed);
% title("opened");
SE=strel('disk',4);
processed=imclose(processed,SE);
% figure;
% imshow(processed);
% title("closed");
%% Region Recognition
% only preserves the region that is near the center.
cc=bwconncomp(processed);
stats=regionprops('table',cc,'Area','Centroid','EulerNumber','MajorAxisLength','Orientation');
%% Filter
centroids=stats.Centroid;
imageSize=fliplr(size(bw));
deltaR=centroids-imageSize/2;
distance=vecnorm(deltaR,2,2);
% EulerNumber ==0 means there's one and only one black block in the area.
index=find(distance<200 & stats.Area<200000 & distance<stats.MajorAxisLength/2);
extracted=ismember(labelmatrix(cc),index);
% figure,imshow(extracted);
counter=~extracted;
% erase small noice dots
counter=bwareaopen(counter,100);
extracted=~counter;
if showGraph
figure,imshow(extracted);
end
%% Calibration using central screw
% capture the origin
statsCounter=regionprops('table',counter,'Area','EquivDiameter','Centroid');
index=find(statsCounter.Area<200000);
origin=statsCounter.Centroid(index,:);
pixels=statsCounter.EquivDiameter(index);
% actual length of the hexagonal screw. Unit:m
actualLength=8e-3;
scale=actualLength/pixels;
if showGraph
hold on;
viscircles(origin,pixels/2);
title("Extracted Result");
end
%% Auxilary plot
% hold on;
% [xstart,ystart,xend,yend]=drawLine(stats.Centroid,stats.MajorAxisLength,stats.Orientation);

%% Boundary extraction
[B,L]=bwboundaries(extracted);
outterBoundary=B{1};
% Be careful the difference between (x,y) and (row,column) order
outterBoundary=fliplr(outterBoundary);
if showGraph
hold on;
plot(outterBoundary(:,1),outterBoundary(:,2));
end
%% Calculate r,theta
deltaR=(outterBoundary-origin)*scale;
rho=vecnorm(deltaR,2,2);
% y is upside-down
theta=atan2(-deltaR(:,2),deltaR(:,1));

% the problem with the code below is that r(theta) is not a 1-to-1 correspondence,
% and should be represented by r(t) and theta(t) parameter.

% % sort in ascending order.
% [theta,index]=sort(theta);
% rho=rho(index);
% % let it be a closed loop.
% theta=[theta(end)-2*pi;theta;theta(1)+2*pi];
% rho=[rho(end);rho;rho(1)];
if showGraph
figure,polarplot(theta,rho);
figure,plot(theta,rho);
end
%% Express the countour as complex numbers.
% again the y axis needs to flip.
boundary=deltaR(:,1)-1i*deltaR(:,2);
% figure;
% axis equal;
% plot(real(boundary),imag(boundary));

%% Discrete Fourier Transformation
slices=1000;
% interpolation, now useless...
% thetaEqualInterval=linspace(-pi,pi,slices);
% rhoEqualInterval=interp1(theta,rho,thetaEqualInterval);
% y=abs(fft(rhoEqualInterval));
y=abs(fft(rho))/length(rho); % divide by length,normalization.
y=fftshift(y);
[~,middle]=max(y);
x=-20:20;
% complex integration, c for complex
yc=abs(fft(boundary))/length(boundary);
yc=fftshift(yc);
% The results are convincing.
[~,middleC]=max(yc);
if showGraph
figure;
subplot(2,1,1);
stem(x,y(middle+x));
title("FFT");
subplot(2,1,2);
stem(x,yc(middleC+x-1));
title("Complex Integration");
end
%% Function
function [xstart, ystart, xend, yend ]=drawLine(center,len ,orientation)
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

function y=fourier(theta,rho,n)
    z=rho.*exp(1i*n*theta);
    for i=2:length(theta)
        if abs(theta(i)-theta(i-1))>pi
            if theta(i)>theta(i-1)
                theta(i)=theta(i)-2*pi;
            else
                theta(i)=theta(i)+2*pi;
            end
        end
    end
    y=trapz(theta,z);
end