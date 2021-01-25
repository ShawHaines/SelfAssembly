oldPath=pwd;
cd(folder+'/'+baseName)

FrameSize=25;
light=1/FrameSize;

for i=1:FrameSize
    imageName=i+".jpg";
    I=imread(imageName);
    A=imbinarize(rgb2gray(I));
    if i==1
        [sizeX,sizeY]=size(A);
        K=zeros(sizeX,sizeY);
    end
    K=K+light*A;
end
imwrite(K,'tot.png','png');
fprintf("output in %s\\tot.png.\n",pwd);
cd(oldPath);