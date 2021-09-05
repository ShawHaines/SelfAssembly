% localOrientationOrder.m
% Based on the tracing data `.mat`, output a video that visualize local orientation order.
% For more information about local orientation order, see the .mlx file and
% the markdown file. (Basically all copied from `test.mlx`)
function lastFrameIndex=localOrientationOrder(dataPath,savePath,baseName)
% if true, it will plot the granules and the image to assist revision
ACTIVATEPLOT=true;
saveBase=sprintf("%s/%s_localOrientationOrder",savePath,baseName);
if exist('ACTIVATEPLOT','var')~=0 && ACTIVATEPLOT
    figure;
    writer=VideoWriter(char(saveBase+".avi")); % Strange that it does not seem to support string.
    writer.FrameRate=25.0;
    open(writer);
end
%% load data
load(dataPath);
sampleSize=size(center,1);
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
psi6List=zeros([sampleSize,sourceCount]);
for frameIndex=1:sampleSize
    % orientation order
    DT=delaunayTriangulation(centerArray(frameIndex,:,1)',centerArray(frameIndex,:,2)');
    % accept id as a column vector.
    orientationalOrder=@(id) mean(exp(1i*6*bondsOrientation(DT,id)),'omitnan');
    psi6=arrayfun(orientationalOrder,1:size(DT.Points,1));
    psi6List(frameIndex,:)=psi6;
    if ACTIVATEPLOT
        hold off;
        scatter(centerArray(frameIndex,:,1),centerArray(frameIndex,:,2),16,abs(psi6),'filled');
        hold on;
        viscircles([sidelength+0.5,sidelength+0.5],sidelength);
        caxis([0,1]);
        bar=colorbar;
        colormap jet;
        bar.Label.String="|\psi_6|";
        axis ij;
        axis equal;
        drawnow;
        writeVideo(writer,getframe(gcf));
    else
        frameIndex % display the progress...
    end
end
%%
if ACTIVATEPLOT
    close(writer);
    fprintf("Saved data in %s.avi.\n",saveBase);
end
lastFrameIndex=frameIndex;
% there might be empty cells in the tail of the cell array.
psi6List=psi6List(1:lastFrameIndex,:);
save(saveBase+".mat",'psi6List');
fprintf("Saved data in %s.mat\n",saveBase);
fprintf("finished.\n");
toc
end