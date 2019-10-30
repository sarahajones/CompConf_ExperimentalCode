function BlockData = runTrial(expSettings, BlockData, blockType, trialNum)

%function responsibile for running each indiivdual trial in each block. 
%iterates through each time a trial is run and saves trial infor back to
%the block data struct for later. 
%Pulls off some settings from the expSetting setup but also set params here
%as needed using trialSettings.. 

% Joshua Calder-Travis, j.calder.travis@gmail.com
% adapted by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

%% 

%generate the trial by trial parameters for the gabor stimuli
trialInfo = trialSettings(expSettings);

%pass back the trial by trial parameters to save into the blockdata
BlockData.mu_cat1 = trialInfo.mu_cat1;
BlockData.mu_cat2 = trialInfo.mu_cat2;
BlockData.kappa_s = trialInfo.kappa_s;
BlockData.orientations(trialNum, :) = trialInfo.orientation;
BlockData.categories(trialNum, :) = trialInfo.category;
BlockData.locations(trialNum, :) = trialInfo.locations;


%make sure no buttons are currently pressed 
[~, ~, buttons, ~, ~, ~] = GetMouse;
relevantButtons = buttons([1 3]);
while any(relevantButtons) % wait for release
[~, ~, buttons, ~, ~, ~]  = GetMouse;
relevantButtons = buttons([1 3]);
end

% Measure trial duration for debugging 
trialStart = tic;

% Wait for all buttons to be released
while KbCheck ~= 0; end


%% Present fixation cross
scCenter = expSettings.ScreenCenter;
fixationScale = expSettings.FixationScale;

Screen('DrawLines', expSettings.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), [255 255 255]);

[BlockData.FixFlipTime(trialNum), ~, ...
    BlockData.FixFlipEnd(trialNum), ~, ~] = Screen('Flip', expSettings.Win);

% Additional timestamps and timing info
BlockData.FixTimeMes2(trialNum) = GetSecs;

%% Present stimulus
% Work out when to make fixation clear and the stimulus appear
BlockData.StimulusOnset(trialNum) = ...
    BlockData.FixFlipTime(trialNum) + expSettings.FixTime - 0.005;

% Draw the stimulus
numGabors = BlockData.numGabor;
 
signalVar = [0.1, 0.2, 0.3, 0.4, 0.8];

trialInfo.currentSignalVar = signalVar(randperm(5, 1));
BlockData.ContrastLevel(trialNum) = trialInfo.currentSignalVar;

%if session is training use contrast of 1 . 
if strcmp(BlockData.BlockType, 'train') 
    trialInfo.currentSignalVar = 1;
end

%actual draw the gabors ready for slipping to screen. 
drawGabors(expSettings, trialInfo, numGabors)

% % save image of fixation cross (screenshot)
% samplePic = Screen('GetImage', expSettings.Win);
% imwrite(samplePic, 'test1.jpg')


% Prepare to monitor for a response
relevantMouseClick = false;

% Wait to flip 
[BlockData.StimFlipTime(trialNum), ~, ...
    BlockData.StimFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', expSettings.Win, BlockData.StimulusOnset(trialNum));

% save image of stimuli (screenshot)
% samplePic = Screen('GetImage', expSettings.Win);
% imwrite(samplePic, 'test2.jpg')

% All time measurements, apart from the fixation appear time, will be relative
% to the fixation appear time.
BlockData.StimFlipTime(trialNum) = ...
    BlockData.StimFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimFlipEnd(trialNum) = ...
    BlockData.StimFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

%% Present responses
% Work out when to clear the screen for the response
stimClearTime = BlockData.StimulusOnset(trialNum) + expSettings.StimDuration;


% Monitor for a response
while ~relevantMouseClick && (GetSecs < stimClearTime)
    
     [relevantMouseClick, BlockData] = checkForRespMouse(BlockData, trialNum); 

end

Screen('DrawLines', expSettings.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), [255 255 255]);

% Clear screen 
[BlockData.StimClearFlipTime(trialNum), ~, ...
    BlockData.StimClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', expSettings.Win, stimClearTime);

BlockData.StimClearFlipTime(trialNum) = ...
    BlockData.StimClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimClearFlipEnd(trialNum) = ...
    BlockData.StimClearFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

%make sure no buttons are currently pressed 
[~, ~, buttons, ~, ~, ~] = GetMouse;
relevantButtons = buttons([1 3]);
while any(relevantButtons) % wait for release
[~, ~, buttons, ~, ~, ~]  = GetMouse;
relevantButtons = buttons([1 3]);
end

% Monitor for a response
while ~relevantMouseClick 
  
[relevantMouseClick, BlockData] = checkForRespMouse(BlockData, trialNum);   
    
end

if strcmp (blockType, 'test')
    BlockData.Confidence(trialNum) = collectConfReport(expSettings);
end
% %save image of confidence slider (screenshot)
% samplePic = Screen('GetImage', expSettings.Win);
% imwrite(samplePic, 'test3.jpg')

if expSettings.sessionType == 0
   trialInfo.targetCategory = trialInfo.category;
   BlockData.targetCategory(trialNum) = trialInfo.targetCategory;
   BlockData.target(trialNum)= 1;
   BlockData.targetLocation(trialNum) = trialInfo.locations(1);
   BlockData.targetOrientation(trialNum) = trialInfo.orientation(1);

else
    BlockData.targetLocation(trialNum) = expSettings.targetLocation;
    targetIndex = 1 ;   
    trialInfo.targetCategory = trialInfo.category(targetIndex);
    BlockData.targetCategory(trialNum)= trialInfo.targetCategory;
    BlockData.targetOrientation(trialNum) = trialInfo.orientation(targetIndex);
    
end

% Display feedback via colour of fixation cross     
%if the category is 0 and the pp responds for category 0
% then the accuracy is valued at 1.

if trialInfo.targetCategory == 0
    
   if BlockData.Resp(trialNum) == 0
       BlockData.Acc(trialNum) = 1;
   else 
       BlockData.Acc(trialNum) = 0;
   end
   
else
    
%if the category is 1, the acc value is 1 when the response is 1.
    if BlockData.Resp(trialNum) == 0
       BlockData.Acc(trialNum) = 0;
   else 
       BlockData.Acc(trialNum) = 1;
   end
    
end
       

if BlockData.Acc(trialNum) == 1

    feedbackColour = [86, 180, 233];

elseif BlockData.Acc(trialNum) == 0

    feedbackColour = [230, 159, 0];

end

% if BlockData.Acc(trialNum) ~= BlockData.trialAccuracy(trialNum)
%       error('Bug')
% end
    
Screen('DrawLines', expSettings.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), feedbackColour);

Screen('Flip', expSettings.Win);

WaitSecs(0.7)

% For debugging 
BlockData.TrialDuration(trialNum) = toc(trialStart);

% Tidy up
Screen('Close')
       
% Clear screen
Screen('FillRect', expSettings.Win, expSettings.Colour.Base);

Screen('DrawLines', expSettings.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), [255 255 255]);

Screen('Flip', expSettings.Win);

