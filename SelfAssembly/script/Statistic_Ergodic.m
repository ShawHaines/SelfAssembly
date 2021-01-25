%% Preparations
folder="C:\CUPT Raw\Single Particle\œ∏∞Ù 55Hz ±‰Gamma";
oldPath=pwd;
list=dir(folder);
%% filter according to date
tlower=datetime(2019,8,4);
tupper=datetime;%now
%% Main Loop
for loop=3:length(list)% exclude "." and ".." directory.
    if list(loop).isdir
        baseName=list(loop).name;
        temp=dir(folder+'\\'+list(loop).name+"\\*.mat");
        dataName=temp(1).name;
        Process_Ergodic;
        clearvars -except list folder loop;% memory management
        close all hidden;
    end
end
%% Clean Up
fprintf("Work done.\n");
        