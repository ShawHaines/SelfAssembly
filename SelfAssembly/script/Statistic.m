%% Preparations
folder="G:\CUPT Data\ÂÁÇò ±äÌî³äÂÊ 55Hz 1.40";
oldPath=pwd;
list=dir(folder);
avr=zeros(60,2);
j=0;
%% filter according to date
tlower=datetime(2019,8,4);
tupper=datetime;%now
%% Main Loop
for i=3:length(list)% exclude "." and ".." directory.
    if list(i).isdir
        j=j+1;
        avr(j,1)=sscanf(list(i).name,"%f",1);
        temp=dir(folder+'\\'+list(i).name+"\\*.mat");
        for k=1:length(temp)
            % if there's not so much disturbance, you can ignore this step.
            if isbetween(temp(k).date,tlower,tupper)                
                base=erase(temp(k).name,'.mat')
                avr(j,2)=str2double(base);
            end
        end
        
    end
end
%% Clean Up
fprintf("Work done.\n");
        