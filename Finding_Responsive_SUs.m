
function Finding_Responsive_SUs(Drive, Mouse, Section, NatImgBlocks, Condition)

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)]; % File path to load data from

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NatImgBlocks) '\' Mouse '_Section_' num2str(Section) '_' Condition ]; %file path to save processed data too

load([Save_FilePath '_SU_Data.mat'])


for ii = 1:length(SU_Data)
    
    h= figure
    subplot(2,1,1)
    imagesc(SU_Data(ii).Normalized)
    title(num2str(ii))
    
  
    subplot(2,1,2)
    plot(mean(SU_Data(ii).Normalized(:,:)))
    title(num2str(ii))
 
    uiwait(h)
end

Answer = inputdlg('Which clusters should NOT be included in subsequent analyses?');
NotResponsive = str2num(Answer{1});
NotResponsive = sort(NotResponsive, 'descend');

rSU_Data = SU_Data;
for Remover = NotResponsive;
    rSU_Data(Remover) = [];
end
clear Remover SU_Data NotResponsive h Answer

save([Save_FilePath '_rSU_Data.mat'], 'rSU_Data');

end