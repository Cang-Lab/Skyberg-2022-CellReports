function Computing_PCA_Nat_Img(Drive, Mouse, Section, NatImgBlocks, Condition)
Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)]; % File path to load data from

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NatImgBlocks) '\' Mouse '_Section_' num2str(Section) '_' Condition ]; %file path to save processed data too

load([Save_FilePath '_rSU_Data.mat'])


NumNatImgs = length(rSU_Data(1).Normalized(:,1));

for ii = 1:length(rSU_Data)
    PCA_Data(:,ii,:) = rSU_Data(ii).Normalized(1:NumNatImgs,:);
end

for Tau = 1:500
    TempData = squeeze(PCA_Data(:,:,Tau));
    [~,~,l,~,Ex] = pca(TempData);
    Eigen(:,Tau) = l;
    Explained(:,Tau) = Ex;
end
    
    



save([Save_FilePath '_PCA_Data.mat'], 'PCA_Data');
save([Save_FilePath '_Eigen.mat'], 'Eigen');
save([Save_FilePath '_Explained.mat'], 'Explained');

h = figure;
plot(Eigen(1:5,:)');
title([Mouse ' Section ' num2str(Section) ' Block(s) ' num2str(NatImgBlocks) ' - ' Condition]);

Fig_SavePath =[Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NatImgBlocks) '\Figs' ];

if exist(Fig_SavePath) == 0;
    
    mkdir(Fig_SavePath);
    
end


saveas(h, [Fig_SavePath '\EigenPlot'],'fig');
saveas(h, [Fig_SavePath '\EigenPlot'],'emf');
saveas(h, [Fig_SavePath '\EigenPlot'], 'jpg');
end