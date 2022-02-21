% % Adult V1
for ii = 1:length(P40V1)
   
   Mouse = P40V1(ii).Mouse;
   Section = P40V1(ii).Section;
   Cell = P40V1(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   Base = mean(mean(Filt_Data(Cell).Norm_TC(:,1:40)));
   P40V1(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P40V1(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
   P40V1(ii).Sum_Base = Base/max(TempData_Sum);
   P40V1(ii).Max_Base = Base/max(TempData_Max);
    
    
end
save('E:\Science\MountainSort\P40V1.mat', 'P40V1')



for ii = 1:length(P40V1)
   V1_AVTC_Sum(ii,1:10) = P40V1(ii).AvTC_Sum;
   V1_Base(ii) = P40V1(ii).Sum_Base;
    
%   AVTC_Max(ii,1:10) = P40V1(ii).AvTC_Max;
end

figure
plot(mean(V1_AVTC_Sum))
hold on
plot(mean(AVTC_Max))

%% Adult LGN
for ii = 1:length(P40LGN)
   
   Mouse = P40LGN(ii).Mouse;
   Section = P40LGN(ii).Section;
   Cell = P40LGN(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   P40LGN(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P40LGN(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end
save('E:\Science\MountainSort\P40LGN.mat', 'P40LGN')



for ii = 1:length(P40LGN)
  LGN_AVTC_Sum(ii,1:10) = P40LGN(ii).AvTC_Sum;
    
   %AVTC_Max(ii,1:10) = P40LGN(ii).AvTC_Max;
end

figure
plot(mean(LGN_AVTC_Sum))
hold on
plot(mean(AVTC_Max))


%% Adult LGN
for ii = 1:length(P40SC)
   
   Mouse = P40SC(ii).Mouse;
   Section = P40SC(ii).Section;
   Cell = P40SC(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   P40SC(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P40SC(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end
save('E:\Science\MountainSort\P40SC.mat', 'P40SC')



for ii = 1:length(P40SC)
   SC_AVTC_Sum(ii,1:10) = P40SC(ii).AvTC_Sum;
    
   %AVTC_Max(ii,1:10) = P40SC(ii).AvTC_Max;
end

figure
plot(SF, mean(SC_AVTC_Sum))
hold on
plot(SF,mean(LGN_AVTC_Sum))
plot(mean(P40V1_SF,2))


figure
plot(SF, mean(V1_AVTC_Sum))
hold on
plot(SF, mean(LGN_AVTC_Sum))
plot(SF, mean(SC_AVTC_Sum))

%% P25 V1
for ii = 1:length(P25V1)
   
   Mouse = P25V1(ii).Mouse;
   Section = P25V1(ii).Section;
   Cell = P25V1(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   P25V1(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P25V1(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end
save('E:\Science\MountainSort\P25V1.mat', 'P25V1')




for ii = 1:length(P25V1)
   AVTC_Sum(ii,1:10) = P25V1(ii).AvTC_Sum;
    
   AVTC_Max(ii,1:10) = P25V1(ii).AvTC_Max;
end

figure
plot(mean(AVTC_Sum))
hold on
plot(mean(AVTC_Max))

%%  Dark Reared V1
for ii = 1:length(DRV1)
   
   Mouse = DRV1(ii).Mouse;
   Section = DRV1(ii).Section;
   Cell = DRV1(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   DRV1(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   DRV1(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end

save('E:\Science\MountainSort\DRV1.mat', 'DRV1')

for ii = 1:length(DRV1)
   AVTC_Sum(ii,1:10) = DRV1(ii).AvTC_Sum;
    
   AVTC_Max(ii,1:10) = DRV1(ii).AvTC_Max;
end

figure
plot(mean(AVTC_Sum))
hold on
plot(mean(AVTC_Max))

%% P30 V1
for ii = 1:length(P30V1)
   
   Mouse = P30V1(ii).Mouse;
   Section = P30V1(ii).Section;
   Cell = P30V1(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   P30V1(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P30V1(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end
save('E:\Science\MountainSort\P30V1.mat', 'P30V1')




for ii = 1:length(P30V1)
   AVTC_Sum(ii,1:10) = P30V1(ii).AvTC_Sum;
    
   AVTC_Max(ii,1:10) = P30V1(ii).AvTC_Max;
end

figure
plot(mean(AVTC_Sum))
hold on
plot(mean(AVTC_Max))

%% P30 LGN
for ii = 1:length(P30LGN)
   
   Mouse = P30LGN(ii).Mouse;
   Section = P30LGN(ii).Section;
   Cell = P30LGN(ii).Cell;
   load(['E:\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\' Mouse '_Section_' num2str(Section) '_Filt_Data']);
   
   for Cond = 1:10
       [col] = find(Filt_Data(Cell).Norm_TC(Cond,40:200));
       TempData_Sum(1,Cond) = sum(Filt_Data(Cell).Norm_TC(Cond,col));
       TempData_Max(1,Cond) = max(Filt_Data(Cell).Norm_TC(Cond,col));
       clear col
   end
   P30LGN(ii).AvTC_Sum = TempData_Sum/max(TempData_Sum);
   P30LGN(ii).AvTC_Max = TempData_Max/max(TempData_Max);
   
    
    
end
save('E:\Science\MountainSort\P30LGN.mat', 'P30LGN')




for ii = 1:length(P30LGN)
   AVTC_Sum(ii,1:10) = P30LGN(ii).AvTC_Sum;
    
   AVTC_Max(ii,1:10) = P30LGN(ii).AvTC_Max;
end

figure
plot(mean(AVTC_Sum))
hold on
plot(mean(AVTC_Max))

