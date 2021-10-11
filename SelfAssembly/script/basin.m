% idx=basin(x,y,vertexValue,allowance)
% Find the largest basin (that is, the change of `vertexValue` on an edge is
% smaller than allowance) of a given point set (x,y).
function idx=basin(x,y,vertexValue,allowance)
DT=delaunayTriangulation(x,y);
edgeList=DT.edges;
weightFun=@(a,b) abs(vertexValue(a)-vertexValue(b));
edgeWeight=arrayfun(weightFun,edgeList(:,1),edgeList(:,2));

%% find the basin in the center, filter out the edges where abrupt change occur.
% allowance=1;
edgeList=edgeList(edgeWeight<allowance,:);
% edgeWeight=edgeWeight(edgeWeight<allowance);

% find the largest connected component
G=graph(edgeList(:,1),edgeList(:,2));
% plot(G); % Hmm, interesting...
[bins,binSize]=conncomp(G);
idx=find(binSize(bins)==max(binSize)); % the indices of vertices that should remain.
end