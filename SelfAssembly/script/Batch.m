% Preparations
clearvars;
close all;
folder="E:/Video Recordings/ball/aluminium/aluminium sweep_filling 55Hz 1.40/0724";
list=dir(folder+"/*.MOV");
%% Batch Loop
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(end);
    baseName=erase(fileName,"."+extName);
    try
        localOrientationOrder(folder+"/"+baseName+"/"+baseName+"_tracing.mat",folder+"/"+baseName+"/",baseName);
    catch ME
        close all;
        continue;
    end
%     clearvars -except list folder videoTime extractionMode;% memory management
    close all;
end
fprintf("Step finished: VideoRead.\n");
%% filling ratio
% fillingRatio=zeros(length(list),1);
% for loop=1:length(list)
%     temp=sscanf(list(loop).name,"%f");
%     fillingRatio(loop)=temp(1);
% end
