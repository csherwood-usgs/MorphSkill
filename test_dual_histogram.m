% test_dual_histogram
% Make overlapping histograms of dep/erosion

clear
load('Matanzas_prestorm_topobathy.mat')
% Observed and modelled change:
d_obs = h_obs-h_pre;
d_mod = h_mod-h_pre;
%%
figure(3); clf
h1=histogram(d_obs,'binlimits',[-2 2],'orientation','horizontal','binmethod','scott','normalization','count','facecolor',[.9 .3 .3],'facealpha',.5,'edgecolor','none')
hold on
h2=histogram(d_mod,'binlimits',[-2 2],'orientation','horizontal','binmethod','scott','normalization','count','facecolor',[.3 .3 .9],'facealpha',.5,'edgecolor','none')
ylabel('\leftarrow Erosion (m) Deposition \rightarrow','fontsize',14)
xlabel('Count','fontsize',14)
box off
axis tight
legend([h1;h2],'Observed','Modeled','location','northeast')
xlim([0 25000])
set(gca,'xtick',[0,10000,20000],'xticklabels',{'0','10,000','20,000'})
% histf(H2,-1.3:.01:1.3,'facecolor',cmap3(2,:),'facealpha',.5,'edgecolor','none')
% histf(H3,-1.3:.01:1.3,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
% box off
% axis tight
% legalpha('H1','H2','H3','location','northwest')