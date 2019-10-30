%% collectPartiicpantInfo
%function used to collect participant information and save it to a file

%INPUT
%ppCode - participant code, input at the start of the function

% Joshua Calder-Travis, j.calder.travis@gmail.com
%utilised by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

%% 

function collectParticipantInfo(ppCode)
% First check we will not be overwritting any files when we save later
filename = (['ptpnt' num2str(ppCode) '_anon']);

if exist([pwd '/Data/' filename '.mat']) == 2
    
    sca
    error('Ptpnt num already exists')

end

% Create a figure to cover the back of the screen
figure
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Collect age
invalidResponse = 1;

while invalidResponse ~= 0
    
    % Present dialog box
    ageReport = inputdlg({['What is your age? Type ''1111'' ' ...
        'if you would prefer not to say.']});
    Anon.Age = ageReport{1};
    
    %check the response is one of the response options
    invalidResponse = sum(~isstrprop(Anon.Age, 'digit'));
    
    if invalidResponse == 0 && str2num(Anon.Age) < 18
        invalidResponse = 1;
    end
        
end

% Collect hand
Anon.Hand = '';

while strcmp(Anon.Hand , '')
    
    Anon.Hand = questdlg('Which is your dominant hand?',...
        'Q2', 'Left', 'Right', 'Neither', 'Neither');
       
end

% Collect gender
Anon.Gender = [];

while isempty(Anon.Gender)
    
    options = {'Female', 'Male', 'Non-binary', 'Prefer not to say'};
    
    Anon.Gender = listdlg('PromptString', 'What is your gender identity?', ...
        'SelectionMode','single', 'ListString', options);
       
end

%save data
save([pwd '/Data/' filename], 'Anon');


close all
