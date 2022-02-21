function Spatial_Frequency_Temporal_Dynamics(Drive, Mouse, Section)

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)];

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section)];

load([Save_FilePath '_Filt_Data.mat']);

load([Save_FilePath '_TimingData.mat']);

% 
wb = waitbar(0, 'Computing Variance and Timing Data');

FILTWIN1 = ones(10,1)/10;

for Cluster = 1:length(Filt_Data);  %Calculating Variance data and Max Min data for each cluster 
 
    waitbar((Cluster/length(Filt_Data)), wb, 'Computing Variance and Timing Data');
    
    MaxR(1,:) = max(Filt_Data(Cluster).Normalized);
    
    MinR(1,:) = min(Filt_Data(Cluster).Normalized);
    
    tMax = find(MaxR(1,:) == max(MaxR(1,:)),1);       %Time at Max
    
    tMin = find(MinR(1,:) == min(MinR(1,:)),1);       %time at Min
    
    HH = (max(MaxR)+ mean(MaxR(1,1:40)))/2;                    %Half of the Max Heigth
   
    FiltMaxR = filter(FILTWIN1,1,MaxR);
    
    FiltMaxR = flip(FiltMaxR);
    
    FiltMaxR = filter(FILTWIN1,1,FiltMaxR);
    
    FiltMaxR = flip(FiltMaxR);
    
    tDev = find(FiltMaxR(1,1:tMax) >= HH, 1, 'first');           %Time at tDev
    
    if isempty(tDev) == 1;
        
        tDev = 2;
        
    end
    
    for LL = 2:length(FiltMaxR)
        
        D_FiltMaxR(LL) = FiltMaxR(1,LL) - FiltMaxR(1,LL-1);
        
    end
    
    clear LL
    
    Peak1_temp1 = find(D_FiltMaxR(1,tDev:end) <= 0, 1, 'first') + tDev - 1;
    
    Peak1_temp2 = Peak1_temp1 - 1;
    
    if Peak1_temp1 == 1
        
        Peak1_temp2 = 2;
        
    end
    
    if FiltMaxR(1,Peak1_temp1) > FiltMaxR(1,Peak1_temp2)
        
        Peak1 = Peak1_temp1;
        
    else
        
    	Peak1 = Peak1_temp2;
        
    end
    
    if isempty(Peak1)
        
        Peak1 = 9;
        
    end
    
    if Peak1_temp1 + 30 >250;
        
        Peak1Plus = 250;
        
    else
        
        Peak1Plus = Peak1_temp1 + 30;
        
    end
    
    Trough_temp1 = find(D_FiltMaxR(1,Peak1_temp1:Peak1Plus) >= 0, 1, 'first') + Peak1_temp1 - 1;
    
    Trough_temp2 = Trough_temp1 -1;
    
    if Trough_temp1 == 1
        
        Trough_temp2 = 2;
        
    end

    if FiltMaxR(1,Trough_temp1) > FiltMaxR(1,Trough_temp2);
        
        Trough = Trough_temp2;
        
    else
        
        Trough = Trough_temp1;
        
    end
    
    if isempty(Trough)
        
        Trough = 8;
        
    end
    
    if Trough > Peak1
        
        if Trough + 30 >250;
            
            TroughPlus = 250;
            
        else
            
            TroughPlus = Trough + 30;
            
        end
        
        Peak2_temp1 = find(D_FiltMaxR(1,Trough:TroughPlus) >= 0, 1, 'first') + Trough_temp1 - 1;
        
        Peak2_temp2 = Peak2_temp1;
        
        if Peak2_temp1 == 1
            
            Peak2_temp2 = 2;

        end
        
        if FiltMaxR(1,Peak2_temp1) > FiltMaxR(1,Peak2_temp2);
            
            Peak2 = Peak2_temp1;
            
        else
            
            Peak2 = Peak2_temp2;
            
        end

        if isempty(Peak2)
            
            Peak2 = 11;
            
        end
    else
        
           Peak2 = 11;
           
    end
    
    clear Peak1_temp1 Peak1_temp2 Trough_temp1 Trough_temp2 Peak2_temp1 Peak2_temp2
    
    if Peak2 > Peak1;
        
        tDecay = find(FiltMaxR(1,Peak2:end) <= HH, 1, 'first') + Peak2 - 1; 
        
    else
        
        tDecay = find(FiltMaxR(1,Peak1:end) <= HH, 1, 'first') + Peak1 - 1;
        
    end

    
    if isempty(tDecay) == 1;
        
        tDecay = length(Filt_Data(Cluster).Normalized);
        
    end
   TimingData(Cluster).MM.MaxR = MaxR;
   TimingData(Cluster).MM.MinR = MinR;
   TimingData(Cluster).MM.tDev = tDev;
   TimingData(Cluster).MM.tDecay = tDecay;
   TimingData(Cluster).MM.tMax = tMax;
   TimingData(Cluster).MM.Peak1 = Peak1;
   TimingData(Cluster).MM.Trough = Trough;
   TimingData(Cluster).MM.Peak2 = Peak2;
   
clear tMax tDev tDecay tMax HH tMin NormalizedPSTH MaxR MinR VRMMpeak Peak1 Peak2 Trough TroughPlus Peak1Plus FiltMaxR D_FiltMaxR
     
end

save([Save_FilePath '_TimingData.mat'], 'TimingData');

close(wb)

clear Cluster FILTWIN1 wb

% Creating Interpolated Data for Further Processing 

wb = waitbar(0, 'Generating Interpolated Data');

SF = [0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32];

Interpolated_Range = 0.02:1/1000:0.32;

for Cluster = 1:length(Filt_Data)
    
    waitbar((Cluster/length(Filt_Data)), wb, 'Generating Interpolated Data');
    
    for Ori_Range = 1:10:40
        
        for Tau = 1:length(Filt_Data(Cluster).Normalized)

            TempData = Filt_Data(Cluster).Normalized(Ori_Range:Ori_Range+9,Tau);
            
            Interpolated_TempData = interp1(SF, TempData, Interpolated_Range, 'pchip');
            
            if Ori_Range == 1
                
                Interpolated_Data(Cluster).ID(:,Tau,1) = Interpolated_TempData;
                
            elseif Ori_Range == 11
                
                Interpolated_Data(Cluster).ID(:,Tau,2) = Interpolated_TempData;
                
            elseif Ori_Range == 21
                
                Interpolated_Data(Cluster).ID(:,Tau,3) = Interpolated_TempData;
                
            elseif Ori_Range == 31
                
                Interpolated_Data(Cluster).ID(:,Tau,4) = Interpolated_TempData;
                
            end
            
            clear TempData Interpolated_TempData
            
        end  
        
        clear Tau
    
    end
    
    clear Ori_Range
    
end

save([Save_FilePath '_Interpolated_Data.mat'], 'Interpolated_Data');

close(wb)

clear Filt_Data Cluster SF wb

% Calculating Temporal Dynamics of Spatial Frequeny Tuning Data

wb = waitbar(0, 'Computing Temporal Dynamics');

Interpolated_Range = 0.02:1/1000:0.32;

for Cluster = 1:length(Interpolated_Data) 
    
    waitbar((Cluster/length(Interpolated_Data)), wb, 'Computing Temporal Dynamics');
    
    for Ori = 1:length(Interpolated_Data(Cluster).ID(1,1,:))
       
        for Tau = 1:length(Interpolated_Data(Cluster).ID(1,:,Ori))
           
            TempData = Interpolated_Data(Cluster).ID(:,Tau,Ori);
            
            fMaxR = max(TempData);
            
            fPeak = find(TempData == fMaxR,1);
            
            Cutoff = fMaxR/sqrt(2);
           
            fLow = find(TempData(1:fPeak) <= Cutoff, 1, 'last');
            
                if isempty(fLow) == 1

                    fLow = 1;
                    
                end
                
            fHigh = find(TempData(fPeak:end) <= Cutoff, 1, 'first') + fPeak - 1;
                
                if isempty(fHigh) == 1
                    
                    fHigh = length(TempData);
                    
                end
            
            SFTD(Cluster).fLow(Ori,Tau) = Interpolated_Range(1, fLow);
            
            SFTD(Cluster).fPeak(Ori,Tau) = Interpolated_Range(1, fPeak);
            
            SFTD(Cluster).fHigh(Ori,Tau) = Interpolated_Range(1, fHigh);
                
            SFTD(Cluster).Q(Ori,Tau) = SFTD(Cluster).fPeak(Ori,Tau)/(SFTD(Cluster).fHigh(Ori,Tau) - SFTD(Cluster).fLow(Ori,Tau));
            
            SFTD(Cluster).ML(Ori,Tau) = SFTD(Cluster).fLow(Ori,Tau)/SFTD(Cluster).fPeak(Ori,Tau);
            
            SFTD(Cluster).MH(Ori,Tau) = SFTD(Cluster).fPeak(Ori,Tau)/SFTD(Cluster).fHigh(Ori,Tau);
            
            SFTD(Cluster).LSFS(Ori,Tau) = TempData(1,1)/fMaxR;
            
            SFTD(Cluster).HSFS(Ori,Tau) = TempData(length(TempData),1)/fMaxR;
            
            AeAs(Cluster).Ae(Ori,Tau) = sum(TempData(TempData >= 0));
            
            AeAs(Cluster).As(Ori,Tau) = abs(sum(TempData(TempData < 0)));
            
            AeAs(Cluster).SupIndex(Ori,Tau) = AeAs(Cluster).As(Ori,Tau)/(AeAs(Cluster).As(Ori,Tau) + AeAs(Cluster).Ae(Ori,Tau));
            
            clear fLow fPeak fHigh fMaxR Cutoff TempData

        end
        
        SFTD(Cluster).DeltafPeak(Ori,1) = SFTD(Cluster).fPeak(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).fPeak(Ori,TimingData(Cluster).MM.tDev);
        
        SFTD(Cluster).DeltaQ(Ori,1) = SFTD(Cluster).Q(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).Q(Ori,TimingData(Cluster).MM.tDev);
        
        SFTD(Cluster).DeltaLSFS(Ori,1) = SFTD(Cluster).LSFS(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).LSFS(Ori,TimingData(Cluster).MM.tDev);
        
        SFTD(Cluster).DeltaHSFS(Ori,1) = SFTD(Cluster).HSFS(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).HSFS(Ori,TimingData(Cluster).MM.tDev);
        
        SFTD(Cluster).DeltaML(Ori,1) = SFTD(Cluster).ML(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).MH(Ori,TimingData(Cluster).MM.tDev);
        
        SFTD(Cluster).DeltaMH(Ori,1) = SFTD(Cluster).MH(Ori,TimingData(Cluster).MM.tDecay) - SFTD(Cluster).MH(Ori,TimingData(Cluster).MM.tDev);
        
        clear Tau
        
    end
    
    clear Ori
    
end

save([Save_FilePath '_SFTD.mat'], 'SFTD');

save([Save_FilePath '_AeAs.mat'], 'AeAs');

close(wb)

clear Cluster Interpolated_Range wb

end