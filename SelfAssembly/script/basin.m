frameIndex=1;
DT=delaunayTriangulation(centerArray(frameIndex,:,1)',centerArray(frameIndex,:,2)');
edgeList=DT.edges;
weightFun=@(a,b) abs(vertexValue(a)-vertexValue(b));
edgeWeight=arrayfun(weightFun,edgeList(:,1),edgeList(:,2));

%% You have to plot the edges yourself...
% And you even have to write a colormap mapping function ...
colormap('jet');
map=colormap;
colorRange=[0,1];
figure;
for e=1:length(edgeWeight)
    color=myColorProjection(edgeWeight(e),map,colorRange);
    ends=DT.Points(edgeList(e,:),:);
    plot(ends(:,1),ends(:,2),'Color',color);
    hold on;
end
axis equal;
caxis(colorRange);
colorbar;
title("Original");
%% find the basin in the center, filter out the edges where abrupt change occur.
allowance=1;
edgeList=edgeList(edgeWeight<allowance,:);
edgeWeight=edgeWeight(edgeWeight<allowance);

figure;
for e=1:length(edgeWeight)
    color=myColorProjection(edgeWeight(e),map,colorRange);
    ends=DT.Points(edgeList(e,:),:);
    plot(ends(:,1),ends(:,2),'Color',color);
    hold on;
end
axis equal;
caxis(colorRange);
colorbar;
title("After cutting off abrupt changes");

% find the largest connected component
G=graph(edgeList(:,1),edgeList(:,2));
% plot(G); % Hmm, interesting...
[bins,binSize]=conncomp(G);
idx=find(binSize(bins)==max(binSize)); % the indices of vertices that should remain.

