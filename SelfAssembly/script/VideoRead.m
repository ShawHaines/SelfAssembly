% if (folder=="")
%    folder="J:/CUPT Data/铝球 变填充率 55Hz 1.40";
% end
% if (fileName=="")
%    fileName="0.608.MOV";
% end
oldPath=pwd;

cd(folder);

vid1=VideoReader(fileName);
mkdir(baseName)
cd(baseName)
i=1;
FrameSize=25;
if vid1.Duration<2.5
    vid1.CurrentTime=0;
else
    vid1.CurrentTime=vid1.Duration-2.5;%the last 2.5 seconds. Avoid shaking in the last.
end
rect=zeros(1,4);
rect(3)=vid1.Height;
rect(4)=vid1.Height;
rect(2)=0;
rect(1)=(vid1.Width-rect(3))/2;
%frame=zeros(FrameSize,vid1.Width,vid1.Height);%reserve an array
while hasFrame(vid1)&& i<=FrameSize*2
    frame=readFrame(vid1);
    %imshow(frame);
    if mod(i,2)==0
        frame=imcrop(frame,rect);
        imwrite(frame,i/2+".jpg");
    end
    i=i+1;
end
cd(oldPath);
fprintf("video extracted in %s\\%s.\n",folder,baseName)