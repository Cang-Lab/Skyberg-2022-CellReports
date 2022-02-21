
for ii = 1:length(NR_Selective)

    NRData_Selective(:,:,ii) = NR_Selective(ii).Normalized;

end


for ii = 1:length(DR_Selective)

    DRData_Selective(:,:,ii) = DR_Selective(ii).Normalized;

end


%%Normal Reared


for Tau = 1:500
    TempData = squeeze(NRData(:,Tau,:));
    [~,~,l,~,Ex] = pca(TempData);
    NR_Eigen(:,Tau) = l;
    NR_Explained(:,Tau) = Ex;
end

figure
plot(NR_Eigen')

figure
plot(NR_Explained') 

%%Normal Reared Selective

for Tau = 1:500
    TempData = squeeze(NRData_Selective(:,Tau,:));
    [~,~,l,~,Ex] = pca(TempData);
    NR_Eigen_Selective(:,Tau) = l;
    NR_Explained_Selective(:,Tau) = Ex;fc
end

figure
plot(NR_Eigen_Selective')

figure
plot(NR_Explained_Selective') 

%%Dark Reared

for Tau = 1:500
    TempData = squeeze(DRData(:,Tau,:));
    [~,~,l,~,Ex] = pca(TempData);
    DR_Eigen(:,Tau) = l;
    DR_Explained(:,Tau) = Ex;
end

figure
plot(DR_Eigen')

figure
plot(DR_Explained') 

%%Dark Reared Selective

for Tau = 1:500
    TempData = squeeze(DRData_Selective(:,Tau,:));
    [~,~,l,~,Ex] = pca(TempData);
    DR_Eigen_Selective(:,Tau) = l;
    DR_Explained_Selective(:,Tau) = Ex;
end

figure
plot(DR_Eigen_Selective')

figure
plot(DR_Explained_Selective')    