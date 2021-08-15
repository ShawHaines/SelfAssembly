function v=neighborVertices(DT,i)
    % returns a sorted list of neighbor vertices contiguous to given vertex id i
    % in Delaunay Triangulation DT.
    triangles=DT.vertexAttachments(i);
    vertices=DT.ConnectivityList(triangles{:},:);
    % now a unique list. Note the list also includes vertex i itself.
    v=unique(reshape(vertices,[],1));
    v=v(v~=i); % exclude vertex i itself.
end
