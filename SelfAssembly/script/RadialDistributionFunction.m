%径向分布函数：
img=imread('ball\6.16\su_liao\3097\150Hz\13.jpg');
shuiping=834;
shuzhi=834;
img=im2bw(img,115/255);
[B,L]=bwboundaries(img);
%取圆心和半径
stats = regionprops('table',img,'Centroid','MajorAxisLength','MinorAxisLength','Image');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
j2=1;
[a,b]=size(radii);
c=(rmin(1)+rmax(1))/2;
d=(rmin(2)+rmax(2))/2;
j1=1;
x=(r(1,1)-c)^2+(r(1,2)-d)^2;
for i=2:b
    if (r(i,1)-c)^2+(r(i,2)-d)^2<x
        j1=i;
        x=(r(i,1)-c)^2+(r(i,2)-d)^2;
    end
end
%取中心参考点
[a,b]=size(radi);
for i=1:b
    r(i,1)=center(i,1)-shuiping/2;
    r(i,2)=center(i,2)-shuzhi/2;
end
rmin(1)=r(1,1);
rmax(1)=r(1,1);
rmin(2)=r(1,2);
rmax(2)=r(1,2);
for i=2:b
    if r(i,1)<rmin(1)
        rmin(1)=r(i,1);
    end
    if r(i,2)<rmin(2)
        rmin(2)=r(i,2);
    end
    if r(i,1)>rmax(1)
        rmax(1)=r(i,1);
    end
    if r(i,2)>rmax(2)
        rmax(2)=r(i,2);
    end
end
for i=1:a
    if (radii(i)<10) && radii(i)>0 && ((centers(i,1)-shuiping/2)^2+(centers(i,2)-shuzhi/2)^2)<380^2
        if j2==1
            center(j2,1)=centers(i,1);
            center(j2,2)=centers(i,2);
            j2=j2+1;
        end
        if j2>1
            for k=1:j2-1
                if ((centers(i,1)-center(k,1))^2+( centers(i,2)-center(k,2))^2<5^2)
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