% Experimental try for delaunay function
clear all
close all
tic
img=imread('video1\sample.jpg');
yuzhi=75;
img=im2bw(img,yuzhi/255);
[shuiping,shuzhi]=size(img);
figure,imshow(img);
% [B,L]=bwboundaries(img);

%ȡ���ĺͰ뾶
stats = regionprops('table',img,'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
% rad=stats.EquivDiameter;
% dr=rad-diameters;
figure,imshow(img)
hold on
D=13;%С��ֱ������ͬ��������������Ҫ�޸ģ�һ����һ��order�ľ���ֲ����������ҵ����ķ�ֵ��λ�þ���С��ֱ����
j2=1;
[a,b]=size(radii);
%ȥ�����ظ���ǵ���
for i=1:a
    if (radii(i)<D/2) && radii(i)>0 && ((centers(i,1)-shuiping/2)^2+(centers(i,2)-shuzhi/2)^2)<320^2 %320��Ϊ�����������ڣ��Ǹ���Ҫ�޸ĵĲ���
        if j2==1 
           center(j2,1)=centers(i,1);
           center(j2,2)=centers(i,2); 
           j2=j2+1;
        end
        if j2>1
           for k=1:j2-1
               if ((centers(i,1)-center(k,1))^2+( centers(i,2)-center(k,2))^2<9^2)
                   k=k-1;
                  break
               end
           end
            if k==j2-1
               center(j2,1)=centers(i,1);
               center(j2,2)=centers(i,2);
               radi(j2)=radii(i);
               j2=j2+1;
            end
        end
    end
end
% viscircles(center,radi);
plot(center(:,1),center(:,2),'b+','LineWidth',1,'MarkerSize',7);%��ǳ�ÿ����ʶ���������ģ������ж���û�����ظ���ǣ�
[a,b]=size(radi);
% for i=1:b
%     if radi(i)<1.5
%         plot(center(i,1),center(i,2),'b+','LineWidth',1,'MarkerSize',7);
%         hold on
%     end
% end


Tri = delaunay(center(:,1),center(:,2));
triplot(Tri,center(:,1),center(:,2));
hold off
toc