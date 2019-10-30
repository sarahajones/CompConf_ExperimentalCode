%% presetArray
%function creates array to save session types based on predefined ppCodes
%list will be used to preset which session type the particpant sees first
%in the ABBA design of the experiment. 

%created by Sarah Ashcroft-Jones, 
% sarahashjones@gmail.com
% GitHub: sarahajones

%% create list of participant numbers

numparticipants = 100;
presetList.ppCode = (1:1:numparticipants)' ;


%% set up counterbalanced first session type
%%shuffle pairs of first session type
 
for i = 1:50
    sessionType = [0, 1];
    
    randsessionType = randperm(2,2);
    
    presetList.session1type(2.*i-1, 1) = sessionType(randsessionType(1, 1));
    
    presetList.session1type(2.*i, 1) = sessionType(randsessionType(1, 2));
    
end  
%% define target location and order of session types for each participant

for i =1:numparticipants
    locations = [2,5];
    position = randi(length(locations));
    presetList.targetLocation (i, 1) = locations(position); 

    if presetList.session1type(i, 1) == 0
        presetList.session2type(i, 1) = 1;
        presetList.session3type(i,1) = 1;
        presetList.session4type(i, 1) = 0;
    else
        presetList.session2type(i, 1) = 0;
        presetList.session3type(i, 1) = 0;
        presetList.session4type(i, 1) = 1;
    end

    
end
%%
save('PresetList', 'presetList')
%%
save([pwd 'PresetList', '-struct'],'presetList');
