% Tracing.m 
% trace and distinguish the beads.

%% Preparation and parameter setup
%close all
tic

imgList=dir(folder+"/"+baseName+"\\*.png");
sampleSize=length(imgList);
% if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=true;
% beads with distance values between 2 frames higher than this cannot be viewed as the same one.
vicinityThreshold=40; 
%% main loop

% initializing
center=cell(sampleSize,1);
source=NaN; % source is the previous image. 2 labels can converge but no labels will bifurcate.
if ACTIVATEPLOT
    figure;
    writer=VideoWriter(char(folder+"/"+baseName+"/"+baseName+"_tracing.avi")); % Strange that it does not seem to support string.
    writer.FrameRate=25.0;
    open(writer);
end
for i=1:sampleSize
    A=imread(imgList(i).folder+"/"+imgList(i).name);
    % extract the infos about the centroid and radius.
    stats = regionprops('table',A,'Centroid','Area');
    centroid=stats.Centroid(stats.Area<10000,:); % exclude the 4 big white areas on the corners.
    sidelength=size(A,1)/2;
    if isnan(source)
        % the first frame, initialize.
        center{i}=centroid;
        source=center{i}; % sourceCount*2 matrix.
        sourceCount=size(source,1); % the count is fixed from now on.
        colorMapping=rand([sourceCount,1]); % colorful labels
    else
        target=centroid;
        center{i}=zeros(sourceCount,2);
        for j=1:sourceCount % find matches for each bead in source
            distance=vecnorm(target-source(j,:),2,2);
            [minDistance,index]=min(distance);
            if minDistance<vicinityThreshold % successful matching.
                center{i}(j,:)=target(index,:);
            else
                center{i}(j,:)=NaN; % Leave blank.
            end
        end
        % Update source, Leave the NaN with the last known location.
        validIndices=~isnan(center{i});
        source(validIndices)=center{i}(validIndices);
    end
    if ACTIVATEPLOT % plotting beads for checking
        % all the beads recognized.
        % vertically mirrored so that y=0 starts at the bottom.
        % imshow(A);
        % hold on; % if turned on, interesting things would happen...
        scatter(center{i}(:,1),sidelength*2+1-center{i}(:,2),16,colorMapping,'filled');
        viscircles([sidelength+0.5,sidelength+0.5],sidelength);
        axis equal;
        colormap jet;
        drawnow;
        writeVideo(writer,getframe(gcf));
    end
end
%% output.
if ACTIVATEPLOT
    close(writer);
    fprintf("Saved data in %s/%s_tracing.avi.\n",folder+"/"+baseName,baseName);
end
fprintf("finished.\n");
toc