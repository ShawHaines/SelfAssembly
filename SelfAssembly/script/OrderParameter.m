% orderParameter.m
% Based on the tracing data `.mat`, output a video or figure that visualize
% the kernels that form a hexagonal close pack. The parameters are like the
% ones in localOrientationOrder.m
function lastFrameIndex=orderParameter(dataPath,savePath,baseName)
%% Preparation and parameter setup
% close all

% the diameter of particles, unit in mm.
% Aluminium 19.54 +- 0.30*3, Copper 19.38 +- 0.18*3, Iron 19.38 +- 0.23*3
D=19.38;
% the interparticle distance when ordered.
dD=0.036*D;% ratio: Aluminium 0.046, iron 0.036, copper 0.027

% if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=true;
tic;
saveBase=sprintf("%s/%s_orderParameter",savePath,baseName);
% if exist('ACTIVATEPLOT','var')~=0 && ACTIVATEPLOT
%     figure;
%     writer=VideoWriter(char(saveBase+".avi")); % Strange that it does not seem to support string.
%     writer.FrameRate=25.0;
%     open(writer);
% end
%% load data
load(dataPath);
% sampleSize=size(center,1);
sampleSize=1;
sourceCount=size(center{1},1);
sidelength=1050/2;

centerArray=zeros([sampleSize,sourceCount,2]);
velocity=zeros([sampleSize-1,sourceCount,2]);
centerArray(1,:,:)=center{1};
% FIXME: There might be NaNs, be careful about how to deal with them.
for i=2:sampleSize
    centerArray(i,:,:)=center{i};
    velocity(i-1,:,:)=centerArray(i,:,:)-centerArray(i-1,:,:); % unit in pixels.
end
%% visualization
% orderList=zeros([sampleSize,sourceCount]); % the center and the vicinity of a hexagon
% kernelList=zeros([sampleSize,sourceCount]);% the center of a hexagon
rBarList=zeros([sampleSize,sourceCount]); % the mean bond length of a vertex.
for frameIndex=1:sampleSize
    % orientation order
    DT=delaunayTriangulation(centerArray(frameIndex,:,1)',centerArray(frameIndex,:,2)');
    % accept id as a column vector.
    meanBondLengthFunction=@(id) mean(vecnorm(bonds(DT,id),2,2),'omitnan');
    rBar=arrayfun(meanBondLengthFunction,1:size(DT.Points,1));
    rBarList(frameIndex,:)=rBar;
    
    if ACTIVATEPLOT
        figure;
        hold off;
        scatter(centerArray(frameIndex,:,1),centerArray(frameIndex,:,2),16,abs(rBar),'filled');
        hold on;
        viscircles([sidelength+0.5,sidelength+0.5],sidelength);
        caxis([20,40]);
        bar=colorbar;
        colormap jet;
        bar.Label.Interpreter="latex";
        bar.Label.String="$\bar{r}$";
        axis ij;
        axis equal;
        savefig(gcf,saveBase+".fig",'compact');
%         drawnow;
%         writeVideo(writer,getframe(gcf));
    else
        frameIndex % display the progress...
    end
end
%%
% if ACTIVATEPLOT
%     close(writer);
%     fprintf("Saved data in %s.avi.\n",saveBase);
% end
lastFrameIndex=frameIndex;
% there might be empty cells in the tail of the cell array.
rBarList=rBarList(1:lastFrameIndex,:);
% save(saveBase+".mat",'rBarList');
% fprintf("Saved data in %s.mat\n",saveBase);
fprintf("finished.\n");
toc
end