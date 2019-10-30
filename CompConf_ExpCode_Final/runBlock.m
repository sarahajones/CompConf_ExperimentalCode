 function proportionCorrect = runBlock(expSettings, blockNum, blockType, numTrials)

% function runs block of experimental code / trials.
%saves trials for each block individually into a datastruct for that block
%these can be stitched together later for analysis across whole experiment
%(safe against crashes etc.)

%Joshua Calder-Travis, j.calder.travis@gmail.com
%adapted by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk
%% Set up

% Store basic info
BlockData.ppCode = expSettings.ppCode;
BlockData.BlockNum = blockNum;
BlockData.BlockType= blockType;
BlockData.numGabor = expSettings.numGabors;

% Initialise target settings
BlockData.target =  NaN(numTrials, 1); %should index the target out of the six poss, should reamin constant as relates to color which is constant
BlockData.targetCategory =  NaN(numTrials, 1); %should vary 0 or 1 
BlockData.targetOrientation = NaN(numTrials, 1); %should vary each trail - dependent on category
BlockData.targetLocation =  NaN(numTrials, 1); %should vary from 1-6 per trial

%Initialise general 
BlockData.Resp = NaN(numTrials, 1);
BlockData.Acc = NaN(numTrials, 1);
BlockData.Accuracy = NaN(expSettings.numBlocks, 1);
BlockData.RtAbs = NaN(numTrials, 1); % Absolute RT
BlockData.RT = NaN(numTrials, 1);% RT relative to simulus onset
BlockData.FixFlipTime = NaN(numTrials, 1);
BlockData.FixFlipEnd = NaN(numTrials, 1);
BlockData.FixTimeMes2 = NaN(numTrials, 1);
BlockData.StimulusOnset = NaN(numTrials, 1);
BlockData.StimFlipTime = NaN(numTrials, 1);
BlockData.StimFlipEnd = NaN(numTrials, 1);
BlockData.StimClearFlipTime = NaN(numTrials, 1);
BlockData.StimClearFlipEnd = NaN(numTrials, 1);
BlockData.TrialDuration = NaN(numTrials, 1);
BlockData.Confidence = NaN(numTrials, 1);

%intialise blockdata trial parameters
BlockData.itemList = expSettings.items;
BlockData.categories = NaN(numTrials, 2); 
BlockData.mu_cat1 = NaN(1,1);
BlockData.mu_cat2 = NaN(1,1);
BlockData.kappa_s = NaN(1,1);
BlockData.orientations = NaN(numTrials, 2);
BlockData.locations = NaN(numTrials, 2);
BlockData.ContrastLevel = NaN(numTrials); 

%% instructions for the block
 text = ['The next block is block ' ...
            num2str(blockNum) ' of ' num2str(expSettings.numBlocks) '.' ...
            '\n\n\n Click on the mouse to start the first trial.'];
        
        Screen('TextSize', expSettings.Win, expSettings.Text.Size2);
    
    DrawFormattedText(expSettings.Win, text, ...
        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    
    Screen('Flip', expSettings.Win);
    
    pause(0.2);
    checkForMouseClick
   
%% run trials in the block
    
for iTrial = 1:numTrials
    BlockData = runTrial(expSettings, BlockData, blockType, iTrial);
end


% What is the overal proportion correct as a percentage?
proportionCorrect = sum(BlockData.Acc)/length(BlockData.Acc) * 100;
BlockData.Accuracy(blockNum) = proportionCorrect;

% Save block data
    save([pwd '/Data/ppp' expSettings.ppCode ...
        '_Session' num2str(expSettings.session) 'Block' num2str(blockNum)], ...
        'BlockData');
    
%% display text after block as required based on which block it is and what comes next
    
text1 = ['Congratulations you have completed this block with ' num2str(BlockData.Accuracy(blockNum)) '%  accuracy.' ...
        '\n\n\n Press any key to continue.'];

text2 = ['Remember to use what you have learned this block to maximise your scores on the next round.'...
        '\n\n\n Keep trying to learn from each trial to improve your accuracy, what makes a response likely to be correct will not change.'...        
        '\n\n\n Remember to focus on the the orientation of the lines in the images you see.'...  
        '\n\n\n This task is designed to be difficult, do not be discouraged if you find the trials hard.'...
        '\n\n\n Press any key to continue.'];

text3 = ['Take a break until you feel ready to start again.' ...
        '\n\n\n Press any key to begin the next block.'];
    
text4 = ['The next block will be another training block.'...
        '\n\n\n Use what you have learned this block to maximise your scores on the next round.'...
        '\n\n\n Remember to focus on the orientation of the lines in the images you see.'...
        '\n\n\n Press any key to continue.'];

text5 = ['You have now finished training, the next block will be a testing block.'...
            '\n\n\n Use what you have learned during training to maximise your score on the next round.'...
            '\n\n\n Now that training is over the visibility of the image may change trial by trial, ' ...
            '\n\n\n however, what makes a response likely to be correct will not change.'...
        '\n\n\n Press any key to continue.'];
 
text6 = ['The fixation cross will still change color every trial.'...
        '\n\n\n However, you will also get a score for your overall accuracy after each round.'...            
        '\n\n\n Keep trying to learn from each trial to improve your accuracy.'...
        '\n\n\n Press any key to continue.'];   
if blockNum < expSettings.numBlocks
    
    if expSettings.session == 1
        
        if blockNum > 2
            
            DrawFormattedText(expSettings.Win, text1, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
            
            DrawFormattedText(expSettings.Win, text2, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
            
            DrawFormattedText(expSettings.Win, text3, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
           
        elseif blockNum == 1
            
                DrawFormattedText(expSettings.Win,text4 , ...
                        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
                DrawFormattedText(expSettings.Win, text3, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait() 
                
        else 
            
                DrawFormattedText(expSettings.Win,text5 , ...
                'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
                 DrawFormattedText(expSettings.Win,text6 , ...
                'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
                DrawFormattedText(expSettings.Win, text3, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
        end
        
    else
        
        if blockNum == 1
            
            DrawFormattedText(expSettings.Win,text5 , ...
                'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
                 DrawFormattedText(expSettings.Win, text3, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
                Screen(expSettings.Win, 'Flip'); %bring to front
                pause(0.2)
                KbWait()
                
        else
            
            DrawFormattedText(expSettings.Win, text1, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
            
            DrawFormattedText(expSettings.Win, text2, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
            
            DrawFormattedText(expSettings.Win, text3, ...
                    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
            Screen(expSettings.Win, 'Flip'); %bring to front
            pause(0.2)
            KbWait()
            
        end
    end
else
     DrawFormattedText(expSettings.Win, text1, ...
    'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    Screen(expSettings.Win, 'Flip'); %bring to front
    pause(0.2)
    KbWait()
end

end

