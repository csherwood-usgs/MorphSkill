% TS_skill - Investigate use of running cross-correlation for skill

load 41112_Hs_ts.mat

% At this point, model and data time series should be same length
% and sampled at same times
M = (Hs_mod);
O = (Hs_obs);
dt = diff(t(1:2))*24 % assume constant dt, convert to hours

figure(1); clf
plot(t,M)
hold on
plot(t,O)

%% RMSE
rmse = rms(Hs_mod-Hs_obs)

%% Cross-correlation
np = length(M)
k = 25 % kernal length
k2 = floor(k/2)
maxlags = 7 % max lage
didx = 3
idx = [(k2+1):didx:np-k2]


%% Calc. cross-correlation for whole time series
% Not sure how the numbers calc'd with 'biased' and 'unbiased' relate to
% magnitude of diff. between time series. 'Biased' reduces influence at
% greater lags.
[C,lags] = xcorr(M,O,maxlags,'biased')
[Cmax, ilagmx] = max(C)
ilag0 = maxlags+1
Clag0 = C(ilag0)
figure(2); clf
plot(lags*dt,C)
hold on
plot(lags(ilag0)*dt,Clag0,'o')
plot(lags(ilagmx)*dt,Cmax,'x')

tc = t(idx);
Cmaxt = zeros(size(tc));
Clag0t = zeros(size(tc));
ilagmxt = zeros(size(tc));
for i=1:length(idx)
    idxi = idx(i)-k2:idx(i)+k2
    Mi = M(idxi);
    Oi = O(idxi);
    [Ci,lagsi] = xcorr(Mi,Oi,maxlags,'unbiased');
    [Cmaxi, ilagmxi] = max(Ci)
    Cmaxt(i) = Cmaxi;
    Clag0t(i) = Ci(maxlags+1);
    ilagmxt(i) = ilagmxi;
    figure(3); clf
    subplot(211)
    plot(t(idxi),Mi)
    hold on
    plot(t(idxi),Oi)
    subplot(212)
    plot(lagsi*dt,Ci)
    hold on
    plot(lags(maxlags+1)*dt,Clag0t(i),'o')
    plot(lags(ilagmxt(i))*dt,Cmaxt(i),'x')
    pause
end
figure(4);clf
subplot(211)
plot(tc,Clag0t)
hold on
plot(tc,Cmaxt)
subplot(212)
plot(tc,ilagmxt)