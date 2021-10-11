function [I]=myPlot(ImSize,positions)
% plot the points of certain (x,y) coordinates on Image of given size (ImSize).
% require positions to be of size n*2 list, ImSize 1*2.
I=zeros(ImSize);
rounded=round(positions);
for index=1:size(positions,1) % ugly grammar, can't use array index
    I(rounded(index,1),rounded(index,2))=1;
end
% fprintf("total %d particles",size(positions,1));
end