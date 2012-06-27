%code to find the phase of each reversal in a reversalArray
%created by Konlin Shen 4/25/12
function wavelengthArray=batchWavelengthFinder(reversalArray)
for i=1:length(reversalArray)
    try [~,~,wavelength]=findWavelength(reversalArray(i));
    catch
        disp('Error!');
        wavelength=NaN;
    end
    wavelengthArray(i)=wavelength;
    close;
end
end