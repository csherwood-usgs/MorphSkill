clear
load('Matanzas_prestorm_topobathy.mat')
% Observed and modelled change:
d_obs = h_obs-h_pre;
d_mod = h_mod-h_pre;

% trim out offshore region
d_obs = d_obs(1:200,:);
d_mod = d_mod(1:200,:);

% Threshold for "significant" change / meas. error estimate
thresh = 0.2;

y = d_mod;
x = d_obs;
skill = skill_estimates(x,y,thresh)