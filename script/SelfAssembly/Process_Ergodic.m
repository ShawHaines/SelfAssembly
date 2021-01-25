%% Preparations & Definitions
oldPath=pwd;
cd(folder+"/"+baseName);
mat=load(dataName);
sheetName=erase(baseName,["[","]"]);% sheetName requires not to appear '[]*?:/'
close all hidden;
%% Extract data
rodTable=zeros(mat.FrameSize+1,6);% the first column is t
j=0;
for i=1:length(mat.rodStatus)
    if isa(mat.rodStatus{i},'table')
        j=j+1;
        rodTable(j,1)=(i-1)/mat.vid1.FrameRate;
        rodTable(j,2:6)=table2array(mat.rodStatus{i});
    end
end
%% Write and Clean Up
cd(folder);
xlswrite("Ergodic.xls",rodTable,sheetName,'A1');
fprintf("Extracted %s in %s.\n",dataName,pwd);
cd(oldPath);