%7/26/12 Forward Wavelength Finder
function wavelengthArray=forwardWavelengthAnalyzer(mcdf)
posCounter=0;
wavelengthArray=[];
velocity=getVelocity(mcdf);
endFlag=0;
for i=1:length(mcdf)-1
    while(velocity(i)<=.10)
      try
          velocity(i+1);
          i=i+1;
      catch
          endFlag=1;
          break;
          disp('da fuq');
      end
      posCounter=0;
    end
    if(endFlag==1)
        break;
    end
    posCounter=posCounter+1;
    if(posCounter==70)
        try
          mcdf_forward=mcdf(i-70:i);
          [~,~,lambda]=findWavelength(mcdf_forward);
          firstFrame=i-70
          lastFrame=i
          w=waitforbuttonpress
          if(w==0)
            disp('Throwing Away Wavelength!');
          else
            disp('Value Accepted!');
             wavelengthArray=[wavelengthArray,lambda];
          end
        catch
            disp('Error!')
        end
        close;
        posCounter=0;
    end
end
figure;
hist(wavelengthArray,25);
