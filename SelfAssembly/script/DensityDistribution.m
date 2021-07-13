% DensityDistribution.m
% Plot the filling ratio against the distance from the center.

tic
img=imread(folder+"\\"+baseName+"\\1.jpg");
img=im2bw(img,yu/255);
[imgWidth,imgHeight]=size(img);
D=19.54;
dr=3*D;% what is this for?
buchang=0.2;% the step length when calculating the distribution graph.
% figure,imshow(img)

% extract the centroid and radius.
stats = regionprops('table',img,'Centroid','MajorAxisLength','MinorAxisLength','Image','EquivDiameter');
center=GranuleRecognition(stats);

% plot(center(:,1),center(:,2),'b+','LineWidth',1,'MarkerSize',7) % mark the centers of the identified beads, (for checking repeated markings.)
[b,~]=size(center);
% hold off

% the radial distanaces of particles
R=zeros(b,1);
for i=1:b
    R(i)=(center(i,1)-imgWidth/2)^2+(center(i,2)-imgHeight/2)^2;
end


for i=1:imgWidth
   for j=1:imgHeight
       position(i,j)=(i-imgWidth/2)^2+(j-imgHeight/2)^2;
   end
end

% filling the white color.
B=drawCircles(center,D,imgWidth,imgHeight);
%    imshow(B);

% calculating the filling ratio.
n=zeros(ceil(24*D/buchang)+1,2);% density
[stepSize,~]=size(n);

% Improved method, runs 6 times as fast as the original one.
for i=1:imgWidth
    for j=1:imgHeight
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
ylabel('local filling ratio')
axis([0,25,0,1.2])
title('local filling ratio versus radial distance')
oldPath=pwd;
cd(folder+"\\"+baseName);
saveas(gcf,"Density.fig");
fprintf("Saved data in %s\\Density.fig.\n",pwd);
cd(oldPath);
toc

%% functions
function [B]=drawCircles(center,D,imgWidth,imgHeight)
    % draw Circles with diameter D, centers given in each row.
    % Outputs a binary image B, with size given as imgWidth and imgHeight.
    % Offers boundary check 
    [b,~]=size(center);
    B=zeros(imgWidth,imgHeight);
    for i=1:b
           for j=-D/2:D/2
                ylim=(sqrt(D*D/4-j*j));
                x=fix(center(i,1)+j);
                if x<=0||x>imgWidth continue;end
                for k=-ylim:ylim
                    y=fix(center(i,2)+k);
                    if y>0 && y<=imgHeight
                        B(x,y)=1;
                    end
                end
           end
    end
end