function expSettings = createSettings (session, expSettings, presetArray)

% created by Joshua Calder-Travis, j.calder.travis@gmail.com
% adapted by Sarah Ashcroft-Jones,
% sarahashjones@gmail.com
% GitHub: sarahajones

%%INPUTS
%session: (input from the command window)
%expSettings: takes in the ppCode and other early fields of expSettings
%presetArray: passes in the loaded info from the presetArray file 

%OUTPUTS
%expSettings - a datastruct which indicates the experimental set up 
%fields =
    % .ppCode - participant code - input from command window
    % .RandGenerator - seeds the rng at the start of the expsession
    
    % .session - session number, passed from command window
    % .sessionType - easy or hard session (sets up number Gabors)
    % .numGabors - number of stimuli on screeen (target plus distractors)
    % .items - list of numbers e.g. 1:6 relating to number of items
    % .numTestBlocks - number of test blocks per session
    % .numTestTrials - number of trials per test block
    % .numTrainBlocks - number of trianing blocks per session
    % .TrialsPerTrainBlock - number of trials per training block
    % .numBlocks - number of blocks total (both train and test)
    
    % .Win - sets the experimental window
    % .WinArea - sets size of experimental screen
    % .scW - screen width
    % .scH - screen height
    % .ScreenCentre - centre of the screen
    % .RefreshRate  - screen refresh rate 
    % .Text.Size1 - font size 1
    % .Text.Size2 - font size 2
    % .StimDuration - length of screening of stimuli
    % .FixTime - length of screening of fixation cross
    
    % .Color.Base - background color for the screen throughout 
    % .Color.Arc - color of confidence slider arc
    

%% Seed the random number generator
rng('shuffle');
expSettings.RandGenerator = rng;

%% Experiment structure
expSettings.session = session;
expSettings.numTestBlocks = 10; %10
expSettings.numTestTrials = 63; %63
expSettings.numTrainBlocks = 2; %2
expSettings.TrialsPerTrainBlock = 100; %100

% Do less training if this is not the first session
if expSettings.session ~= 1
    expSettings.numTrainBlocks = 1;
end

expSettings.numBlocks = expSettings.numTestBlocks + expSettings.numTrainBlocks;

%set up the type of session it will be - easy or hard, using presetArray
if expSettings.session == 1
 database=presetArray.presetList.session1type;
elseif expSettings.session == 2
    database=presetArray.presetList.session2type;
elseif expSettings.session == 3
    database=presetArray.presetList.session3type;
else
    database=presetArray.presetList.session4type;
end

i = str2double(expSettings.ppCode);
expSettings.sessionType = database(i);

%based on the type of session set up the number of Gabors onscreen 
if expSettings.sessionType == 0
    expSettings.numGabors = 1;
    expSettings.items = (1);
else
    expSettings.numGabors = 2;
    expSettings.items = (1:2)';
end

%% Set up the computer
Priority(1);
KbName('UnifyKeyNames');
Screen('Preference', 'SkipSyncTests', 0); 

%set up screen and screen dimensions
[expSettings.Win, expSettings.WinArea] = Screen('OpenWindow', 0); 
expSettings.scW = expSettings.WinArea(3); %screen width 
expSettings.scH = expSettings.WinArea(4); %screen height
expSettings.ScreenCenter = [ expSettings.WinArea(3)/2 ; expSettings.WinArea(4)/2 ]; 

% Test that the refresh rate is as expected
expSettings.RefreshRate = Screen('NominalFrameRate', expSettings.Win);

% Set text sizes
expSettings.Text.Size1 = 18;
expSettings.Text.Size2 = 20;

% Set font
Screen('TextFont', expSettings.Win, 'Helvetica');
%% Timing
expSettings.FixTime = 0.5; % Duration of the fixation cross

if expSettings.sessionType == 0
    expSettings.StimDuration = 0.05;
else
    expSettings.StimDuration = 0.1;
end

%% set colors  for experiment

% Set the colours to use
expSettings.Colour.Base = [0.5 0.5 0.5]*255;
expSettings.Colour.Arc = [0.25 0.25 0.25]*255;

% Fill screen with background colour
Screen('FillRect', expSettings.Win, expSettings.Colour.Base);

%%  set up the stimulus target location  

if expSettings.sessionType == 1
    db = presetArray.presetList.targetLocation;
    i = str2double(expSettings.ppCode);  
    expSettings.targetLocation  = db(i, :);
    
    if expSettings.targetLocation == 5
        expSettings.notTargetLocation = 2;
    else
        expSettings.notTargetLocation = 5;
    end
else 
    expSettings.targetLocation = 7;

end    
     
%% Display
% Set size of fixation cross
expSettings.FixationScale = 6;

% Pick orientation statistics
expSettings.MeanAngle = pi/2;
expSettings.DistractorKappa = [0, 1.5]; % Concentration parameter, one for each 

% Determine Gabor center locations
% First specify the angles from verticle that want the Gabors
expSettings.Theta = [-(5/6)*pi, -(1/2)*pi, -(1/6)*pi, (1/6)*pi, (1/2)*pi, (5/6)*pi]';

% Specify the radius of the circle on which the Gabors will be located
expSettings.RGabor = 196;

% Compute the displacement from screen center of the Gabors
xDisp = expSettings.RGabor * sin(expSettings.Theta);
yDisp = expSettings.RGabor * cos(expSettings.Theta);

% Compute the locations on the screen in Psychtoolbox coords
x = round(xDisp) + expSettings.ScreenCenter(1);
y = -round(yDisp) + expSettings.ScreenCenter(2);

expSettings.GaborCenters = [x, y];
expSettings.GaborCenters(7, :) = [ expSettings.WinArea(3)/2 ; expSettings.WinArea(4)/2 ];

% Define the squares in which the Gabors will be placed
expSettings.GaborSD = 10;
expSettings.GaborSquareWidth = (10 * expSettings.GaborSD) +1; %In pixels

for iGabor = 1 : 7
    
    center = expSettings.GaborCenters(iGabor, :);
    halfWidth = (1/2) * (expSettings.GaborSquareWidth -1);
    
    
    expSettings.GaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
        (center(2) - halfWidth -1), ...
        (center(1) + halfWidth), ...
        (center(2) + halfWidth)];
    
end



% Also define the locations to present example stimuli during instructions.
% First specify as fractions of the screen relative to the center point and
% then scale.
exampleStimCenters = NaN(31, 2);

% The first one will be the target. Set on its own
exampleStimCenters(1, :) = [-39/49 , 6/28];

% The specify the distractor locations
exampleStimCenters(2 : 11 , 2) = 0;
exampleStimCenters(12 : 21 , 2) = 6/28;
exampleStimCenters(22 : 31 , 2) = 12/28;

exampleStimCenters(2 : 31 , 1) = repmat((-12:6:42)/49, 1, 3);


% Now scale and center
exampleStimCenters(:, 1) = exampleStimCenters(:, 1)*((1/2) * ...
    (expSettings.WinArea(3) - expSettings.WinArea(1)));


exampleStimCenters(:, 2) = exampleStimCenters(:, 2)*((1/2) * ...
    (expSettings.WinArea(4) - expSettings.WinArea(2)));


exampleStimCenters(:, 1) = exampleStimCenters(:, 1) + expSettings.ScreenCenter(1);
exampleStimCenters(:, 2) = exampleStimCenters(:, 2) + expSettings.ScreenCenter(2);


for iGabor = 1 : size(exampleStimCenters, 1)
    
    center = exampleStimCenters(iGabor, :);
    halfWidth = (1/2) * (expSettings.GaborSquareWidth -1);
    
    
    expSettings.ExampleGaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
        (center(2) - halfWidth -1), ...
        (center(1) + halfWidth), ...
        (center(2) + halfWidth)];
    
    
end


% Check there is no overlap of boxes
gaborMaps = zeros(expSettings.WinArea(3), expSettings.WinArea(4));


for iGabor = 1 : length(expSettings.Theta)
    
    xLocationOfSquare = ...
        expSettings.GaborSquare{iGabor}(1) : expSettings.GaborSquare{iGabor}(3);
    
    yLocationOfSquare = ...
        expSettings.GaborSquare{iGabor}(2) : expSettings.GaborSquare{iGabor}(4);

    
    gaborMaps(xLocationOfSquare, yLocationOfSquare) = ...
        gaborMaps(xLocationOfSquare, yLocationOfSquare) + 1;
    
     
end


if any(any(gaborMaps > 1)); error('Bug'); 
end 
end