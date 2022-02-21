Drive = ['F']
Mouse = ['RS_M190'];
Section = [1];
BlkNum = [2];
 

load([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
load([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_BTP']);
load([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_SFTD']);
load([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_TimingData']);
load([Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(BlkNum) '\' Mouse '_Section_' num2str(Section) '_NI_rSU_Data']);


if exist(['G:\Science\MountainSort\Cell Populations for Paper\Natural Image Data\P40V1_FilteredNIs.mat']) == 2
    load(['G:\Science\MountainSort\Cell Populations for Paper\Natural Image Data\P40V1_FilteredNIs.mat']);
    nd = length(P40V1_FilteredNIs);
else
    nd = 0;
end

Ori_Nums = [0 45 90 135];

SF_Nums = [0.02 0.04 0.08 0.1 0.12 0.16 0.2 0.24 0.28 0.32];

FILTWIN = ones(10,1)/10;

for ii = 1:length(rSU_Data)
   Cell = rSU_Data(ii).Cell;
   
   P40V1_FilteredNIs(nd+ii).Mouse = Mouse;
   P40V1_FilteredNIs(nd+ii).Section = Section;
   P40V1_FilteredNIs(nd+ii).Cell = Cell;
   
   P40V1_FilteredNIs(nd+ii).SF_Pref_TA = BTP(Cell).SF_Pref_TA;
   P40V1_FilteredNIs(nd+ii).Ori_Pref_TA = BTP(Cell).Ori_Pref_TA;
   P40V1_FilteredNIs(nd+ii).gOSI = BTP(Cell).gOSI;
   
   P40V1_FilteredNIs(nd+ii).tDev = TimingData(Cell).MM.tDev;
   P40V1_FilteredNIs(nd+ii).Peak1 = TimingData(Cell).VR.Peak1;
   P40V1_FilteredNIs(nd+ii).Peak2 = TimingData(Cell).VR.Peak2;
   P40V1_FilteredNIs(nd+ii).tDecay = TimingData(Cell).MM.tDecay;
   
   [~, Ori_col] = find(Ori_Nums == P40V1_FilteredNIs(nd+ii).Ori_Pref_TA); 
   P40V1_FilteredNIs(nd+ii).SFtDev = SFTD(Cell).fPeak(Ori_col, P40V1_FilteredNIs(nd+ii).tDev);
   P40V1_FilteredNIs(nd+ii).SFtDecay = SFTD(Cell).fPeak(Ori_col, P40V1_FilteredNIs(nd+ii).tDecay);
   P40V1_FilteredNIs(nd+ii).fPeak = SFTD(Cell).fPeak;
   
   P40V1_FilteredNIs(nd+ii).Norm_TC = Filt_Data(Cell).Norm_TC;
   
   for tt = 1:10  
       
     TempData =  filter(FILTWIN, 1, Filt_Data(Cell).Norm_TC(tt,:));
     P40V1_FilteredNIs(nd+ii).NoOri(tt,:) = TempData(1:200); 
     clear TempData
     
   end
    
   P40V1_FilteredNIs(nd+ii).HPFResp = rSU_Data(ii).NoNorm(1:60,:);
   P40V1_FilteredNIs(nd+ii).LPFResp = rSU_Data(ii).NoNorm(61:120,:);
   P40V1_FilteredNIs(nd+ii).NFResp = rSU_Data(ii).NoNorm(121:180,:);

   P40V1_FilteredNIs(nd+ii).HPFResp_Norm = rSU_Data(ii).Normalized(1:60,:);
   P40V1_FilteredNIs(nd+ii).LPFResp_Norm = rSU_Data(ii).Normalized(61:120,:);
   P40V1_FilteredNIs(nd+ii).NFResp_Norm = rSU_Data(ii).Normalized(121:180,:);
    
   clear tt Ori_col 
   
end

clear ii 

save('G:\Science\MountainSort\Cell Populations for Paper\Natural Image Data\P40V1_FilteredNIs.mat', 'P40V1_FilteredNIs')
