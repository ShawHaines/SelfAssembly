tic
img=imread(folder+"\\"+baseName+"\\1.jpg");
img=im2bw(img,yu/255);
[shuiping,shuzhi]=size(img);
D=19.54;
dr=3*D;% what is this for?
buchang=0.2;%����ֲ�ͼ��ʱ��ȡ�Ĳ���
% figure,imshow(img)

%ȡ���ĺͰ뾶
stats = regionprops('table',img,'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
center=GranuleRecognition(stats,shuiping,shuzhi);

% plot(center(:,1),center(:,2),'b+','LineWidth',1,'MarkerSize',7)%��ǳ�ÿ����ʶ���������ģ������ж���û�����ظ���ǣ�
[b,~]=size(center);
% hold off

%С��ֲ�λ��
R=zeros(b,1);
for i=1:b
    R(i)=(center(i,1)-shuiping/2)^2+(center(i,2)-shuzhi/2)^2;
end


for i=1:shuiping
   for j=1:shuzhi
       position(i,j)=(i-shuiping/2)^2+(j-shuzhi/2)^2;
   end
end

%�����ɫ
B=drawCircles(center,D,shuiping,shuzhi);
%    imshow(B);

%���������
n=zeros(ceil(24*D/buchang)+1,2);%density
[stepSize,~]=size(n);

%Improved method, runs 6 times as fast as the original one.
for i=1:shuiping
    for j=1:shuzhi
        if B(i,j)==1
            position(i,j)=sqrt(position(i,j));
            timeMax=floor((position(i,j)+dr/2-D)/buchang)+1;
            timeMin=ceil((position(i,j)-dr/2-D)/buchang)+1;
            timeMin=max(1,timeMin);
            timeMax=min(stepSize,timeMax);
            for time=timeMin:timeMax
                n(time,2)=n(time,2)+1;
            end
        end
    end
end

for time=1:stepSize
    r=D+(time-1)*buchang;
    if r<dr/2
        ds=pi*((r+dr/2)^2);
    elseif r>25*D-dr/2
        ds=pi*((25*D)^2-(r-dr/2)^2);
    else
        ds=(2*pi*r*dr);
    end
    n(time,2)=n(time,2)/ds/0.91;
    n(time,1)=r/D;
end

figure,
plot(n(:,1),n(:,2))
xlabel('r/D')
ylabel('�ֲ������')
axis([0,25,0,1.2])
title('�ֲ��������뾶�ֲ�')
oldPath=pwd;
cd(folder+"\\"+baseName);
saveas(gcf,"Density.fig");
fprintf("Saved data in %s\\Density.fig.\n",pwd);
cd(oldPath);
toc

function [B]=drawCircles(center,D,shuiping,shuzhi)
    [b,~]=size(center);
    B=zeros(shuiping,shuzhi);
    for i=1:b
           for j=-D/2:D/2
                ylim=(sqrt(D*D/4-j*j));
                x=fix(center(i,1)+j);
                if x<=0||x>shuiping continue;end
                for k=-ylim:ylim
                    y=fix(center(i,2)+k);
                    if y>0 && y<=shuzhi
                        B(x,y)=1;
                    end
                end
           end
    end
end