
%% Preparations & Definitions
oldPath=pwd;
cd(folder);
vid1=VideoReader(fileName);
% mkdir(baseName)
cd(baseName)
load(dataName);
close all hidden;
global uniformSize;
% You can adjust it manually.
uniformSize=1050;
% FrameSize=1000;
light=0.1;
ACTIVATEPLOT=true;
%% Main Loop
figure;
ax1=subplot(1,2,1);
ax2=subplot(1,2,2);
for i=1:length(ErrorIndex)
    vid1.CurrentTime=rodStatus{ErrorIndex(i)};
    
    frame=readFrame(vid1);
    %imshow(frame);
    cropped=imresize(imcrop(frame,rect),[uniformSize,uniformSize]);
    subplot(ax1);
    imshow(cropped);
    title(vid1.CurrentTime+" s");
    bw=imbinarize(rgb2gray(cropped));
    bw=bwareaopen(bw,30);
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
        subplot(ax2);
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
end
checkStatus=zeros(FrameSize,1);
for i=1:FrameSize
    checkStatus(i)=isa(rodStatus{i},'double');
end
ErrorIndex=find(checkStatus);
successRate=1-length(ErrorIndex)/FrameSize;
fprintf("WorkDone.\n");

%% Functions
function [R]=inPlate(x,y)
% Calculate the squre distance from  (x1,y1) to (x2,y2).(could both be a
% matrix)
%  avoid square root in order to improve efficiency.
    global uniformSize;
    rPlate=485;
    dx=x-uniformSize/2;
    dy=y-uniformSize/2;
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

    