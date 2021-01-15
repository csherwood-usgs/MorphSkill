
clear
load('Matanzas_prestorm_topobathy.mat')
% Observed and modelled change:
d_obs = h_obs-h_pre;
d_mod = h_mod-h_pre;

% trim out offshore region
d_obs = d_obs(1:200,:);
d_mod = d_mod(1:200,:);

% Threshold for "significant" change 
thresh = 0.2

% three possible observed conditions (erosion, no change, depostion)
oe = (d_obs < -thresh);
on = (d_obs >= -thresh) & (d_obs <= thresh);
od = (d_obs > thresh);
% three possible modeled conditions (erosion, no change, depostion)
me = (d_mod < -thresh);
mn = (d_mod >= -thresh) & (d_mod <= thresh);
md = (d_mod > thresh);

% check that these are all ones
obs = oe+on+od;
mod = me+mn+md;
% these should agree:
size(d_obs(:))
sum(obs(:))
sum(mod(:))

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

% matrix
all = [ sum(oeme(:)), sum(oemn(:)), sum(oemd(:));...
        sum(onme(:)), sum(onmn(:)), sum(onmd(:));...
        sum(odme(:)), sum(odmn(:)), sum(odmd(:))];
% check
sum(oeme+oemn+oemd+onme+onmn+onmd+odme+odmn+odmd);
sum(all(:))
disp(all)
alln = all./sum(all(:));

%%
% In the following "event" means significant (>thresh) erosion or
% depostion:
% H - hits - # times event predicted and observed
% M - misses # times event was observed but not predicted
% F - false alarms # times event was predicted but did not occur
% C - correct rejections - # times even was not predicted and did not

% H - hits - # times event predicted and observed
Ha = oeme+odmd;
H = sum(Ha(:))

% M - misses # times event was observed but not predicted
Ma = oemd+oemn+odme+odmn;
M = sum(Ma(:))

% F - false alarms # times event was predicted but did not occur
Fa = onmd+onme;
F = sum(Fa(:))

% C - correct rejections - # times even was not predicted and did not
Ca = onmn;
C = sum(Ca(:))

% these should agree:
size(d_obs(:))
J = sum(H+M+F+C)

% Bias - number of times even was predicted v. number of times it occurred
Bias = (H+F)/(H+M)

% PC - percent correct (actually, fraction correct) is ration of correct
% predictions as a freaction of total number of forecasts
PC = (H+C)/J

% FAR - false alarm rate - number of false predictions divided by the number
% of forecasts of event
FAR = F/(H+F)

% POD = probablility of detection - number of correct predictions dividedn
% by number of times event occurred
POD = H/(H+M)

% TS - Threat score - number of successful predictions of event divided by
% the number of predictions minus the number of correct rejections
TS = H/(H+F+M)

% G - sum of fraction of events that occurred that would be expeced from
% random choice plus fraction of events tht did not occur and wer predicted
% by chance not to occur
G = (H+F)*(H+M)/J^2 + (M+C)*(F+C)/J^2

% HSS - Heidke Skill Score
HSS = (PC-G)/(1-G)
%% map view of the categories
cmap2 = [ 1., .6, .6;... % -2 M  red
          .8, .8, .8,;...% -1 C  gray
          1, 1, 1;...    % 0 none  white
          .99 .75, .29;...% 1 F yellow
          .6, 1, .6];     % 2 H green
figure(2);clf
imagesc(2*Ha +  Fa + -1*Ca -2*Ma)
caxis([-2 2])
colormap(cmap2)
colorbar('ytick',[-1.5,-.75,0,.75,1.5],'yticklabel',{'Miss','Correct Reject',' ','False Alarm','Hit'})

%% map view of the matrix
cmap = cmocean('curl');

figure(1); clf
ax1 = subplot(431);
imagesc(d_obs)
caxis([-2 2])
colormap(ax1,cmap)
title('Observed Change')

ax2=subplot(432);
imagesc(d_mod)
caxis([-2 2])
colormap(ax2,cmap)
title('Modeled Change')

ax3=subplot(433);
imagesc(d_mod-d_obs)
caxis([-2 2])
colormap(ax3,cmap)
title('Mod. Change minus Obs. Changed')

ax4=subplot(434);
imagesc(2*oeme)
caxis([-2 2])
colormap(ax4,cmap2)
ts = sprintf('H: Obs. Erosion, Mod. Erosion %.2f',alln(1,1))
title(ts)

ax5=subplot(435);
imagesc(-2*oemn)
caxis([-2 2])
colormap(ax5,cmap2)
ts = sprintf('M: Obs. Erosion, Mod. NC %.2f',alln(1,2))
title(ts)

ax6=subplot(436);
imagesc(-2*oemd)
caxis([-2 2])
colormap(ax6,cmap2)
ts=sprintf('M: Obs. Erosion, Mod. Deposition %.2f',alln(1,3))
title(ts)

ax7=subplot(437);
imagesc(oemn)
caxis([-2 2])
colormap(ax7,cmap2)
ts=sprintf('F: Obs. NC, Mod. Erosion %.2f',alln(2,1))
title(ts)

ax8=subplot(438);
imagesc(-1*onmn)
caxis([-2 2])
colormap(ax8,cmap2)
ts=sprintf('C: Obs. NC, Mod. NC %.2f',alln(2,2))
title(ts)

ax9=subplot(439);
imagesc(onmd)
caxis([-2 2])
colormap(ax9,cmap2)
ts=sprintf('F: Obs. NC, Mod. Deposition %.2f',alln(2,3))
title(ts)

ax10=subplot(4,3,10);
imagesc(-2*odme)
caxis([-2 2])
colormap(ax10,cmap2)
ts=sprintf('M: Obs. Depostion, Mod. Erosion %.2f',alln(3,1))
title(ts)

ax11=subplot(4,3,11);
imagesc(-2*odmn)
caxis([-2 2])
colormap(ax11,cmap2)
ts=sprintf('M: Obs. Deposition, Mod. NC %.2f',alln(3,2))
title(ts)

ax12=subplot(4,3,12);
imagesc(2*odmd)
caxis([-2 2])
colormap(ax12,cmap2)
ts=sprintf('H: Obs. Deposition, Mod. Depsition %.2f',alln(3,3))
title(ts)

