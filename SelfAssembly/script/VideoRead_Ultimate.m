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
% imhist(gray); % according to the histogram of the image, decide the
% desiredRange in function, filter out the peak of dark plate.

bw=imbinarize(gray);
% automatically recognize the biggest circle.
[centers, radii, metric] = imfindcircles(bw,[450 540],'Sensitivity',0.99,'ObjectPolarity','dark');
figure;
imshow(bw);
viscircles(centers, radii,'EdgeColor','b');

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
output=processFrame(frame,uniformSize,rect,mask);
figure; imshow(output);
% figure; imshow(imbinarize(cropped));

%% Output Frames
tic;
i=1;
while hasFrame(vid1)
    frame=readFrame(vid1);
    output=processFrame(frame,uniformSize,rect,mask);
    imwrite(output,sprintf("%s/%s/%04d.png",folder,baseName,i));
    i=i+1;
end

toc
fprintf("video extracted in %s\\%s.\n",folder,baseName);

%% function

function output=processFrame(input,uniformSize,rect,mask)
    % Gross parameter passing... Very stupid
    frame=imresize(input,[1080,NaN]);
    % image adjustment, enhance contrast.
    gray=rgb2gray(frame);
    desiredRange=[0.25,0.5];
    gray=imadjust(gray,desiredRange,[]);  % the adjustment need to be done later, to ensure the success of circle detection
    gray=imcrop(gray,rect);
    cropped=imresize(gray,[uniformSize,uniformSize]);
    cropped(mask)=255;
    % nonlinear gamma correction is the KEY!
    cropped=gammaCorrection(cropped,3.0);
    cropped=imbinarize(cropped);
    
    % morphological process
    se=strel('disk',1);
    cropped=imopen(cropped,se);
    output=bwareaopen(cropped,6);
end

function output=gammaCorrection(input,gamma)
    % output an image with gamma correction.
    output=im2double(input).^gamma;
end