function v=bonds(DT,i)
    % returns a n*2 matrix, n is the number of degrees of vertex i.
    % bond is a 2d vector that points from vertex i to its neighbour.
    v=DT.Points(neighborVertices(DT,i),:)-DT.Points(i,:);
end