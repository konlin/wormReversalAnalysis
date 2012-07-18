function crawler(directory)
dirInfo=dir(directory);
for i=3:numel(dirInfo)
    subdirPath=strcat(directory,dirInfo(i).name)
    cd(subdirPath)
    subdirInfo=dir(subdirPath);
    for j=3:numel(subdirInfo)
      [~,~,ext]=fileparts(strcat(subdirPath,subdirInfo(j).name));
      if(strcmpi(ext,'.yaml'))
          try
            mcdf=Mcd_Frame.yaml2matlab(subdirInfo(j).name);
            save mcdf mcdf;
            options=optimset('MaxFunEvals', 100000, 'MaxIter', 100000);
            reversalArray=findReversals(mcdf,options);
            save reversalArray reversalArray;
            cleanedReversalArray=cleanReversalData(reversalArray);
            save cleanedReversalArray cleanedReversalArray;
            disp('Analysis Complete!');
          catch
            disp('Analysis Failed :(');
          end
          break;
      end
    end
    cd ..
end

disp('Job Finished');
end
    
          