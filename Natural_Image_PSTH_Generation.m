

function Natural_Image_PSTH_Generation(Drive, Mouse, Section, NatImgBlocks, Condition)

if exist([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data' ]) == 0    %Creating Processed Data Folder if it doesnt exist
    
    mkdir([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section)],'Processed Data');
    
end

Load_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section)]; % File path to load data from

Save_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NatImgBlocks)]; %file path to save processed data too

if exist(Save_FilePath) == 0
    
    mkdir(Save_FilePath)
    
end

Save_FilePath = [Save_FilePath '\' Mouse '_Section_' num2str(Section) '_' Condition]; %file path to save processed data too


%% Combining the timing of each Natural Image Block

Block_Parameters = ([Load_FilePath '_Parameters.mat']); 

load(Block_Parameters);                                                                                         %loading parameter file


Block_Numbers = NatImgBlocks;

%Block_Numbers = find(strcmp(Parameters.StimulusType, 'ShowImages')==1);                                     %Finding Blocks that use Natural Images

for Block_Repeats = 1:length(NatImgBlocks)                                                                         % finding Stimulus Data (called Blocks_StimData) and spikes (called Blocks_Spikes) location for Ringach Grating Blocks
    
    Blocks_StimData{Block_Repeats,1} = [Load_FilePath '_BLK' num2str(NatImgBlocks(Block_Repeats)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(NatImgBlocks(Block_Repeats)) '_stimulusData.mat'];
    
    Blocks_Spikes{Block_Repeats,1} = [Load_FilePath '_BLK' num2str(NatImgBlocks(Block_Repeats)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(NatImgBlocks(Block_Repeats)) '_firings.mat'];
    
end

clear Block_Repeats
            
if Block_Numbers(1) > 1                                                                                        % Setting the first ringach grating block range appropriatly
    
    Parameters.Range = Parameters.Range - Parameters.Range(2, (Block_Numbers(1)-1));                            %subtracting the time from blocks before the first ringach grating 
    
    UsedBlock_Ranges(:,1) = Parameters.Range(:,Block_Numbers(1));
    
else
    
    UsedBlock_Ranges(:,1) = Parameters.Range(:,Block_Numbers(1));                                               %if the first ringach grating was the first block of a section then the time range is correct
    
end

if length(Block_Numbers) > 1                                                                                  % Setting the ranges for the rest of the ringach gratings appropriately
    
    for Block = 2:length(Block_Numbers)    %block 1 was adjusted above so this starts at the second block

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

%% Combining Condition Numbers and Stimulus Onsets for each natural image block

Comb_ConditionNumbers = [];
Comb_StimulusOnsets = [];


for Block = 1:length(Blocks_StimData) 
    
    load(Blocks_StimData{Block});
    
    StimulusData.stimulusOnsets = StimulusData.stimulusOnsets + (UsedBlock_Ranges(1,Block)-1);      %adjusting stimulus onsets to account for the new ranges that come from combining all blocks
    
    Comb_ConditionNumbers = [Comb_ConditionNumbers  StimulusData.conditionNumbers];                 %adding Condition numbers together
    
    indexer = 0;
    
    for Stim_On = 1:length(StimulusData.stimulusOnsets)
        
        indexer = indexer + 1;
       
        Adjusted_StimulusOnsets(1, indexer) = StimulusData.stimulusOnsets(1, Stim_On);
        
    end
    
    Comb_StimulusOnsets = [Comb_StimulusOnsets Adjusted_StimulusOnsets];                        %adding adjusted stimulus onsets together
    
    clear StimulusData indexer Adjusted_StimulusOnsets Stim_On
    
end

clear Block Block_StimData

for Block = 1:length(Blocks_Spikes)  
    
    load(Blocks_Spikes{Block},'Data');
    
    if Block == 1
        
        Comb_Spikes = Data;
        
        Comb_Spikes = rmfield(Comb_Spikes, 'SpikeTimes');
        
    else
        
        for Clusters = 1:length(Data)
        
            Data(Clusters).SpikePoints = Data(Clusters).SpikePoints + UsedBlock_Ranges(2,Block-1);
        
            Comb_Spikes(Clusters).SpikePoints = [Comb_Spikes(Clusters).SpikePoints  Data(Clusters).SpikePoints];
        
        end
    
    end
    
    clear Data Clusters
    
end

            %Saving combined data into one really big, clunky file, careful
            %this fatty takes forever to load
            
NatImg_CombinedData.Mouse = Mouse;
NatImg_CombinedData.Section = Section;
NatImg_CombinedData.Blocks = Block_Numbers;
NatImg_CombinedData.BlockRanges = UsedBlock_Ranges;
NatImg_CombinedData.Conditions = Comb_ConditionNumbers;
NatImg_CombinedData.Onsets = Comb_StimulusOnsets;
NatImg_CombinedData.Spikes = Comb_Spikes;

% save([Save_FilePath '_NatImg_CombinedData.mat'], 'NatImg_CombinedData');

clear Block UsedBlock_Ranges Comb_ConditionNumbers Comb_StimulusOnsets Comb_Spikes Blocks_Spikes 

%% Calculating PSTHs for each condition

wb = waitbar(0, 'Calculating PSTH and Timing Data');

load([Load_FilePath '_BLK' num2str(NatImgBlocks(1)) '\' Mouse '_Section_' num2str(Section) '_BLK' num2str(NatImgBlocks(1)) '_stimulusData.mat']); %loading data to find blank conditions

Blank = max(StimulusData.conditionNumbers);

clear StimulusData

FILTWIN = ones(333,1)/333;                                                  %Square wave filter one frame wide for smoothing psth (16.6ms = 333 recording points.....20kHz)



for Cluster = 1:length(NatImg_CombinedData.Spikes);                                %Looping through all Clusters
    
    waitbar((Cluster/length(NatImg_CombinedData.Spikes)),wb, 'Calculating PSTH and Timing Data');
    
    for Condition = 1:Blank;                                                  %Looping through each condition
        
        [column] = find(NatImg_CombinedData.Conditions == Condition);              %Finds when each condition was presented (in recording points not time)
        
        ConditionTiming{Condition,1} = NatImg_CombinedData.Onsets(column);         %Finds the onset of each condition repeat
        
        for Repeat = 1:length(ConditionTiming{Condition,1});               %Looping through repeats for each condition
            
            tempIndex = find(NatImg_CombinedData.Spikes(Cluster).SpikePoints > ConditionTiming{Condition,1}(Repeat) - 333 & (NatImg_CombinedData.Spikes(Cluster).SpikePoints <= ConditionTiming{Condition,1}(Repeat) + 20000));      %Finds Spikes after Condition Onset and before Condition onset plus 20000 recording points (.25s)
            
            SpikesByCondition{Condition,1}{Repeat} = NatImg_CombinedData.Spikes(Cluster).SpikePoints(1,tempIndex) + 333 - ConditionTiming{Condition,1}(Repeat); %Saves Spikes after condition to SpikesByCondition variable
            
            clear tempIndex
        end 
        
        clear Repeat
        
        temp_PSTH = zeros(length(SpikesByCondition{Condition,1}),20333);     %Create temporary matrix (Repeats x Time) to place spikes
        
        for Repeat = 1:length(SpikesByCondition{Condition,1});             %Loop through repeats of each condition
            
            for Spikes = 1:length(SpikesByCondition{Condition,1}{1,Repeat});       %Loop through number of spikes for each repeat
                
                temp_PSTH(Repeat,SpikesByCondition{Condition,1}{1,Repeat}(1,Spikes)) = 1;     %Place a 1 where ever a spike occured 
                
            end
            
        end
        
        clear Repeat
        
        AveragePSTH(Condition,:) = mean(temp_PSTH);                         %Average across all repeats for each condition
        
        clear temp_PSTH
        
        FilteredPSTH(Condition,:) = filter(FILTWIN,1,AveragePSTH(Condition,:));     %Filter the averaged PSTH with FILTWIN
        
    end
    
    FilteredPSTH1 = FilteredPSTH(:,334:20333);      %getting rid of the first 333 points that get messed up when using a square wave filter 333 points wide

    for cond = 1:length(FilteredPSTH1(:,1));                                 %Averaging across time to reach 1ms resolution

        ii=0;

        for ms = 1:20:20000;

            ii = ii+1;

            FilteredPSTH_ms(cond,ii) = sum(FilteredPSTH1(cond,ms:ms+19))/20;

        end
    end
    
    clear cond ms ii
    
    
    CombinedData.Spikes(Cluster).SpikesByCondition = [SpikesByCondition];                  %Saving SpikesByCondition variable to Data structure
    
%    Filt_Data(Cluster).FilteredPSTH = FilteredPSTH;
    
%    Filt_Data(Cluster).FilteredPSTH1 = FilteredPSTH1;
    
    Filt_Data(Cluster).FilteredPSTH = FilteredPSTH_ms;
    
    Filt_Data(Cluster).NormalizedPSTH = FilteredPSTH_ms(:,1:500)/max(max(FilteredPSTH_ms(:,1:500)));
    
    clear FilteredPSTH FilteredPSTH1 AveragePSTH SpikesByCondition FilteredPSTH_ms
    
end


save([Save_FilePath '_Filt_Data.mat'], 'Filt_Data');

close(wb)

clear wb NatImg_CombinedData column Cluster Blank Spikes ConditionTiming CombinedData Blocks_StimData Block_Numbers

end

