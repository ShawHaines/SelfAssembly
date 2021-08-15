oldPath=pwd;

cd(folder);

vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)
i=1;
interval=5;
FrameSize=3000;
vid1.CurrentTime=10;
height=720;
while hasFrame(vid1)&& i<=FrameSize*interval
    frame=readFrame(vid1);
    %imshow(frame);
    if mod(i,interval)==0
        cropped=imresize(imcrop(frame,rect),[height,height]);
        imwrite(cropped,i/interval+".jpg");
    end
    i=i+1;
end
cd(oldPath);
fprintf("video extracted in %s\\%s.\n",folder,baseName)