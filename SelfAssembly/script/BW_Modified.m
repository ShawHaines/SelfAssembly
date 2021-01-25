FrameNum=25;
I=cell(1,FrameNum);
A=cell(1,FrameNum);
K=cell(1,1);
for i=1:FrameNum
    imageName=strcat('.\video1\video1_',num2str(i),'.jpg');
    I{i}=imread(imageName);
    thresh = graythresh(I{i}); 
    A{i}= imbinarize(I{i},115/255);
end
K=imlincomb(1/FrameNum,A{1});
for i=2:25
    K=imlincomb(1.0,K,0.04,A{i});
end
imwrite(K,'.\video1\tot2.png','png')
