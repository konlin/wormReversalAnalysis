%code to find the phase of each reversal in a reversalArray
%created by Konlin Shen 4/25/12
function phaseShiftArray=batchPhaseFinder(reversalArray)
for i=1:length(reversalArray)
    try [~,~,phaseShift]=findPhaseShift2(reversalArray(i));
    catch
        disp('Error!');
        phaseShift=NaN;
    end
    phaseShiftArray(i)=phaseShift;
end
end
