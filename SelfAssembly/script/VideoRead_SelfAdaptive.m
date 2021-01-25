close all;
% You can adjust it manually.
uniformSize=1050;

oldPath=pwd;
cd(folder);
vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)

FrameSize=25;
frame=imcrop(readFrame(vid1),[0,0,1920,1080]);%crop the 8 excessive pixels off.
% thresh=adaptthresh(rgb2gray(frame));
% bw=imbinarize(rgb2gray(frame),thresh);
bw=imbinarize(rgb2gray(frame));
figure;
imshow(bw);

bw2=bwareaopen(bw,100000);% get rid of white noise (whose Area is less then 100000pixels.
bw2=~bwareaopen(~bw2,100000);% get rid of black noise

CC = bwconncomp(bw2,4);
stats=regionprops('table',CC,'Area','Centroid','EquivDiameter');
idx=find(~(stats.Area<1000000 & stats.Centroid(:,1)>600 & stats.Centroid(:,1)<1400));
bw2=ismember(labelmatrix(CC), idx);%get rid of the central big white noise(if there's any left)

figure;
imshow(bw2);
stats=regionprops('table',1-bw2,'Centroid','MajorAxisLength','MinorAxisLength','EquivDiameter','Area');
viscircles(stats.Centroid,stats.EquivDiameter/2,'Color','r');
viscircles(stats.Centroid,(stats.MinorAxisLength+stats.MinorAxisLength)/4,'Color','b');
hold on;
plot(stats.Centroid(:,1),stats.Centroid(:,2),'b+');
hold off;


stats=regionprops('table',~bw2,'Centroid','EquivDiameter');
%rect[xmin ymin width height] y is calculated from above
rect=zeros(1,4);
rect(3)=stats.EquivDiameter;%Height.
rect(4)=rect(3);
rect(2)=stats.Centroid(2)-rect(3)/2;
rect(1)=stats.Centroid(1)-rect(3)/2;

% cropped=imresize(imcrop(bw2,rect),[uniformSize,uniformSize]);
% figure;
% imshow(cropped);
% imwrite(cropped,"cropped.jpg");

if vid1.Duration<2.5
    vid1.CurrentTime=0;
else
    vid1.CurrentTime=vid1.Duration-2.5;%the last 2.5 seconds. Avoid shaking in the last.
end

i=1;
while hasFrame(vid1)&& i<=FrameSize*2
    frame=readFrame(vid1);
    %imshow(frame);
    if mod(i,2)==0
        cropped=imresize(imcrop(frame,rect),[uniformSize,uniformSize]);
        imwrite(cropped,i/2+".jpg");
    end
    i=i+1;
end

cd(oldPath);
fprintf("video extracted in %s\\%s.\n",folder,baseName)