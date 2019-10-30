function mouseClicked = checkForMouseClick

% Joshua Calder-Travis, j.calder.travis@gmail.com
%adapted by Sarah Ashcroft-Jones, sarah.ashcroft-jones@psy.ox.ac.uk

% Flag
mouseClicked = false;

[~, ~, buttons, ~, ~, ~] = GetMouse;
relevantButtons = buttons([1 3]);

while ~any(relevantButtons) % wait for press
[~, ~, buttons, ~, ~, ~]  = GetMouse;
relevantButtons = buttons([1 3]);
end

while any(relevantButtons) % wait for release
[~, ~, buttons, ~, ~, ~]  = GetMouse;
relevantButtons = buttons([1 3]);
end

mouseClicked = true;
end
