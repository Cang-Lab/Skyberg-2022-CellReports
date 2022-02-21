savepath = ['G:\Science\Naturalistic Images Data Figures\Low and High Pass Filtered\M186\'];
sss = [2 3 5 8 9 11 14 15 17 20 25 27 30];
for ii =5% 1:length(rSU_Data)
    h = figure
    
    subplot(233)
        imagesc(rSU_Data(ii).NoNorm(1:60,:))
        title('High Pass Natural Images')
    subplot(232)
        imagesc(rSU_Data(ii).NoNorm(61:120,:))
        title('Low Pass Natural Images')
    subplot(231)
        imagesc(rSU_Data(ii).NoNorm(121:180,:))
        title('Unaltered Natural Images')
        
    subplot(2,3,4:6)
        plot(mean(rSU_Data(ii).NoNorm(121:180,:),1),'k')
        hold on
        plot(mean(rSU_Data(ii).NoNorm(61:120,:),1),'r')
        plot(mean(rSU_Data(ii).NoNorm(1:60,:),1),'c')
        legend('Natural Images','Low Pass','High Pass')
        title(['Cell ' num2str(ii)])
        
        
        saveas(h, [savepath 'Cell ' num2str(rSU_Data(ii).Cell) '.jpg'],'jpg')
       % close(h)

%dat(:,:,ii) = rSU_Data(ii).Normalized; 

%dat_nn(:,:,ii) = rSU_Data(ii).NoNorm;

end
 

dat1 = squeeze(mean(dat,3));

dat1_hp = mean(dat1(1:60,:),1);
dat1_lp = mean(dat1(61:120,:),1);
dat1_ue = mean(dat1(121:180,:),1);

figure; plot(dat1_ue); hold on; plot(dat1_lp); plot(dat1_hp)

datnn1 = squeeze(mean(dat_nn,3));

datnn1_hp = mean(datnn1(1:60,:),1);
datnn1_lp = mean(datnn1(61:120,:),1);
datnn1_ue = mean(datnn1(121:180,:),1);

figure; plot(datnn1_ue*1000); hold on; plot(datnn1_lp*1000); plot(datnn1_hp*1000)



dat_ue = dat(121:180,:,:);
dat_lp = dat(61:120,:,:);
dat_hp = dat(1:60,:,:);




%% 

PkNum = [P40V1_FilteredNIs(:).PkNum];
Cell = [P40V1_FilteredNIs(:).Cell];
SF1 = [P40V1_FilteredNIs(:).SF1];
SF2 = [P40V1_FilteredNIs(:).SF2];
SFShift = log2(SF2)-log2(SF1);
%rSU_Index = [rSU_Data(:).Cell];


[~,P1] = find(PkNkloum == 1);
[~,P2] = find(PkNum == 2);

P1_Cell = Cell(P1);
P2_Cell = Cell(P2);

P1_NIs = rSU_Index([4 5 10 13 14 19 20 21 25]);
P2_NIs = rSU_Index([2 6 11 12 30])


P1_NIs = [4 5 10 13 14 19 20 21 25];
P2_NIs = [2 6 11 12 30];




tt = 0;
for ii = P1_NIs
tt =tt+1;    
NIr_1P(:,:,tt) = rSU_Data(P1_NIs).Normalized;
    
    
end

figure; plot(mean(squeeze(mean(NIr_1P(1:60,:,:),3)))); hold on
plot(mean(squeeze(mean(NIr_1P(61:120,:,:),3))))
plot(mean(squeeze(mean(NIr_1P(121:180,:,:),3))))




tt = 0;
for ii = P2_NIs
tt =tt+1;    
NIr_2P(:,:,tt) = rSU_Data(P2_NIs).Normalized;
    
    
end

figure; 
subplot(121);plot(1000*mean(squeeze(mean(NIr_2P(121:180,:,:),3)))) 
hold on
plot(1000*mean(squeeze(mean(NIr_2P(61:120,:,:),3))))
plot(1000*mean(squeeze(mean(NIr_2P(1:60,:,:),3))))
title('2 Peak Cells - n = 5')

subplot(122);
plot(1000*mean(squeeze(mean(NIr_1P(121:180,:,:),3))))
hold on
plot(1000*mean(squeeze(mean(NIr_1P(61:120,:,:),3))))
plot(1000*mean(squeeze(mean(NIr_1P(1:60,:,:),3)))); 
title('1 Peak Cells - n = 9')

figure; 
subplot(131);plot(mean(squeeze(mean(NIr_2P(121:180,:,:),3)))) 
hold on
plot(mean(squeeze(mean(NIr_1P(121:180,:,:),3))))
title('Natural Images')

subplot(132);
plot(mean(squeeze(mean(NIr_2P(61:120,:,:),3))))
hold on
plot(mean(squeeze(mean(NIr_1P(61:120,:,:),3))))
title('Low Pass')

subplot(133);
plot(mean(squeeze(mean(NIr_2P(1:60,:,:),3))))
hold on
plot(mean(squeeze(mean(NIr_1P(1:60,:,:),3)))); 
title('High Pass')



















