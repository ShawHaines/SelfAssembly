% VideoRead_Ultimate.m
% Provides circle recognition, cropping and 

%% Preparations and Definitions
close all;
% the sidelength of the output square video.
uniformSize=1050; % somewhat legacy when it comes to the ordered determination. Just don't touch it...

vid1=VideoReader(folder+"/"+fileName);
mkdir(folder+"/"+baseName);
%% Auto Recognize Circle and Cropping
frame=readFrame(vid1);% resize to exactly 1080 pixels high.

gray=rgb2gray(imresize(frame,[1080,NaN]));

bw=imbinarize(gray);
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
desiredRange=[0.1,0.2];

% check the binarize effect.
output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
figure; imshow(output);
%% Output Frames
tic;
if exist('extractionMode','var')==1 && upper(extractionMode)==upper("continuous")
    i=1;
    while hasFrame(vid1)
        frame=readFrame(vid1);
        output=processFrame(frame,uniformSize,rect,mask,desiredRange,3.0,true);
        imwrite(output,sprintf("%s/%s/%04d.png",folder,baseName,i));
        i=i+1;
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
    imwrite(output,sprintf("%s/%s/%04d.png",folder,baseName,i));
end
    
toc
fprintf("video extracted in %s\\%s.\n",folder,baseName);

%% function

function output=processFrame(input,uniformSize,rect,mask,desiredRange,gamma,binarize)
    % Gross parameter passing... Very stupid
    frame=imresize(input,[1080,NaN]);
    % image adjustment, enhance contrast.
    gray=rgb2gray(frame);
    gray=imadjust(gray,desiredRange,[]);  % the adjustment need to be done later, to ensure the success of circle detection
%     gray=imadjust(gray);
    gray=imcrop(gray,rect);
    cropped=imresize(gray,[uniformSize,uniformSize]);
    cropped(mask)=255;
    % nonlinear gamma correction is the KEY!
    cropped=gammaCorrection(cropped,gamma);
    if binarize
        cropped=imbinarize(cropped);

        % morphological process
        se=strel('disk',1);
        cropped=imopen(cropped,se);
        output=bwareaopen(cropped,6);
    else
        output=cropped;
    end
end

function output=gammaCorrection(input,gamma)
    % output an image with gamma correction.
    output=im2double(input).^gamma;
end