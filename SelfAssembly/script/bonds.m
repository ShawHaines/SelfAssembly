function v=bonds(DT,i)
    % returns a n*2 matrix, n is the number of degrees of vertex i.
    v=DT.Points(neighborVertices(DT,i),:)-DT.Points(i,:);
end