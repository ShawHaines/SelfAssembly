% edgePlot(pointList,edgeList,edgeWeight,map,colorRange)
% Plot the edges given by edgeList, maps `edgeWeight` to colormap `map` as
% the color of the edge.
function edgePlot(pointList,edgeList,edgeWeight,map,colorRange)
for e=1:length(edgeWeight)
    color=myColorProjection(edgeWeight(e),map,colorRange);
    ends=pointList(edgeList(e,:),:);
    plot(ends(:,1),ends(:,2),'Color',color);
    hold on;
end
hold off;
end