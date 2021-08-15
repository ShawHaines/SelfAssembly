function v=bondsOrientation(DT,i)
    % returns a n*1 column vector, n is the number of nearest neighbor.
    % i.e. degrees
    bondList=bonds(DT,i);
    v=atan2(bondList(:,2),bondList(:,1));
end