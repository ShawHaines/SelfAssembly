%% Preparations & Definitions
tic
close all hidden;
% You can adjust it manually.
uniformSize=1050;
uniformRadius=uniformSize/2;
% FrameSize=1000;
light=0.1;
ACTIVATEPLOT=false;

oldPath=pwd;
cd(folder);
vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)

frame=imcrop(readFrame(vid1),[0,0,1920,1080]);%crop the 8 excessive pixels off. 
%% crop the image manually. Use it in square boundaries
% [~,rect]=imcrop(frame); 

%% Alternate method, use it in circular boundaries.

bw=imbinarize(rgb2gray(frame));
[centers, radii, metric] = imfindcircles(bw,[450 540],'Sensitivity',0.99,'ObjectPolarity','dark');
% figure;
% imshow(bw);
% viscircles(centers, radii,'EdgeColor','b');

%rect[xmin ymin width height] y is calculated from above
rect=zeros(1,4);
rect(3)=radii(1)*2;%Height.
rect(4)=rect(3);
rect(2)=centers(1,2)-rect(3)/2;
rect(1)=centers(1,1)-rect(3)/2;

%% Main Loop
% step=(vid1.Duration-0.5)/FrameSize;
FrameSize=round(vid1.Duration*vid1.FrameRate); % deprecated NumberOfFrames 
K=zeros(uniformSize,uniformSize);
bar=waitbar(0,"Progress: "+baseName); %waitbar, very friendly! but you should only close it with close all hidden
vid1.CurrentTime=0;
rodStatus=cell(FrameSize,1);
i=0;
while hasFrame(vid1)
    i=i+1;
    t=vid1.CurrentTime;
    frame=readFrame(vid1);
    %imshow(frame);
    cropped=imresize(imcrop(frame,rect),[uniformSize,uniformSize]);
    bw=imbinarize(rgb2gray(cropped));
    bw=bwareaopen(bw,30);
    K=K+bw;
%     SE=strel('diamond',1);
%     bwFiltered=imopen(bw,SE); % not very useful, the rod is too thin
    stats=regionprops('table',bw,'Centroid','MajorAxisLength','Orientation','Area');
    % struct is organized horizontally, while table is organized
    % vertically. Personally, I am more used to vertical(column)
    % organization.
    centers=stats.Centroid;
    idx=find(inPlate(centers(:,1),centers(:,2))& stats.Area<1000);
    temp=stats(idx,:);% How handy table is! You can access it like cells, using () and {}.
    if ACTIVATEPLOT
        figure;
        imshow(bw);
    %     drawLine(stats.Centroid,stats.MajorAxisLength,stats.Orientation);
        % transpose can use ', so handy!
        drawLine(temp.Centroid,temp.MajorAxisLength,temp.Orientation);
    end
    if length(idx)==1
        rodStatus{i}=temp;
    else
        rodStatus{i}=t; % not successfully recognized
    end
    waitbar(t/vid1.Duration,bar); % surprisingly, it won't cause much additional consumption
end
%% Show & Clean
J=K*light;
for i=1:uniformSize
    for j=1:uniformSize
        if J(i,j)>1
            J(i,j)=1;
        end
    end
end

checkStatus=zeros(FrameSize,1);
for i=1:FrameSize
    checkStatus(i)=isa(rodStatus{i},'double');
end
ErrorIndex=find(checkStatus);
successRate=1-length(ErrorIndex)/FrameSize;

figure;
imshow(J);
imwrite(J,"tot.jpg");
clearvars bw cropped frame;
save(FrameSize+"_"+successRate+".mat");
cd(oldPath);
fprintf("figure outputed in %s\\%s\\tot.jpg.\n",folder,baseName);
close all hidden;
toc

%% Functions
function [R]=inPlate(x,y)
% Calculate the squre distance from  (x1,y1) to (x2,y2).(could both be a
% matrix)
%  avoid square root in order to improve efficiency.
    rPlate=500;
    dx=x-rPlate;
    dy=y-rPlate;
    rSquare=rPlate*rPlate;
    R=(dx.*dx+dy.*dy)<rSquare;
end

function [xstart, ystart, xend, yend ]=drawLine(center,len,orientation)
% draw lines with center len orientation (in degrees)
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