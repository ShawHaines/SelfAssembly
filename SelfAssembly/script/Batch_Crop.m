%% Preparations
clearvars;
close all;
folder="D:\CUPT Raw\Rod\55Hz 2.97 ±‰ÃÓ≥‰¬ ";
oldPath=pwd;
cd(folder);
list=dir('*.MOV');
%% Cropping
RECT=cell(length(list),1);
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(length(temp));
    baseName=erase(fileName,"."+extName);
    vid1=VideoReader(fileName);
    vid1.CurrentTime=vid1.Duration-2.5; % to avoid shaking.
    frame=readFrame(vid1);
    [~,RECT{loop}]=imcrop(frame);
    close all;
end


%% Output Combined TimeLapse
cd(oldPath);
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(length(temp));
    baseName=erase(fileName,"."+extName);
    rect=RECT{loop};
    VideoRead_NoCrop;
    BW_TimeLapse;
    clearvars -except list loop RECT folder;% memory management
    close all;
end
fprintf("Work done.\n");
