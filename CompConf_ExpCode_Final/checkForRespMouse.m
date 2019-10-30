function [relevantMouseClick, BlockData] = checkForRespMouse(BlockData, trialNum)

% Joshua Calder-Travis, j.calder.travis@gmail.com
%adapted by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

% Flag
relevantMouseClick = false;
% buttonsPressed = 0;

[~, ~, buttons, ~, ~, ~] = GetMouse;
relevantButtons = buttons([1 3]);

% while ~any(relevantButtons) % wait for press
% [~, ~, buttons, ~, ~, ~]  = GetMouse;
% relevantButtons = buttons([1 3]);
% buttonsPressed = relevantButtons;
% end
% 
% while any(relevantButtons) % wait for release
% [~, ~, buttons, ~, ~, ~]  = GetMouse;
% relevantButtons = buttons([1 3]);
% end

% Is the 'left key' pressed indicating a category 1 trial?
if relevantButtons(1)
    Rt = GetSecs;
    BlockData.Resp(trialNum) = 0;
    relevantMouseClick = true;
    
% Is the 'right key' pressed indicating a category 2 trial?
elseif relevantButtons(2)
    Rt = GetSecs;
    BlockData.Resp(trialNum) = 1;
    relevantMouseClick = true;
  
end

% If any relevant key is pressed store RTs
if relevantMouseClick == true
    
BlockData.RtAbs(trialNum) = Rt;
BlockData.RT(trialNum) = ...
    BlockData.RtAbs(trialNum) ...
    - BlockData.FixFlipTime(trialNum) - BlockData.StimFlipTime(trialNum);

% BlockData.trialAccuracy(trialNum) = BlockData.Resp(trialNum) == BlockData.target(trialNum);

end
