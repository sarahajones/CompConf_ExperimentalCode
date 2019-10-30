 %% runExperiment
%function acts as umbrella function to run compconf experiment. 
%requires input from command window to open psychtoolbox window and save
%accurately. 
%must sit in folder with subflder Data avaialbel to save all relevant
%files. 

%INPUT:
%ppCode - participant code, to link files together and save correctly
%session - number of session 1-4, prevents overwriting of files and
%estbalishes number of training blocks required. 

%OUTPUT: 
% expSettings - a file containing all the experimental settings to be saved
% seperately from the experimental data and the participant files

% Joshua Calder-Travis, j.calder.travis@gmail.com
%adapted by:
% Sarah Ashcroft-Jones 
% sarahashjones@gmail.com
% GitHub: sarahajones
%% 

function expSettings = runExperiment(ppCode, session)
%% set up and participant details
%take participant information
expSettings.ppCode = num2str(ppCode);

% Collect basic participant info and save seperately if session 1 only 
if session == 1
    collectParticipantInfo(expSettings.ppCode)   
end

%load up preset array which indicates what session type it will be
%(easy/hard) and what target color is to be used for this participant in
%hard sessions
presetArray = load('PresetList.mat'); 

%import settings from expSettings function
expSettings = createSettings(session, expSettings, presetArray);

% Save experiment details
save([pwd '/Data/pp' expSettings.ppCode '_Session' num2str(session) ...
    '_expSettings'], 'expSettings');

%% instructions
if session == 1
    displayTrainingInstructions (expSettings)
else
    displayRefresherInstructions (expSettings)
end

%% run blocks of trials 
for iBlock = 1: expSettings.numBlocks
    if expSettings.session == 1
        if iBlock > 2
            %starts with block x of x message
            runBlock (expSettings, iBlock, 'test', expSettings.numTestTrials);
            %ends with percentage correct and self - timed pause
        else
            %training instructions have been displayed already
            %run the first training block (or second)
            runBlock (expSettings, iBlock, 'train', expSettings.TrialsPerTrainBlock);
            %then send them to the next training block or to testing block
        end
    else
        if iBlock == 1
            %refresher instrucitons already displayed
            runBlock (expSettings, iBlock, 'train', expSettings.TrialsPerTrainBlock);
            %now send them onto the testing blocks
           
        else
           %starts with block x of x message
           runBlock (expSettings, iBlock, 'test', expSettings.numTestTrials);
            %ends with self timed pause and percentage correct
        end
    end
end

%% Close off the experiment
text6 = ['The experiment is now over.' ...
    '\n\n\n Thank you for your time.'...
    '\n\n\n Press any key to close the session.'];

DrawFormattedText(expSettings.Win, text6, ...
                'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
        Screen(expSettings.Win, 'Flip'); %bring to front
        pause(0.2)
        KbWait()
        
sca
end
