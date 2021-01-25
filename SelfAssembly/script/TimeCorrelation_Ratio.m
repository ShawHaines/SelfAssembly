%close all
%clear all
tic
I=cell(1,25);
A=cell(1,25);
% yu=130; %��ֵ

oldPath=pwd;
cd(folder+"/"+baseName);

ratio=zeros(25,1);
totNum=zeros(25,1);
number=zeros(25,1);
for i=1:25
    imageName=i+".jpg";
    I{i}=imread(imageName);
    A{i}= im2bw(I{i},yu/255);
    [shuiping,shuzhi]=size(A{i});
%      figure,imshow(A{i})
%      hold on  %plot���ʱ����
    
    %ȡ���ĺͰ뾶
    stats = regionprops('table',A{i},'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    j=1;
    [a,b]=size(radii);
    center=zeros(a,b);
    radi=zeros(a,1);
    %ȥ�����ظ���ǵ���
    for i1=1:a
        if (radii(i1)<10) && radii(i1)>0.5 && ((centers(i1,1)-shuiping/2)^2+(centers(i1,2)-shuzhi/2)^2)<490^2 %500��Ϊ�����������ڣ��Ǹ���Ҫ�޸ĵĲ���
           if j==1 
              center(j,1)=centers(i1,1);
              center(j,2)=centers(i1,2); 
              radi(j)=radii(i1);
              j=j+1;
           end
           if j>1
              for k=1:j-1
                  if ((centers(i1,1)-center(k,1))^2+( centers(i1,2)-center(k,2))^2<15^2)
                      k=k-1;
                      break
                  end
              end
              if k==j-1
                 center(j,1)=centers(i1,1);
                 center(j,2)=centers(i1,2);
                 radi(j)=radii(i1);
                 j=j+1;
              end
           end
        end
    end
    center=center(1:j-1,:);
    radi=radi(1:j-1,:);


   [a,b]=size(radi);
   totNum(i)=a;
%     plot(center(:,1),center(:,2),'b+','LineWidth',1,'MarkerSize',7)% plotting
%С��ֲ�, seems something wrong?
   for i1=1:a
       R(i1)=(center(i1,1)-shuiping/2)^2+(center(i1,2)-shuzhi/2)^2;
   end
   max=R(1);
   for i1=2:a
       if R(i1)>max
           max=R(i1);
       end
   end

%��������
   TRI=delaunay(center(:,1),center(:,2));
   [a1,b1]=size(TRI);
   n=zeros(a,20);% what is this n? The number of surrounding granules
   for j2=1:a1
       for k=1:3
           if n(TRI(j2,k),1)==0
              for m=1:3
                  if m~=k
                     n(TRI(j2,k),1)=n(TRI(j2,k),1)+1;
                     n(TRI(j2,k),n(TRI(j2,k),1)+1)=TRI(j2,m);
                  end
              end
           end
           if n(TRI(j2,k),1)~=0
               for m=1:3
                   if m~=k
                       for p=2:n(TRI(j2,k),1)+1
                           if TRI(j2,m)==n(TRI(j2,k),p)
                               p=p-1;
                               break
                           end
                       end
                       if p==n(TRI(j2,k),1)+1
                          n(TRI(j2,k),1)=n(TRI(j2,k),1)+1;
                          n(TRI(j2,k),n(TRI(j2,k),1)+1)=TRI(j2,m);
                       end
                   end
               end
           end
       end
   end

   [a2,b2]=size(n);
   r=zeros(a2,b2,25);
   for i1=1:a2
       for j=1:n(i1,1)
           r(i1,j+1,i)=sqrt((center(i1,1)-center(n(i1,j+1),1))^2+(center(i1,2)-center(n(i1,j+1),2))^2);
           r(i1,1,i)=r(i1,1,i)+r(i1,j+1,i);
       end
       r(i1,1,i)=r(i1,1,i)/n(i1,1);
   end
   D=18.6/sqrt(209338)*sqrt(max);%С��ֱ���������̾���ƽ�� 224753�������е�max����Ӧ��19.2�������̾���ƽ����209338��Ӧ��18.6���Լ���һ��һ��
   D=roundn(D,-1);
   dD=0.052*D;%���� 0.052������ 0.033 ����ѻ�ʱ�����Ӽ��
   x=zeros(a,2,i);

   for i1=1:a
       if r(i1,1,i)<D+dD && n(i1,1)==6 && R(i1)<=(24*D)^2 %�ж��Ƿ��γ�����ṹ������
%             plot(center(i1,1),center(i1,2),'b+','LineWidth',1,'MarkerSize',7)
%             hold on  %��ʱ������ܳ����Ľ����ֵĻ��Ͱѵ�plotһ�¿���
           number(i)=number(i)+1; %ͳ���γ�����ṹ����������Ҫ��������
           x(number(i),1,i)=i1;
           x(number(i),2)=r(i1,1,i);
       end
   end
   ratio(i)=number(i)/a*100; %��Ҫ��������
%     hold off
end
ave_ratio=0;
t=zeros(25,1);
for i=1:25
    t(i)=i*0.08;
    ave_ratio=ave_ratio+ratio(i);
end
ave_ratio=ave_ratio/25 %���һ��Ҫ��¼����
figure, plot(t,ratio)
xlabel('t(s)');
ylabel('ռ�ȣ�%��');
axis([0,2,0,100]);
title('�γ������ܶ�����ռ����ʱ��仯ͼ') %���ͼ��һ���ȣ���Ȼ�����е�С����
saveas(gcf,ave_ratio+".fig");
save(ave_ratio+".mat");
fprintf("Saved data in %s\\%f.fig, %f.mat.\n",pwd,ave_ratio,ave_ratio);
cd(oldPath);
toc