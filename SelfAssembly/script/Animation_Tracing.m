% Animation_Tracing.m 
% Visualize the center cell for problems checking.

%% Preparation and parameter setup
% load(folder+"/"+baseName+"_tracing.mat");
tic
sampleSize=length(center);
sourceCount=size(center{1},1);
colorMapping=rand([sourceCount,1]); % colorful labels
% beads with distance values between 2 frames higher than this cannot be viewed as the same one.
vicinityThreshold=40;
sidelength=1050/2;
%% main loop

figure;
writer=VideoWriter(char(folder+"/"+baseName+"_tracing.avi"));  % Strange that it does not seem to support string.
writer.FrameRate=25.0;
open(writer);

for i=1:sampleSize
    % plotting beads for checking
    % all the beads recognized are vertically mirrored so that y=0 starts at the bottom.
    % hold on; % if turned on, the particles would leave a trace, interesting, isn't it?
    if isempty(center{i}) % sometimes there would be empty cells in the tail, due to floating point.
        break
    end
    scatter(center{i}(:,1),sidelength*2+1-center{i}(:,2),16,colorMapping,'filled');
    viscircles([sidelength+0.5,sidelength+0.5],sidelength);
    axis equal;
    colormap jet;
    drawnow;
    writeVideo(writer,getframe(gcf));
end
%% output.
close(writer);
fprintf("Saved data in %s/%s_tracing.avi.\n",folder,baseName);
toc