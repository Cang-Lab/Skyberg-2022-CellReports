Mouse = ['RS_M153'];
Section = [2];
SU = [5 49 57 71 72 73 76 78 98 100 102 104 122 124 126 128];



load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_TimingData']);
load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
% load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\' Mouse '_Section_' num2str(Section) '_Waveforms']);

for ii = SU;
  
   h = figure; 
   subplot(1,2,1)
   plot(TimingData(ii).VR.Filt_Var)
   title(['Cell ' num2str(ii)])
   hold on
   %refline(0, Full_TimingData(ii).VR.Threshold);
 

   subplot(1,2,2)
   imagesc(Filt_Data(ii).Normalized)
   title(['Cell ' num2str(ii)])
   
   uiwait(h)
   
 end
 clear ii jj h2

