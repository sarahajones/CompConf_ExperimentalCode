%

mu_cat1 = (15/16).*(pi); %off the horizontal - check
mu_cat2 = (17/16).*(pi); % off thehorizontal - check
trialparams.kappa_s = 17; % 
alpha = [0:1/600*pi:2*pi];

dist1 = circ_vmpdf(alpha, mu_cat1, trialparams.kappa_s);
dist2 = circ_vmpdf(alpha, mu_cat2, trialparams.kappa_s);

figure
plot(alpha, dist1)
hold on
plot(alpha, dist2)

