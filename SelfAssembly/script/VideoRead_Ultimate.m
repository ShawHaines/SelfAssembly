% VideoRead_Ultimate.m
% Provides circle recognition, cropping and gamma correction.
%% Preparations and Definitions
function lastFrameIndex=VideoRead_Ultimate(videoPath,savePath,extractionMode)
% read the video provided by videoPath, save images as pngs at savePath.
close all;
% the sidelength of the output square video.
uniformSize=1050; % somewhat legacy when it comes to the ordered determination. Just don't touch it...

vid1=VideoReader(videoPath);
if exist(savePath,'dir')~=7
    mkdir(savePath);
end
%% Auto Recognize Circle and Cropping
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

%%
output=processFrame(frame,uniformSize,rect,mask,[0,1],1.0,false);
figure; imshow(output);
figure;imhist(output); % according to the histogram of the image, decide the
% desiredRange in function, filter out the peak of dark plate.
desiredRange=[0.3,0.6];

% check the binarize effect.
output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,false);
figure; imshow(output);
% figure;imhist(output);
% adjusted=imadjust(output,[0.3,0.7],[]);
% figure; imshow(adjusted);
% figure; imshow(imbinarize(adjusted));
%% Output Frames
tic;
if exist('extractionMode','var')==1 && upper(extractionMode)==upper("continuous")
    i=0;
    while hasFrame(vid1)
        i=i+1;
        frame=readFrame(vid1);
        output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
        imwrite(output,sprintf("%s/%04d.png",savePath,i));
    end
else
    % default is only single frame.
    if exist('videoTime','var')==0 % if undefined, define it to be 0.
        videoTime=0;
    end
    vid1.CurrentTime=videoTime;
    i=floor(videoTime*vid1.FrameRate);
    frame=readFrame(vid1);
    output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
    imwrite(output,sprintf("%s/%04d.png",savePath,i));
end
    
toc
fprintf("video extracted in %s.\n",savePath);
lastFrameIndex=i;
end