%% Preparation and parameter setup
%close all
tic

jpgList=dir(folder+"/"+baseName+"\\*.jpg");
sampleSize=length(jpgList);
yu=130; % threshold
% if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=false;

% the diameter of particles, unit in mm.
% Aluminium 19.54 +- 0.30*3, Copper 19.38 +- 0.18*3, Iron 19.38 +- 0.23*3
D=19.38;
% the interparticle distance when ordered.
dD=0.036*D;% ratio: Aluminium 0.046, iron 0.036, copper 0.027 
%% initializing
totNum=zeros(sampleSize,1);% number of total particles.
number=zeros(sampleSize,1);% number of ordered particles.
ratio=zeros(sampleSize,1); % ratio of ordered particles.
center=cell(sampleSize,1);
t=zeros(sampleSize,1);
%% main loop
for i=1:sampleSize
    I=imread(jpgList(i).folder+"/"+jpgList(i).name); % string concatenation.
    gray=rgb2gray(I);
    % imhist(gray); % according to the histogram of the image, decide the
    % threshold, filter out the peak of dark plate.
    A=imbinarize(gray,yu/255);
    [imgWidth,imgHeight]=size(A);
    if ACTIVATEPLOT
         figure,imshow(A);
         hold on  % useful in plot
    end
    
    % extract the infos about the centroid and radius.
    stats = regionprops('table',A,'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
    [center{i}]=GranuleRecognition(stats);
    

   [a,~]=size(center{i});
   totNum(i)=a;
   if ACTIVATEPLOT % plotting beads for checking
        % all the beads recognized.
        plot(center{i}(:,1),center{i}(:,2),'cx','LineWidth',1,'MarkerSize',7)
   end
% the distribution of beads.
   R=zeros(a,1);
   for j=1:a
       R(j)=(center{i}(j,1)-imgWidth/2)^2+(center{i}(j,2)-imgHeight/2)^2;
   end
   maxR=max(R);

% return the list of nearest neighbors for each particle.
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
       if rMean(j)<D+dD && n(j,1)==6 && R(j)<=(24*D)^2 % the determinant conditions about the ordered structure:
           % 1. average distance of nearest neighbours are within certain
           % range.
           % 2. the number of nearest neighbours is 6.
           % 3. the distance from center is not too large.
           if ACTIVATEPLOT
                % the beads that is the center of a hexagonal kernel.
                plot(center{i}(j,1),center{i}(j,2),'b+','LineWidth',1,'MarkerSize',7);
                hold on  % Plot the points when the results are strange.
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
   number(i)=length(orderList)-1; % count the number of ordered granules, necessary to save, excluding index 0.
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
   ratio(i)=number(i)/a*100; % necessary to save it.
end
%% output.
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
ylabel('Ratio (%)');
axis([0,max(t),0,100]);
title('the ratio of hexagonal close packing granules versus time') % save the figure anyway, though there might be some problems.
% save at directory folder/baseName/
saveas(gcf,folder+"/"+baseName+"/"+max_ratio+".fig");
save(folder+"/"+baseName+"/"+max_ratio+".mat");
fprintf("Saved data in %s\\%f.fig, %f.mat.\n",pwd,max_ratio,max_ratio);
toc