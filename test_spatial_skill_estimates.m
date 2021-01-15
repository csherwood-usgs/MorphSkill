clear
load('Matanzas_prestorm_topobathy.mat')
% Observed and modelled change:
d_obs = h_obs-h_pre;
d_mod = h_mod-h_pre;

% trim out offshore region
d_obs = d_obs(1:200,:);
d_mod = d_mod(1:200,:);

cmap = cmocean('curl');

% Threshold for "significant" change / meas. error estimate
thresh = 0.2

% half-kernal dimensions for calc. skill
kx = 5
ky = 15

y = d_mod;
x = d_obs;
[ny,nx]=size(x);

BSS = NaN*ones(ny,nx);
d2 = NaN*ones(ny,nx);

xs=kx+1
xe=nx-kx-1
ys=ky+1
ye=ny-ky-1

for jx = xs:xe
    for iy = ys:ye
        ii = iy-ky:iy+kx;
        jj = jx-kx:jx+kx;
        skill = skill_estimates(x(ii,jj),y(ii,jj));
        BSS(iy,jx)=skill.BSS;
        d2(iy,jx)=skill.d2;
    end
end

figure(1);clf
imagesc(d2)
colormap(cmap)
caxis([0 1])
colorbar

figure(2);clf
imagesc(BSS)
caxis([-1 1])
colormap(cmap)
colorbar
