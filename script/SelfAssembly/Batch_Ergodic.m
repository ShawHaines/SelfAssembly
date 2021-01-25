clearvars;
close all;
folder="C:\CUPT Raw\Single Particle\œ∏∞Ù 55Hz ±‰Gamma";
oldPath=pwd;
cd(folder);
list=dir('*.MOV');

%%
cd(oldPath);
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(length(temp));
    baseName=erase(fileName,"."+extName);

    ErgodicTimeLapse;
    
    clearvars -except list loop folder;% memory management
    close all;
end
fprintf("Work done.\n");
