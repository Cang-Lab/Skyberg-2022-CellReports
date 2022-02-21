
function Finding_SUs(Drive, Mouse, Section, NatImgBlocks, Condition)

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)]; % File path to load data from

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NatImgBlocks) '\' Mouse '_Section_' num2str(Section) '_' Condition ]; %file path to save processed data too

load([Save_FilePath '_Filt_Data.mat'])

load([Load_FilePath '_metrics.mat'])

tt = 0;
for Cluster = 1:length(Filt_Data)
    
    if Metrics(Cluster).isolation >= 0.96 && Metrics(Cluster).noise_overlap < 0.08
        tt = tt + 1; 
        SU_Data(tt).Cell = Cluster;
        SU_Data(tt).Iso = Metrics(Cluster).isolation;
        SU_Data(tt).Noise_Olp = Metrics(Cluster).noise_overlap;
        SU_Data(tt).FiringRate = Metrics(Cluster).firing_rate;
        SU_Data(tt).Normalized = Filt_Data(Cluster).NormalizedPSTH;
        SU_Data(tt).NoNorm = Filt_Data(Cluster).FilteredPSTH(:,1:500);
    end
   
end

save([Save_FilePath '_SU_Data.mat'], 'SU_Data');

end
