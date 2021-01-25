folder="G:\CUPT Data\ÂÁÇò ±äÌî³äÂÊ 55Hz 1.40";
oldPath=pwd;
list=dir(folder);
avr=cell(60,2);% the first column is fill rate, second is figure line data.
j=0;
% tlower=datetime(2019,8,4);
% tupper=datetime; % now
for i=3:length(list)% exclude "." and ".." directory.
    if list(i).isdir
        j=j+1;
        avr{j,1}=sscanf(list(i).name,"%f",1);
        temp=dir(folder+'\\'+list(i).name+"\\Density.fig");
        for k=1:length(temp)
            % if there's not so much disturbance, you can ignore this step.
%             if isbetween(temp(k).date,tlower,tupper)    
                open(folder+'\\'+list(i).name+'\\'+temp(k).name);
                handles=findall(gcf,'type','line');
                x=handles.XData;
                y=handles.YData;
                avr{j,2}=transpose([x;y]);
%             end
        end
        
    end
end
fprintf("Work done.\n");
        