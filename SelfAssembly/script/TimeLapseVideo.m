oldPath=pwd;
cd(folder+'/'+baseName);

FrameSize=20;
light=1/FrameSize;
% Stores the most recent 25 frames.
A=cell(1,FrameSize);
i=1; j=1;
imageName=i+".jpg";
full=false;
%% Setup Video Writer
videoName=char("TimeLapse_"+FrameSize+".avi");
writer=VideoWriter(videoName);
writer.FrameRate=25;
open(writer);
%% Read images in a ring buffer.
tic;
while exist(imageName,"file")
    I=imread(imageName);
    if full
        K=K-A{j}*light;
        A{j}=imbinarize(rgb2gray(I));
        K=K+A{j}*light;
        K(K>1)=1;
        K(K<0)=0;
        writeVideo(writer,K);
    else
        A{j}=imbinarize(rgb2gray(I));
    end
    if i==FrameSize
        full=true;
        % The mean of pictures in cells
        K=zeros(size(A{1}));
        for temp=1:FrameSize
            K=K+A{temp}*light;
        end
%         imshow(K);
        % Strange that the console keeps telling me the values are out of
        % range.
        K(K>1)=1;
        K(K<0)=0;
        writeVideo(writer,K);
    end
    i=i+1 % reminds the progress.
    imageName=i+".jpg";
    j=mod(i-1,FrameSize)+1;
end
close(writer);
fprintf("output in %s\\TimeLapse.avi.\n",pwd);
cd(oldPath);
toc