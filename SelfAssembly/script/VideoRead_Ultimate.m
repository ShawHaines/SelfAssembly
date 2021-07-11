%% Preparations and Definitions
close all;
% You can adjust it manually.
uniformSize=1050; % somewhat legacy... Just don't touch it...

oldPath=pwd;
cd(folder);
vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)

%% Auto Recognize Circle and Cropping
frame=readFrame(vid1);% resize to exactly 1080 pixels high.
frame=imresize(frame,[1080,NaN]);
bw=imbinarize(rgb2gray(frame));
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

%% Output Frames
tic;
i=1;
while hasFrame(vid1)
    frame=readFrame(vid1);
    frame=imresize(frame,[1080,NaN]);
    %imshow(frame);
    cropped=imresize(imcrop(frame,rect),[uniformSize,uniformSize]);
    imwrite(cropped,i+".jpg");
    i=i+1;
end

cd(oldPath);
toc
fprintf("video extracted in %s\\%s.\n",folder,baseName);