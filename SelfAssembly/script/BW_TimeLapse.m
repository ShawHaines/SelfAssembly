oldPath=pwd;
cd(folder+'/'+baseName)

% yu=130; %��ֵ
FrameSize=25;
light=1/FrameSize; %ÿ��ͼƬ��������

for i=1:FrameSize
    imageName=i+".jpg";
    I=imread(imageName);
    
%     thresh = graythresh(I{i}); 
%     A= im2bw(I,yu/255);
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