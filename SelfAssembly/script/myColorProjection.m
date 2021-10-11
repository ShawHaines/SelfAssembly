function color=myColorProjection(value,map,range)
% projects a value within given range to a color rgb triplet.
% the colormap is given by the map as a n*3 matrix, uses linear projection
% method.

% if overflowed, default is to use the upper(lower) limit.
if value>range(2)
    color=map(end,:);
    return
elseif value<range(1)
    color=map(1,:);
    return
end
x=linspace(range(1),range(2),size(map,1));
color=interp1(x,map,value);
end
