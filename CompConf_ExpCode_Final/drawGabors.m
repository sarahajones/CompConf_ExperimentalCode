function drawGabors(expSettings, trialInfo, numGabors)
% Draws a stimulus of Gabors ready for slipping

% Joshua Calder-Travis, j.calder.travis@gmail.com
%adapted by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

for iItem = 1: numGabors

        % Check there is something to draw in this position
        if isnan(trialInfo.orientation(iItem))
            continue
        end
        
        if expSettings.sessionType == 0 
            
            currentLocation = 7;
            currentOrientation = trialInfo.orientation(iItem);
        else 
            if iItem == 1
            currentLocation = expSettings.targetLocation;
            currentOrientation = trialInfo.orientation(iItem);
            else
            currentLocation = expSettings.notTargetLocation;
            currentOrientation = trialInfo.orientation(iItem);
            end
                
        end
           
        
        % We need to map orienation onto the range [-pi/2, pi/2] from [-pi, pi]
        % becuase the Gabor patches have no direction, and hense a pi/2
        % oriented patch is indistinguishable from a -pi/2 oriented patch
        mappedOrientation = (1/2) * currentOrientation;

        [gaborIm, width] = makeGabor(expSettings.GaborSD, 22, ...
            mappedOrientation, 0, expSettings.Colour.Base, [1 1 1], trialInfo);

        gaborTexture = Screen('MakeTexture', expSettings.Win, gaborIm);
  
        Screen('DrawTexture', expSettings.Win, gaborTexture, ...
            [0, 0, width, width], expSettings.GaborSquare{currentLocation});


        % Check that the new Gabor texture is the same size as the square in which
        % we are going to draw it.
        if any(width ~= [ ...
            expSettings.GaborSquare{iItem}(3) - expSettings.GaborSquare{iItem}(1), ...
            expSettings.GaborSquare{iItem}(4) - expSettings.GaborSquare{iItem}(2)])

            error(['Target rect is not the same size as the rect in which the, ' ...
                'Gabor is contained.'])

        end
end
end
