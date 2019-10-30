function trialparams = trialSettings(expSettings)
%function establishes the trial by trial settings for the experiment


%Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk
%% Import detail from expsettings as required
numGabors = expSettings.numGabors;
trialparams.items = expSettings.items;

%set trial categories
for i =1:numGabors
    trialparams.category(i, 1) = randi([0 1]);
end

%set trial orientations based on the categories defined above
trialparams.mu_cat1 = (15/16).*(pi); %off the horizontal - check
trialparams.mu_cat2 = (17/16).*(pi); % off the horizontal - check
trialparams.kappa_s = 20; % 7 for first 4, 20 thereafter 

%calculate the orientations of the stimuli - NB that these are calculated
%using the von Mises circle stats distributions. 
trialparams.orientation = NaN(numGabors, 1);
for i = 1:numGabors
    if trialparams.category(i, 1)== 0 % if category is one then compute the orientation based on cat 1 mean as follows
        trialparams.orientation(i, 1) =  circ_vmrnd_fixed(trialparams.mu_cat1, trialparams.kappa_s, 1); %generate trial orientation .
    else
        trialparams.orientation(i, 1) =  circ_vmrnd_fixed(trialparams.mu_cat2, trialparams.kappa_s, 1); %drawn from vonMises distribution.

    end
end

%set target location for the gabor (if there is more than one Gabor. 
if expSettings.sessionType == 0
    trialparams.locations = expSettings.targetLocation;
else 
    trialparams.locations = [2, 5];
end


