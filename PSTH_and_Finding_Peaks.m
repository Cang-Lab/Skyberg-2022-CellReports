
function PSTH_and_Finding_Peaks(Drive, Mouse, Section, BlocksRG)

 
if exist([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data' ]) == 0    %Creating Processed Data Folder if it doesnt exist
    
    mkdir([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section)],'Processed Data');
    
end

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)];

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(BlocksRG) '\'  Mouse '_Section_' num2str(Section)];


if exist(Save_FilePath) == 0
    
    mkdir([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data'], ['Block ' num2str(BlocksRG)]);
    
end


%--------------------COMBINING ALL RINGACH GRATING BLOCKS BEFORE PROCESSING

wb = waitbar(0, 'Combining Data from Identical Blocks');

    %Combining the timing of each ringach grating

load([Load_FilePath '_Parameters.mat']);                                                                                         %loading parameter file

Block_Numbers =find(strcmp(Parameters.StimulusType, 'Random Gratings')==1);                                     %Finding Blocks that use Ringach Gratings (called random grating in Hui code)

for Block_Repeats = 1:length(BlocksRG)                                                                         % Loading Stimulus Data and spikes for Ringach Grating Blocks
    
    Blocks_StimData{Block_Repeats,1} = [Load_FilePath '_BLK' num2str(BlocksRG(Block_Repeats)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(BlocksRG(Block_Repeats)) '_stimulusData.mat'];
    
    Blocks_Spikes{Block_Repeats,1} = [Load_FilePath '_BLK' num2str(BlocksRG(Block_Repeats)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(BlocksRG(Block_Repeats)) '_firings.mat'];
    
end

clear Block_Repeats
            
if Block_Numbers(1) > 1                                                                                        % Rescaling Parameters.Range to exclude blocks before the first Ringach Grating Block 
    
    Parameters.Range = Parameters.Range - Parameters.Range(2, (Block_Numbers(1)-1));                            %subtracting the time from blocks before the first ringach grating 
    
    UsedBlock_Ranges(:,1) = Parameters.Range(:,Block_Numbers(1));
else
    
    UsedBlock_Ranges(:,1) = Parameters.Range(:,Block_Numbers(1));                                               %if the first ringach grating was the first block of a section then the time range is correct
    
end

if length(Block_Numbers) > 1                                                                                  % Rescaling Parameters.Range to account for any non-ringach grating blocks inbetween ringach grating blocks (e.g. if blk 2 and 4 are RG blocks and blk 3 is a checkerboard)
    
    for Block = 2:length(Block_Numbers)   

        if Block_Numbers(Block)-1 == Block_Numbers(Block-1)                                           % if the next used block is the previos block +1 then the timing is already correct (there isnt a block between that needs to be accounted for)

            UsedBlock_Ranges(:,Block) = Parameters.Range(:,Block_Numbers(Block));

        else                                                                                            % If there is an unwanted block between the ringach gratings these line account for the timing of that block

            UnusedPart = Parameters.Range(1,Block_Numbers(Block))- Parameters.Range(1,Block_Numbers(Block-1)+1);

            Parameters.Range = Parameters.Range - UnusedPart;

            UsedBlock_Ranges(:,Block) = Parameters.Range(:,Block_Numbers(Block));

            clear UnusedPart

        end

    end

end
clear Block Parameters Block_Parameters

            %Combining Condition Numbers and Stimulus Onsets for each ringach grating block
Comb_ConditionNumbers = [];
Comb_StimulusOnsets = [];

waitbar(.4, wb, 'Combining Stimulus Data');

for Block = 1:length(Blocks_StimData) 
    
    load(Blocks_StimData{Block});
    
    StimulusData.stimulusOnsets = StimulusData.stimulusOnsets + (UsedBlock_Ranges(1,Block)-1);      %adjusting stimulus onsets to account for the new ranges that come from combining all blocks
    
    Comb_ConditionNumbers = [Comb_ConditionNumbers  StimulusData.conditionNumbers];                 %adding Condition numbers together
    
    Comb_StimulusOnsets = [Comb_StimulusOnsets StimulusData.stimulusOnsets];                        %adding adjusted stimulus onsets together
    
    clear StimulusData
    
end

clear Blocks_StimData Blocks 

            % Combining Spikes for each ringach grating block
          
waitbar(.8, wb, 'Combining Neural Data');
            
for Block = 1:length(Blocks_Spikes)  
    
    load(Blocks_Spikes{Block},'Data');
    
    if Block == 1
        
        Comb_Spikes = Data;
        
        Comb_Spikes = rmfield(Comb_Spikes, 'SpikeTimes');
        
    else
        
        for Conditions = 1:length(Data)

            Data(Conditions).SpikePoints = Data(Conditions).SpikePoints + UsedBlock_Ranges(2,Block-1);

            Comb_Spikes(Conditions).SpikePoints = [Comb_Spikes(Conditions).SpikePoints  Data(Conditions).SpikePoints];

        end
    
    end
    
    clear Data Conditions
    
end

            %Saving combined data into one really big, clunky file, careful
            %this fatty takes forever to load
            
CombinedData.Mouse = Mouse;
CombinedData.Section = Section;
CombinedData.Blocks = BlocksRG;
CombinedData.BlockRanges = UsedBlock_Ranges;
CombinedData.Conditions = Comb_ConditionNumbers;
CombinedData.Onsets = Comb_StimulusOnsets;
CombinedData.Spikes = Comb_Spikes;

%save([Save_FilePath '_CombinedData.mat'], 'CombinedData');

close(wb)

clear Block Block_Numbers UsedBlock_Ranges Comb_ConditionNumbers Comb_StimulusOnsets Comb_Spikes Blocks_Spikes wb

%-----------------------------------------------Calculating PSTHs for each condition

wb = waitbar(0, 'Calculating PSTH and Timing Data');

load([Load_FilePath '_BLK' num2str(BlocksRG(1)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(BlocksRG(1)) '_stimulusData.mat']); %loading data to find blank conditions

Blanks = find(StimulusData.Parameters.freq == 0);     %finding all condition #s that are blanks for averaging blanks

BlanksDephased = unique(ceil((Blanks/4)));    % the N numbers that represent blanks in the dephased data(N should = number of Orientations used in stimulus)

clear StimulusData

FILTWIN = ones(333,1)/333;                                                  %Square wave filter one frame wide for smoothing psth (16.6ms = 333 recording points.....20kHz)

FILTWIN2 = ones(5,1)/5;                                                     %Square wave filter for smoothing varaiance plot

for Cluster = 1:length(CombinedData.Spikes);                                %Looping through all Clusters
    
    waitbar((Cluster/length(CombinedData.Spikes)),wb, 'Calculating PSTH and Timing Data');
    
    for Condition = 1:max(CombinedData.Conditions);                                                  %Looping through each condition
        
        [column] = find(CombinedData.Conditions == Condition);              %Finds when each condition was presented (in recording points not time)
        
        ConditionTiming{Condition,1} = CombinedData.Onsets(column);         %Finds the onset of each condition repeat
        
        for Repeat1 = 1:length(ConditionTiming{Condition,1});               %Looping through repeats for each condition
            
            tempIndex = find(CombinedData.Spikes(Cluster).SpikePoints > ConditionTiming{Condition,1}(Repeat1) - 333 & (CombinedData.Spikes(Cluster).SpikePoints <= ConditionTiming{Condition,1}(Repeat1) + 5000));      %Finds Spikes after Condition Onset and before Condition onset plus 5333 recording points (.25s)
            
            SpikesByCondition{Condition,1}{Repeat1} = CombinedData.Spikes(Cluster).SpikePoints(1,tempIndex) + 333 - ConditionTiming{Condition,1}(Repeat1); %Saves Spikes after condition to SpikesByCondition variable
            
            clear tempIndex
        end   
        
        temp_PSTH = zeros(length(SpikesByCondition{Condition,1}),5333);     %Create temporary matrix (Repeats x Time) to place spikes
        
        for Repeat2 = 1:length(SpikesByCondition{Condition,1});             %Loop through repeats of each condition
            
            for Spikes = 1:length(SpikesByCondition{Condition,1}{1,Repeat2});       %Loop through number of spikes for each repeat
                
                temp_PSTH(Repeat2,SpikesByCondition{Condition,1}{1,Repeat2}(1,Spikes)) = 1;     %Place a 1 where ever a spike occured 
                
            end
            
        end
        
        AveragePSTH(Condition,:) = mean(temp_PSTH);                         %Average across all repeats for each condition
        
        clear temp_PSTH
        
        FilteredPSTH(Condition,:) = filter(FILTWIN,1,AveragePSTH(Condition,:));     %Filter the averaged PSTH with FILTWIN
        
    end
    
    FilteredPSTH = FilteredPSTH(:,334:5333);                                %getting rid of the first 333 points that get messed up when using a square wave filter 333 points wide
    
    for cond = 1:length(FilteredPSTH(:,1));                                 %Averaging across time to reach 1ms resolution
        
        ii=0;
        
        for ms = 1:20:5000;
            
            ii = ii+1;
            
            FilteredPSTH_ms(cond,ii) = sum(FilteredPSTH(cond,ms:ms+19))/20;
            
        end
    end
    
    clear cond ms ii
    
    CombinedData.Spikes(Cluster).SpikesByCondition = [SpikesByCondition];                  %Saving SpikesByCondition variable to Data structure
    
    Filt_Data(Cluster).AllConditions = FilteredPSTH_ms;
    
    Filt_Data(Cluster).AverageBlanks = mean(Filt_Data(Cluster).AllConditions(Blanks,:)); %creating an average blank condition
    
    clear AveragePSTH ConditionTiming column FilteredPSTH_ms Condition SpikesByCondition Spikes Filtered_PSTH FilteredPSTH Repeat1 Repeat2
    
        %--------------------------------------------Subtracting the blanks
    
    TempData = Filt_Data(Cluster).AllConditions - Filt_Data(Cluster).AverageBlanks;
    
    %--------Finding the time at peak 1 and 2 using derivative of variance
   
    Var_TempData = var(TempData);
    
    Filtered_Var_TempData = filter(FILTWIN2, 1, Var_TempData);
    Filtered_Var_TempData = flip(Filtered_Var_TempData);
    Filtered_Var_TempData = filter(FILTWIN2, 1, Filtered_Var_TempData);
    Filtered_Var_TempData = flip(Filtered_Var_TempData);
    clear Var_TempData
    
    for yy = 2:length(Filtered_Var_TempData)
        
        Deriv1_Filt(yy) = Filtered_Var_TempData(1,yy) - Filtered_Var_TempData(1,yy-1);
        
    end
    
    clear yy
   
    Threshold = (mean(Filtered_Var_TempData(1,1:30)) + std(Filtered_Var_TempData(1,1:30))*4);
    
    tOnset = find(Filtered_Var_TempData(30:end) >= Threshold,1, 'first') + 29;
    
        if isempty(tOnset); 
            
            tOnset = 8;
            
        end
        
    tOffset = find(Filtered_Var_TempData(tOnset:175) >= Threshold, 1, 'last') + tOnset - 1;
    
        if isempty(tOffset);
            
            tOffset = 12;
            
        end
        
    Peak1_temp1 = find(Deriv1_Filt(tOnset:tOffset) <= 0, 1, 'first') + tOnset - 1;
    
    Peak1_temp2 = Peak1_temp1 - 1;
    
        if Filtered_Var_TempData(1,Peak1_temp1) > Filtered_Var_TempData(1,Peak1_temp2);
            
            Peak1 = Peak1_temp1;
            
        else
            
            Peak1 = Peak1_temp2;
            
        end

        if isempty(Peak1)
            
            Peak1 = 9;
            
        end
    
    Trough_temp1 = find(Deriv1_Filt(Peak1_temp1:tOffset) >= 0, 1, 'first') + Peak1_temp1 - 1;
    
    Trough_temp2 = Trough_temp1 - 1;
    
        if Filtered_Var_TempData(1, Trough_temp1) > Filtered_Var_TempData(1, Trough_temp2);
            
            Trough = Trough_temp2;
            
        else
            Trough = Trough_temp1;
            
        end

        if isempty(Trough);
            
            Trough = 10;
            
        end
    
    Peak2_temp1 = find(Deriv1_Filt(Trough_temp1:tOffset) <= 0, 1, 'first') + Trough_temp1 - 1;
    
    Peak2_temp2 = Peak2_temp1 - 1;
    
        if Filtered_Var_TempData(1,Peak2_temp1) > Filtered_Var_TempData(1,Peak2_temp2);
            
            Peak2 = Peak2_temp1;
            
        else
            
            Peak2 = Peak2_temp2;
            
        end

        if isempty(Peak2)
            
            Peak2 = 11;
            
        end
        
    clear Peak1_temp1 Peak1_temp2 Peak2_temp1 Peak2_temp2 Trough_temp1 Trough_temp2
    
    TimingData(Cluster).VR.Filt_Var = Filtered_Var_TempData;
    TimingData(Cluster).VR.Threshold = Threshold;
    TimingData(Cluster).VR.tOnset = tOnset;
    TimingData(Cluster).VR.tOffset = tOffset;
    TimingData(Cluster).VR.Peak1 = Peak1;
    TimingData(Cluster).VR.Trough = Trough;
    TimingData(Cluster).VR.Peak2 = Peak2;
    
    clear tOnset tOffset Trough Peak2 Threshold Filtered_Var_TempData Deriv1_Filt
    
    for Condition = 1:length(TempData(:,Peak1));
        
        Filt_Data(Cluster).ResponseAtPeak1(Condition,1) = max(TempData(Condition,Peak1-5:Peak1+5));
        
    end
    
    clear Peak1 Condition
    
        %----------------------------------------getting rid of phase
    
    ii = 0;
    jj = 1;
    tt = 0;
    
    for Dephaser = 1:4:max(CombinedData.Conditions)
        
        ii = ii + 1;
        
            if ii == BlanksDephased(jj)
                
                if jj < length(BlanksDephased)
                    
                    jj = jj + 1;
                    
                end
                
            else
                
                tt = tt + 1;
                
                F0 = mean(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1));
                
                F1 = max(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1)) - min(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1));
                
                Filt_Data(Cluster).F1F0(tt,1) = F1/F0;
                
                clear F1 F0
                
                
%                   [row] = find(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1) == max(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1))) + Dephaser - 1;
%                     Filt_Data(Cluster).Normalized(tt,:) = TempData(row,:);
%                     clear row

                if Filt_Data(Cluster).F1F0(tt,1) >= 1
                    
                    [row] = find(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1) == max(Filt_Data(Cluster).ResponseAtPeak1(Dephaser:Dephaser+3,1))) + Dephaser - 1;
                    
                    Filt_Data(Cluster).Normalized(tt,:) = TempData(row(1),:);
                    
                    clear row
                    
                else
                    
                    Filt_Data(Cluster).Normalized(tt,:) = mean(TempData(Dephaser:Dephaser+3,:));
                    
                end
                    
            end
    end
    
    clear ii jj tt Dephaser TempData

end

save([Save_FilePath '_Filt_Data.mat'], 'Filt_Data');

save([Save_FilePath '_CombinedData.mat'], 'CombinedData');

save([Save_FilePath '_TimingData.mat'], 'TimingData');

close(wb)

clear FILTWIN FILTWIN2 Blanks4 Blanks16 Load_FilePath Save_FilePath TimingData CombinedData Filt_Data Cluster wb

display('derp')

end

% the end, thanks for reading -rolf