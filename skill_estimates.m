function skill = skill_estimates(x,y,thresh)
% Input:
%   x = Observed change
%   y = Modeled change
%   thresh = threshold for "significant" change (default = 0.1)
% Returns:
%   skill - Structure with a gazillion statistics
%
% Sutherland, Peet, and Soulsby (2004) "Evaluating the performance of
% morphological models" Coastal Engineering 51:917-939.

if(~exist('thresh','var')), thresh = .1; end

% Bias Eqn 3 and 4
bias_a = mean(y(:))-mean(x(:));
bias_m = median(y(:))-median(x(:));

% Accuracy
% Mean absolute error (MAE) Eqn. 5
MAE = mean( abs( y(:) - x(:) ), 'all');
% Mean square error (MSE) Eqn. 6
MSE = mean( ( y(:) - x(:) ).^2, 'all');
RMSE = sqrt(MSE);

% Correlation
sxy = mean((y(:)-mean(y(:))).*(x(:)-mean(x(:))),'all');
sx = std(x(:));
sy = std(y(:));
rxy = sxy/(sx*sy);

% Brier skill score, assuming baseline is no change
b = zeros(size(x));
BSS = 1-MSE/mean( (b(:)-x(:)).^2,'all');

yp = y-b;
xp = x-b;

% Components of BSS - Eqn. 16
sxyp = mean((yp(:)-mean(yp(:))).*(xp(:)-mean(xp(:))),'all');
sxp = std(xp(:));
syp = std(yp(:));
rxyp = sxyp/(sxp*syp);

alpha = rxyp^2;
beta = (rxyp - syp/sxp).^2;
gamma = ((mean(yp(:))-mean(xp(:)))/sxp)^2;
epsilon = (mean(xp(:))/sxp)^2;
BSS_check = (alpha-beta-gamma+epsilon)/(1+epsilon);

% Willmott (Eqns. 18 and 19)
d1 = 1. - mean(abs(y(:)-x(:)),'all')/mean( abs(y(:)-mean(x(:))) + abs(x(:)-mean(x(:))) ); 
d2 = 1. - mean(abs(y(:)-x(:)).^2,'all')/mean( (abs(y(:)-mean(x(:))) + abs(x(:)-mean(x(:)))).^2 );

% three possible observed conditions (erosion, no change, depostion)
oe = (x < -thresh);
on = (x >= -thresh) & (x <= thresh);
od = (x > thresh);
% three possible modeled conditions (erosion, no change, depostion)
me = (y < -thresh);
mn = (y >= -thresh) & (y <= thresh);
md = (y > thresh);

% check that these are all ones
obs = oe+on+od;
mod = me+mn+md;

% these should agree:
s = size(x);
if(s(1)*s(2) ~= sum(obs(:)) || sum(obs(:)) ~= sum(mod(:)))
    fprintf('Error in number of cases: %d %d\n',sum(obs(:)), size(x)  );    
end
% nine possible cases
oeme = (oe & me);
oemn = (oe & mn);
oemd = (oe & md);
onme = (on & me);
onmn = (on & mn);
onmd = (on & md);
odme = (od & me);
odmn = (od & mn);
odmd = (od & md);

% matrix of all possible cases
all = [ sum(oeme(:)), sum(oemn(:)), sum(oemd(:));...
        sum(onme(:)), sum(onmn(:)), sum(onmd(:));...
        sum(odme(:)), sum(odmn(:)), sum(odmd(:))];
% normalized to fraction    
alln = all./sum(all(:));

% check
if(sum(all(:)) ~= sum(oeme+oemn+oemd+onme+onmn+onmd+odme+odmn+odmd,'all'))
        fprintf('Error #2 in number of cases\n')
        sum(all(:))
        sum(oeme+oemn+oemd+onme+onmn+onmd+odme+odmn+odmd,'all')
end
alln = all./sum(all(:));

% In the following "event" means significant (>thresh) erosion or
% depostion:
% H - hits - # times event predicted and observed
% M - misses # times event was observed but not predicted
% F - false alarms # times event was predicted but did not occurd
% C - correct rejections - # times even was not predicted and did not

% H - hits - # times event predicted and observed
Ha = oeme+odmd;
H = sum(Ha(:));

% M - misses # times event was observed but not predicted
Ma = oemd+oemn+odme+odmn;
M = sum(Ma(:));

% F - false alarms # times event was predicted but did not occur
Fa = onmd+onme;
F = sum(Fa(:));

% C - correct rejections - # times even was not predicted and did not
Ca = onmn;
C = sum(Ca(:));

J = sum(H+M+F+C);

% Bias - number of times even was predicted v. number of times it occurred
Bias = (H+F)/(H+M);

% PC - percent correct (actually, fraction correct) is ration of correct
% predictions as a freaction of total number of forecasts
PC = (H+C)/J;

% FAR - false alarm rate - number of false predictions divided by the number
% of forecasts of event
FAR = F/(H+F);

% POD = probablility of detection - number of correct predictions dividedn
% by number of times event occurred
POD = H/(H+M);

% TS - Threat score - number of successful predictions of event divided by
% the number of predictions minus the number of correct rejections
TS = H/(H+F+M);

% G - sum of fraction of events that occurred that would be expected from
% random choice plus fraction of events tht did not occur and wer predicted
% by chance not to occur
G = (H+F)*(H+M)/J^2 + (M+C)*(F+C)/J^2;

% HSS - Heidke Skill Score
HSS = (PC-G)/(1-G);

% load structure for return values
skill.bias_a = bias_a;
skill.bias_m = bias_m;
skill.MAE = MAE;
skill.MSE = MSE;
skill.RMSE = RMSE;
skill.rxy = rxy;
skill.BSS = BSS;
skill.alpha = alpha;
skill.beta = beta;
skill.gamma = gamma;
skill.epsilon = epsilon;
skill.d1 = d1;
skill.d2 = d2;
skill.all = all;
skill.alln = alln;
skill.H = H;
skill.M = M;
skill.F = F;
skill.C = C;
skill.J = J;
skill.Bias = Bias;
skill.PC = PC;
skill.FAR = FAR;
skill.POD = POD;
skill.TS = TS;
skill.G = G;
skill.HSS = HSS;

return
end
