close all;
% You can adjust it manually.
uniformSize=1050;

oldPath=pwd;
cd(folder);
vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)

FrameSize=25;

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