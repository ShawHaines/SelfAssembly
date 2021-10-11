% VideoRead_Tracing.m
% Provides combined function of VideoRead_Ultimate and Tracing. Only output
% a mat file for centers, thus reduce space consumption and IO time.
%% Preparations and Definitions
function lastFrameIndex=VideoRead_Tracing(videoPath,savePath,baseName)
% read the video provided by videoPath, save images as pngs at savePath.
close all;
% the sidelength of the output square video.
uniformSize=1050; % somewhat legacy when it comes to the ordered determination. Just don't touch it...

vid1=VideoReader(videoPath);
if exist(savePath,'dir')~=7
    mkdir(savePath);
end
sampleSize=floor(vid1.Duration*vid1.FrameRate);
% if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=true;
% beads with distance values between 2 frames higher than this cannot be viewed as the same one.
vicinityThreshold=20;
saveBase=sprintf("%s/%s_tracing",savePath,baseName);
%% Auto Recognize Circle, Cropping and Mask
frame=readFrame(vid1);% resize to exactly 1080 pixels high.
bw=imbinarize(rgb2gray(imresize(frame,[1080,NaN])));
% automatically recognize the biggest circle.
[centers, radii, metric] = imfindcircles(bw,[450 540],'Sensitivity',0.99,'ObjectPolarity','dark');
% figure;imshow(bw);
% viscircles(centers, radii,'EdgeColor','b');

%rect[xmin ymin width height] y is calculated from above
rect=zeros(1,4);
rect(3)=radii(1)*2;%Height.
rect(4)=rect(3);
rect(2)=centers(1,2)-rect(3)/2;
rect(1)=centers(1,1)-rect(3)/2;

% mask that decides where would be filled with white.
[X,Y]=meshgrid(1:uniformSize,1:uniformSize);
halfSize=(uniformSize+1)/2;
mask=((X-halfSize).^2+(Y-halfSize).^2)>(uniformSize-1)^2/4;

%% Preview
output=processFrame(frame,uniformSize,rect,mask,[0,1],1.0,false);
figure; imshow(output);
figure;imhist(output); % according to the histogram of the image, decide the
% desiredRange in function, filter out the peak of dark plate.
desiredRange=[0.3,0.6];

% check the binarize effect.
output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
figure; imshow(output);
%% Tracing loop
% initializing
center=cell(sampleSize,1);
source=NaN; % source is the previous image. 2 labels can converge but no labels will bifurcate.
tic;
i=0;vid1.CurrentTime=0;
if exist('ACTIVATEPLOT','var')~=0 && ACTIVATEPLOT
    figure;
    writer=VideoWriter(char(saveBase+".avi")); % Strange that it does not seem to support string.
    writer.FrameRate=25.0;
    open(writer);
end
while hasFrame(vid1)
    i=i+1;
    frame=readFrame(vid1);
    output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
    stats = regionprops('table',output,'Centroid','Area');
    centroid=stats.Centroid(stats.Area<10000,:); % exclude the 4 big white areas on the corners.
    sidelength=uniformSize/2;
    if isnan(source)
        % the first frame, initialize.
        center{i}=centroid;
        source=center{i}; % sourceCount*2 matrix.
        sourceCount=size(source,1); % the count is fixed from now on.
        colorMapping=rand([sourceCount,1]); % colorful labels
    else
        target=centroid;
        center{i}=zeros(sourceCount,2);
        for j=1:sourceCount % find matches for each bead in source
            distance=vecnorm(target-source(j,:),2,2);
            [minDistance,index]=min(distance);
            if minDistance<vicinityThreshold % successful matching.
                center{i}(j,:)=target(index,:);
            else
                center{i}(j,:)=NaN; % Leave blank.
            end
        end
        % Update source, Leave the NaN with the last known location.
        validIndices=~isnan(center{i});
        source(validIndices)=center{i}(validIndices);
    end
    if ACTIVATEPLOT % plotting beads for checking
        % all the beads recognized.
        % imshow(output);
        % hold on; % if turned on, the particles would leave a trace, interesting, isn't it?
        scatter(center{i}(:,1),center{i}(:,2),16,colorMapping,'filled');
        viscircles([sidelength+0.5,sidelength+0.5],sidelength);
        % vertically mirrored so that y=0 starts at the bottom, 
        axis ij;
        axis equal;
        colormap jet;
        drawnow;
        writeVideo(writer,getframe(gcf));
    else
        i  % display the progress...
    end
end
%% Saving
if ACTIVATEPLOT
    close(writer);
    fprintf("Saved data in %s.avi.\n",saveBase);
end
lastFrameIndex=i;
% there might be empty cells in the tail of the cell array.
center=center(1:lastFrameIndex);
save(saveBase+".mat",'center');
fprintf("Saved data in %s.mat\n",saveBase);
fprintf("finished.\n");
toc
end