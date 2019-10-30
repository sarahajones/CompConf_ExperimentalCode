function [relevantKeyPress, BlockData] = checkForResp(BlockData, trialNum)

% Joshua Calder-Travis, j.calder.travis@gmail.com
%utilised by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

% Flag
relevantKeyPress = false;

[keyDown, responseTime, keyCode] = KbCheck;

% Is the 'f' pressed indicating no target?
if keyDown && keyCode(70)
    
    BlockData.Resp(trialNum) = 0;
    relevantKeyPress = true;
    
% Is the 'j' pressed indicating a target?
elseif keyDown && keyCode(74)
    
    BlockData.Resp(trialNum) = 1;
    relevantKeyPress = true;
  
end

% If any relevant key is pressed store RTs
if keyDown && relevantKeyPress
    
BlockData.RtAbs(trialNum) = responseTime;
BlockData.RT(trialNum) = ...
    BlockData.RtAbs(trialNum) ...
    - BlockData.FixFlipTime(trialNum) - BlockData.StimFlipTime(trialNum);

% BlockData.trialAccuracy(trialNum) = BlockData.Resp(trialNum) == BlockData.target(trialNum);

end
