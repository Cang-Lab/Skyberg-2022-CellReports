
function Time_Averaged_Tuning_Properties(Drive, Mouse, Section)

wb = waitbar(0, 'Computing Time Averaged Tuning Properties');

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)];
Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section)];

load([Save_FilePath '_Filt_Data.mat']); %loading data file created from psth script
load([Save_FilePath '_TimingData.mat']); %loading timing data file

SF = [0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32 0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32 0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32 0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32];

Ori = [0 45 90 135];



for Cluster = 1:length(Filt_Data)
    waitbar((Cluster/length(Filt_Data)), wb, 'Computing Time Averaged Tuning Properties');
     %-----------Calculating Time Averaged Response 
     
    for Condition = 1:length(Filt_Data(Cluster).Normalized(:,1))
        
        [col] = find(Filt_Data(Cluster).Normalized(Condition, TimingData(Cluster).VR.tOnset:TimingData(Cluster).VR.tOffset) > 0) + TimingData(Cluster).VR.tOnset - 1;
        
        BTP(Cluster).TA_Response(Condition,1) = sum(Filt_Data(Cluster).Normalized(Condition,col));
        
        [col1] = find(Filt_Data(Cluster).Normalized(Condition, TimingData(Cluster).VR.tOnset:TimingData(Cluster).VR.tOffset) < 0) + TimingData(Cluster).VR.tOnset - 1;
        
        BTP(Cluster).TA_Suppression(Condition,1) = sum(Filt_Data(Cluster).Normalized(Condition,col1));
              
        if isempty(col)
            
            BTP(Cluster).Max_Response(Condition,1) = 0;
            
        else
            
            BTP(Cluster).Max_Response(Condition,1) = max(Filt_Data(Cluster).Normalized(Condition, col));
            
        end
        
        clear col col1
        
    end
    
    clear Condition
    
    %----------------Calculating orientation and spatial frequency preferences
    
    [row] = find(max(BTP(Cluster).TA_Response) == BTP(Cluster).TA_Response,1);
    
    BTP(Cluster).SF_Pref_TA = SF(row);
    
    BTP(Cluster).Ori_Pref_TA = Ori(ceil(row/10));
    
    
    [row1] = find(max(BTP(Cluster).Max_Response) == BTP(Cluster).Max_Response,1);
    
    BTP(Cluster).SF_Pref_Max = SF(row1);
    
    BTP(Cluster).Ori_Pref_Max = Ori(ceil(row1/10));
    
    clear row row1
    
    for ii = 1:10
        
        temp = find(SF == SF(ii));    %calculating gOSI using the excitation values

        data_Max(1:4) = BTP(Cluster).Max_Response(temp,1);

        R_Max = sum(data_Max.*exp(j.*2.*deg2rad(Ori)))/sum(data_Max);

        prefD_Max = rad2deg(unwrap(angle(R_Max)))/2;
 
        gOSI_Max = abs(R_Max);

        BTP(Cluster).gOSI(ii,1) = gOSI_Max;

        BTP(Cluster).prefD(ii,1) = prefD_Max;

        clear temp data_Max R_Max prefD_Max gOSI_Max
    
    end
    
    clear ii
    
end

clear Cluster SF Ori 
 
save([Save_FilePath '_BTP.mat'], 'BTP');

close(wb) 

clear Load_FilePath Save_FilePath BTP Filt_Data TimingData wb

end

% the end, thanks for reading - rolf