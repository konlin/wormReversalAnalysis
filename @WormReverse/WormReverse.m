classdef WormReverse
    %WORMREVERSE a single worm reversal
    %   This class stores data for a single worm reversal
    
    properties (SetAccess=private)
        %DATA:
        %
        %the video data of the reversal
        WormVid;
        %the phase change of the reversal
        phaseChange=0;
        %the phase change of the reversal in pi
        phaseChangePi=0;
        %the time duration of the reversal
        timeDuration=0;
    end %properties: data
    
    methods
        %set phase change
        function wrobj=setPhaseChange(wrobj,newPhase)
            wrobj.phaseChange=newPhase;
        end
        
        %set phase change in pi
        function wrobj=setPhaseChangePi(wrobj,newPhase)
            wrobj.phaseChangePi=newPhase;
        end
        
        %gets current timeDuration
        function time=getTimeDuration(wrobj)
            time=wrobj.timeDuration;
        end
        
        %set timeDuration
        function wrobj=setTimeDuration(wrobj,time)
            wrobj.timeDuration=time;
        end
        
    end
    
    methods
        %constructor
        function wrobj=WormReverse(startframe, endframe, mcdf, options, length)
          wrobj.WormVid=mcdf(startframe:endframe);
          numFrames=endframe-startframe+1;
          for(k=1:numFrames)
              c=generateCurvature(mcdf(k+startframe-1));
              x=createSineFit2(c,options);
              amplitudeArray(k)=x(1);
              frequencyArray(k)=x(2);
              phaseArray(k)=x(3);
          end
          unwrappedPhaseArray=unwrap(phaseArray);
          wrobj.phaseChange=unwrappedPhaseArray(numFrames)-unwrappedPhaseArray(1);
          wrobj.phaseChangePi=wrobj.phaseChange/pi;
          wrobj.timeDuration=length;
        end
    end
end
