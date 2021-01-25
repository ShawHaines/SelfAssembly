%close all
tic

jpgList=dir(folder+'\\'+baseName+"\\*.jpg");
sampleSize=length(jpgList);
% yu=130; %��ֵ
%if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=false;
oldPath=pwd;
cd(folder+"/"+baseName);

totNum=zeros(sampleSize,1);% number of total particles.
number=zeros(sampleSize,1);% number of ordered particles.
ratio=zeros(sampleSize,1); % ratio of ordered particles.
center=cell(sampleSize,1);
t=zeros(sampleSize,1);

%С��ֱ��,����19.54��0.30*3��ͭ��19.38��0.18*3, ����19.38��0.23*3
D=19.54;
dD=0.046*D;%����:���� 0.046������ 0.036, ͭ��0.027 ����ѻ�ʱ�����Ӽ��


for i=1:sampleSize
    I=imread(jpgList(i).name);
    A= im2bw(I,yu/255);
    [shuiping,shuzhi]=size(A);
    if ACTIVATEPLOT
         figure,imshow(A)
         hold on  %plot���ʱ����
    end
    
    %ȡ���ĺͰ뾶
    stats = regionprops('table',A,'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
    [center{i}]=GranuleRecognition(stats,shuiping,shuzhi);
    

   [a,b]=size(center{i});
   totNum(i)=a;
   if ACTIVATEPLOT
        plot(center{i}(:,1),center{i}(:,2),'cx','LineWidth',1,'MarkerSize',7)% plotting
   end
%С��ֲ�
   R=zeros(a,1);
   for j=1:a
       R(j)=(center{i}(j,1)-shuiping/2)^2+(center{i}(j,2)-shuzhi/2)^2;
   end
   maxR=max(R);

%��������
   TRI=delaunay(center{i}(:,1),center{i}(:,2));
   [a1,b1]=size(TRI);
   n=zeros(a,1);% the number of adjacent particles.
   index=cell(a,1);% the index of adjacent particles.
   % cell's default value is an empty matrix, so handy!
   for j=1:a1
      for k=1:3
          idx=TRI(j,k); % the index of the current point(of the delaunay triangle)
          for m=1:3
              if m~=k
                  index{idx}(end+1)=TRI(j,m);% insert at the end directly.
              end
          end
      end
   end
   for j=1:a
       index{j}=unique(index{j});% filter repetition values. used a set 
       n(j)=length(index{j});
   end
   r=cell(a,1);
   rMean=zeros(a,1);
   for j=1:a
       l=length(index{j});
       r{j}=zeros(1,l);
       for k=1:l
           idx=index{j}(k);
           r{j}(k)=sqrt((center{i}(j,1)-center{i}(idx,1))^2+(center{i}(j,2)-center{i}(idx,2))^2);
       end
       rMean(j)=mean(r{j});
   end
%    x=zeros(a,2,25);% what is this x for?
   orderList=zeros(20*a,1); % the center and the vicinity of a hexagon
   kernelList=zeros(a,1);% the center of a hexagon
   orderStack=0;kernelStack=0;% stack position indicator
   for j=1:a
       if rMean(j)<D+dD && n(j,1)==6 && R(j)<=(24*D)^2 %�ж��Ƿ��γ�����ṹ������
           if ACTIVATEPLOT
                plot(center{i}(j,1),center{i}(j,2),'b+','LineWidth',1,'MarkerSize',7)
                hold on  %��ʱ������ܳ����Ľ����ֵĻ��Ͱѵ�plotһ�¿���
           end            
            orderStack=orderStack+1;
            kernelStack=kernelStack+1;
            orderList(orderStack)=j;% also insert at the back directly. A little ineffective.
            kernelList(kernelStack)=j;
            for k=1:n(j)% usually n(j) is 6.
                orderStack=orderStack+1;
                orderList(orderStack)=index{j}(k);
            end
%            x(number(i),1,i)=j;
%            x(number(i),2)=r(j,1,i);
       end
   end
   orderList=unique(orderList);% another filtering step, there's a 0 left.
   number(i)=length(orderList)-1; %ͳ���γ�����ṹ����������Ҫ��������, need to exclude 0.
   if ACTIVATEPLOT
       % plotting orderList
       for k=1:number(i)
           j=orderList(k);
           if j>0
                plot(center{i}(j,1),center{i}(j,2),'ro','LineWidth',1,'MarkerSize',7);      
           end
       end
       hold off;
   end
   ratio(i)=number(i)/a*100; %��Ҫ��������
end

for i=1:sampleSize
    base=erase(jpgList(i).name,'.jpg');
    t(i)=sscanf(base,"%f",1);
end
max_ratio=max(ratio)
% a necessary step: sort by t
sortedT=sortrows([t,ratio]);
t=sortedT(:,1);
ratio=sortedT(:,2);

figure, plot(t,ratio)
xlabel('t(s)');
ylabel('ռ�ȣ�%��');
axis([0,max(t),0,100]);
title('�γ������ܶ�����ռ����ʱ��仯ͼ') %���ͼ��һ���ȣ���Ȼ�����е�С����
saveas(gcf,max_ratio+".fig");
save(max_ratio+".mat");
fprintf("Saved data in %s\\%f.fig, %f.mat.\n",pwd,max_ratio,max_ratio);
cd(oldPath);
toc