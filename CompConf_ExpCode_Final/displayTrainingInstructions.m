function displayTrainingInstructions (expSettings)
%% displayTrainingInstructions

%displays instructions for training blocks 

%Sarah Ashcroft-Jones,
% sarahashjones@gmail.com
% GitHub: sarahajones

%% read in images needed for slides
   
if expSettings.sessionType == 0
    image = imread('singleGabor.jpg');
else
    image = imread('doubleGabor.jpg');
end
 image2 = imread('confslider.jpg');

% Screen('Preference', 'SkipSyncTests', 1);
% Screen('Preference', 'VisualDebugLevel', 0);
% Screen('Preference', 'SuppressAllWarnings', 1);
HideCursor(0,[]);

%set screen parameters 
scW = expSettings.scW; %screen width 
scH = expSettings.scH; %screen height
window = expSettings.Win;
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
expSettings.ScreenCenter = [ expSettings.WinArea(3)/2 ; expSettings.WinArea(4)/2 ];

%set text parameters
Screen(window, 'TextFont', 'Helvetica'); %set text font
Screen(window, 'TextSize', expSettings.Text.Size2); %set text size

%show instructions screen and wait for key response to move forward. 
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'Thank you for taking part today!', 'center', scH*0.3, [255 255 255]);
DrawFormattedText(window, 'We will start by looking through the instructions for the study.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'Please read these instructions carefully and feel free to ask questions if you need more information.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward. 
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
imageTexture = Screen('MakeTexture', expSettings.Win, image);
Screen('DrawTexture', expSettings.Win, imageTexture,[], expSettings.WinArea);
DrawFormattedText(window, 'On each trial of this study an image will appear on screen, today the image will look similar to this.', 'center', scH*0.2, [255 255 255]);
DrawFormattedText(window, 'After you see each image, respond using either the left or right mouse button.', 'center', scH*0.75, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.8, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'You will then receive feedback on the accuracy of your response.', 'center', scH*0.3, [255 255 255]);
DrawFormattedText(window, 'Feedback will be shown by a color change of the fixation cross.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'The fixation cross will turn                 if you were correct or              if you were incorrect.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'turquoise', scW*.37, scH*0.5, [86, 180, 233]);
DrawFormattedText(window, 'orange', scW*.615, scH*0.5, [230, 159, 0]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()


%show instructions screen and wait for key response to move forward. 
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'The aim is to get the highest possible accuracy on each round of the study.', 'center', scH*0.3, [255 255 255]);
DrawFormattedText(window, 'Improve your accuracy using the feedback provided to establish what makes a response likely to be correct or incorrect.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'What makes a response likely to be correct will not change across the experiment.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward. 
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'Top tip: focus on the orientation of the lines in the image.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'Over time this should guide your understanding of what makes a response likely to be correct.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'You will have some training trials to begin with.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'Use these trials to learn how to use the response buttons on the mouse', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'and to learn about the images you will have to respond to over the whole study.', 'center', scH*0.6, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.7, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
DrawFormattedText(window, 'After your training, the feedback changes.', 'center', scH*0.3, [255 255 255]);
DrawFormattedText(window, 'The fixation cross will still change color. However, you will also get feedback after each round.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, '(A percentage accuracy score for the whole round - try to maximise this each time!)', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen
imageTexture = Screen('MakeTexture', expSettings.Win, image2);
Screen('DrawTexture', expSettings.Win, imageTexture,[], expSettings.WinArea);
DrawFormattedText(window, 'Once training is over, after each response, you will also be asked to rate how confident you were in the accuracy of your choice.', 'center', scH*0.6, [255 255 255]);
DrawFormattedText(window, 'You report your confidence using a sliding scale on screen like this one.', 'center', scH*0.7, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.8, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen 
DrawFormattedText(window, 'Between each block you will be able to take a break.', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'Take this time to refocus for the next part of the study.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

%show instructions screen and wait for key response to move forward.
Screen(window, 'FillRect', expSettings.Colour.Base ); %bring forward a black screen;
DrawFormattedText(window, 'Are you ready to begin?', 'center', scH*0.4, [255 255 255]);
DrawFormattedText(window, 'Feel free to ask any questions you may have now.', 'center', scH*0.5, [255 255 255]);
DrawFormattedText(window, 'Press any key to continue.', 'center', scH*0.6, [255 255 255]);
Screen(window, 'Flip'); %bring to front
pause(0.2)
KbWait()

end
