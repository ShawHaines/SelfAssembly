clearvars;
close all;
folder="G:\CUPT Data\ÂÁÇò 0.503 55Hz ±ägamaÊ±Ðò";
yu=115;
oldPath=pwd;
cd(folder);
list=dir('*.MOV');
cd(oldPath);
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(length(temp));
    baseName=erase(fileName,"."+extName);
%     if ~exist(folder+"\"+baseName)
        VideoRead_Evolution;
%     end
    Evolution;
    clearvars -except list loop yu folder;% memory management
    close all;
end
fprintf("Work done.\n");
