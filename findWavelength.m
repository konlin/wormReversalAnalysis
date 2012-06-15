%For sinusoidal locomotion, finds the wavelength
%excerpted from findPhaseShift2
%created by Konlin Shen 6/15/12
function [curvatureMatrix, constructedWave, wavelength]=findWavelength(mcdf_array)
curvdata=generateCurvature(mcdf_array); %percent worm body
psWormLength=findPhaseShift(curvdata'); %phase shift in percent-worm body
totalPS = 0; %in percent worm body
currentShift = 0; %in percent worm body
for k=1:length(psWormLength)
    totalPS=abs(round(psWormLength(k)))+totalPS;
end
curvatureMatrix=NaN(100+totalPS, length(mcdf_array)); %in percent worm body
for i=1:length(mcdf_array)
    for j=1:100+totalPS
        if(j <= 100)
            curvatureMatrix(currentShift+j,i)=curvdata(j,i);
        end
    end
    if(i ~= length(mcdf_array))
        currentShift=currentShift+abs(round(psWormLength(i)));
    end
end
constructedWave = zeros(100+totalPS,1);
for i=1:100+totalPS
    count=0;
    for j=1:length(mcdf_array)
        if(isnan(curvatureMatrix(i,j))~=1)
            constructedWave(i) = constructedWave(i)+curvatureMatrix(i,j);
            count = count+1;
        end
    end
    constructedWave(i) = constructedWave(i)/count;
end
constructedWave(isnan(constructedWave))=[];

Fs = 1; %sample rate is one sampe / percent body length
D = 1/Fs; %1 percent body length
L = length(constructedWave); %number of samples total
l = (1:L)*D; % x axis of the input curve (units sample)
figure;
hold on;
ax2(1)=subplot(2,1,1);
plot(l/Fs,constructedWave);
xlabel('Percent Body Length')
ylabel('Curvature')

NFFT = 2^nextpow2(L); % Next power of 2 from length of y - nyquist rate
Y = fft(constructedWave,NFFT)/L; %fft(data, number of samples) n-point DFT
f = Fs/2*linspace(0,1,NFFT/2+1);
ax2(2)=subplot(2,1,2);
stem(f,2*abs(Y(1:NFFT/2+1)), '-.');
xlabel('Angular Frequency (Cycles / Percent Body Length)')
[maxVal, maxInd] = max(abs(Y));
while(f(maxInd)==0)
    f(maxInd)=[];
    [maxVal, maxInd]=max(abs(Y));
end
freq = f(maxInd) * 100 %cycle per body length

wavelength = 1/freq %wavelength in body length