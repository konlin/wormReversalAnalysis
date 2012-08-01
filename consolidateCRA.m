function cradex=consolidateCRA(type)
cradex=[];
cd('G:\c.elegans video'); % G:\c.elegans
dirInfo=dir(pwd); % G:\c.elegans

for i=3:numel(dirInfo) %date level G:\c.elegans
    subdirPath=strcat('G:\c.elegans video\',dirInfo(i).name) % G:\c.elegans
    %pause(1)% G:\c.elegans
    try% G:\c.elegans
        cd(subdirPath);% G:\c.elegans\2-27-12
        subdirInfo=dir(subdirPath);% G:\c.elegans\2-27-12
        for j=3:numel(subdirInfo) %trial level% G:\c.elegans\2-27-12
            subsubdirPath=strcat(subdirPath,'\',subdirInfo(j).name)% G:\c.elegans\2-27-12
            try% G:\c.elegans\2-27-12
                cd(subsubdirPath);% G:\c.elegans\2-27-12\konlinvid1
                subsubdirInfo=dir(subsubdirPath);% G:\c.elegans\2-27-12\konlinvid1
                for k=3:numel(subsubdirInfo) %video level% G:\c.elegans\2-27-12\konlinvid1
                    strcat(subsubdirPath,'\',subsubdirInfo(k).name);
                    [~,~,ext]=fileparts(strcat(subsubdirPath,'\',subsubdirInfo(k).name));% G:\c.elegans\2-27-12\konlinvid1
                    if(strcmpi(ext,'.avi'))
                        disp('Derp');
                        strfind(subsubdirInfo(k).name,type)
                        if(~isempty(strfind(subsubdirInfo(j).name,type)))
                            disp('herp derp');
                            k=waitforbuttonpress
                            ind=find([subsubdirInfo.name]==cleanedReversalArray);
                            k=waitforbuttonpress
                            load(subsubdirInfo(ind));
                            cradex=[cradex,cleanedReversalArray]
                            break;
                        end
                    end
                end
            catch exception
                disp ('Could not access directory!')
                
            end
        end
    catch exception
        disp('Could not access directory!');
    end
end
end
