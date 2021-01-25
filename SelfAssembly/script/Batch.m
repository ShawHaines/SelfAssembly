%% Preparations
clearvars;
close all;
folder="D:\CUPT Raw\Rod\Բ�α߽�\�ְ� 0.776 55Hz ��Gamma û�ص�";
yu=130;
oldPath=pwd;
cd(folder);
list=dir('*.MOV');

%% Batch Loop
cd(oldPath);
for loop=1:length(list) % this loop name is to avoid name conflicts with VideoRead etc.
    fileName=list(loop).name;
    temp=split(fileName,'.');
    extName=temp(length(temp));
    baseName=erase(fileName,"."+extName);
    if ~exist(folder+"\"+baseName)
        VideoRead_Ultimate;
        BW_TimeLapse;
    end
%     TimeCorrelation_Ratio_Enhanced;
%     DensityDistribution;
    clearvars -except list loop yu folder;% memory management
    close all;
end
fprintf("Work done.\n");
