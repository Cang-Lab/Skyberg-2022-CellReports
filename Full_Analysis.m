Drive = ['F']
Mouse = ['RS_M199']
Section = [1]; 
Blocks = [2 4 5];

%Full Ringach Data Analysis 

for ii = 1:length(Blocks)

   BlocksRG = Blocks(ii);
   
PSTH_and_Finding_Peaks(Drive, Mouse, Section, BlocksRG)

Av_TC_Addition(Drive, Mouse, Section, BlocksRG)
 
%Time_Averaged_Tuning_Properties(Drive, Mouse, Section)

%Spatial_Frequency_Temporal_Dynamics(Drive, Mouse, Section)

%Weighted_Sum_Peak(Mouse, Section) 

end