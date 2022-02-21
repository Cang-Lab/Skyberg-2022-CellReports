for ii = 1:length(DR)
    DRData(:,:,ii) = DR(ii).Normalized(1:150,:);
    DRDataNN(:,:,ii) = DR(ii).NoNorm(1:150,:);
end

for ii = 1:length(NR)
    NRData(:,:,ii) = NR(ii).Normalized(1:150,:);
    NRDataNN(:,:,ii) = NR(ii).NoNorm(1:150,:);
end

for ii = 1:length(NR_AN)
    ANData(:,:,ii) = NR_AN(ii).Normalized(1:150,:);
    ANDataNN(:,:,ii) = NR_AN(ii).NoNorm(1:150,:);
end


figure
imagesc(sort(squeeze(mean(NRData,1))',))
figure
imagesc(sort(squeeze(mean(DRData,1))'))
figure
imagesc(sort(squeeze(mean(ANData,1))'))

NR_AvFR = mean(mean(NRDataNN,3),1);
DR_AvFR = mean(mean(DRDataNN,3),1);
AN_AvFR = mean(mean(ANDataNN,3),1);


figure
plot(NR_AvFR*1000,'LineWidth',3)
hold on
plot(AN_AvFR*1000,'LineWidth',3)
plot(DR_AvFR*1000,'LineWidth',3)


for Tau = 1:350
       TempData = squeeze(NRData(:,Tau,:));
       [~,~,L,~,Ex] = pca(TempData); 
       All_NR_Eig(:,Tau) = L;
       All_NR_Ex(:,Tau) = Ex;
end


for ii = 2:149
SummedEx(:,ii) = sum(All_NR_Ex(1:ii,:));
ANSummedEx(:,ii) = sum(All_AN_Ex(1:ii,:));
DRSummedEx(:,ii) = sum(All_DR_Ex(1:ii,:));
end



for Tau = 1:350
       TempData = squeeze(DRData(:,Tau,:));
       [~,~,L,~,Ex] = pca(TempData);
       All_DR_Eig(:,Tau) = L;
       All_DR_Ex(:,Tau) = Ex;
end
for Tau = 1:350
       TempData = squeeze(ANData(:,Tau,:));
       [~,~,L,~,Ex] = pca(TempData);
       All_AN_Eig(:,Tau) = L;
       All_AN_Ex(:,Tau) = Ex;
end

figure
plot(sum(All_NR_Ex(1:6,:)))


figure
plot(sum(All_NR_Eig),'LineWidth',3)
hold on
plot(sum(All_AN_Eig),'LineWidth',3)
plot(sum(All_DR_Eig),'LineWidth',3)



figure
plot(All_NR_Eig(1:6,:)','LineWidth',3)
figure
plot(All_AN_Eig(1:6,:)','LineWidth',3)
figure
plot(All_DR_Eig(1:6,:)','LineWidth',3)

figure
plot(All_NR_Ex(2,:)','LineWidth',3)
hold on
plot(All_AN_Ex(2,:)','LineWidth',3)
plot(All_DR_Ex(2,:)','LineWidth',3)

figure
plot(All_NR_Ex(1:6,:)','LineWidth',3)
figure
plot(All_DR_Ex(1:6,:)','LineWidth',3)
figure
plot(All_AN_Ex(1:6,:)','LineWidth',3)

figure
plot(All_NR_Ex(1,:)','LineWidth',3)
hold on
plot(All_AN_Ex(1,:)','LineWidth',3)
plot(All_DR_Ex(1,:)','LineWidth',3)

figure
semilogx(All_NR_Ex(:,30))
hold on
semilogx(All_AN_Ex(:,30))
semilogx(All_DR_Ex(:,30))

figure
semilogx(All_NR_Ex(:,123))
hold on
semilogx(All_NR_Ex(:,146))
semilogx(All_NR_Ex(:,166))

figure
semilogx(All_DR_Ex(:,124))
hold on
semilogx(All_DR_Ex(:,170))
semilogx(All_DR_Ex(:,145))

figure
semilogx(All_AN_Ex(:,132))
hold on
semilogx(All_AN_Ex(:,186))
semilogx(All_AN_Ex(:,151))

DRMice(1,:) = [1, 45 ,85, 116, 145, 266]; 
DRMice(2,:) = [44, 84 ,115, 144, 265, 312]; 
DRMiceID = ['M154'; 'M155'; 'M156'; 'M160'; 'M163'; 'M164'];

NRMice(1,:) = [1, 48 ,107, 250, 307, 361, 414]; 
NRMice(2,:) = [47, 106 ,249, 306, 360, 413, 510]; 
NRMiceID = ['M141'; 'M146'; 'M161'; 'M162'; 'M165'; 'M166'; 'M167'];

ANMice(1,:) = [1, 67, 117, 160, 202, 287]; 
ANMice(2,:) = [66, 116, 159, 201, 286, 348 ]; 
ANMiceID = ['M157'; 'M169'; 'M170'; 'M171'; 'M172'; 'M173'];

test =sum(All_AN_Eig);
test1 = test.*All_AN_Eig;
figure
plot(test1')

% t1t2 = [120 161];
for ii = 1:length(NRMice)

    for Tau = 1:350
       TempData = squeeze(NRData(:,Tau,[NRMice(1,ii):NRMice(2,ii)]));
       [~,~,L,~,Ex] = pca(TempData);
       NR_Eig(:,Tau) = L;
       NR_Ex(:,Tau) = Ex;
    end
      Ind_NR_Ex(1:46,:,ii)= NR_Ex(1:46,:);
%     NRFirst(ii,:) = NR_Eig(1,:);
%     NRFirst2(ii,:) = sum(NR_Ex(1:2,:));
%     NRFirst3(ii,:) = sum(NR_Ex(1:3,:));
%     NRFirst4(ii,:) = sum(NR_Ex(1:4,:));
    NRFirst5(ii,:) = sum(NR_Ex(1:5,:));
    NRFirst10(ii,:) = sum(NR_Ex(1:10,:));
  %  NRt1t1(1,ii) = sum(NR_Ex(1:5,t1t2(1)));
   % NRt1t1(2,ii) = sum(NR_Ex(1:5,t1t2(2)));
    
%     h = figure
%         subplot(221)
%             plot(DR_Eig(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(223)
%             plot(DR_Eig(:,t1t2))
%             xline(5)
%         subplot(222)
%             plot(DR_Ex(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(224)
%             plot(DR_Ex(:,t1t2))
%             xline(5)
% 
%     saveas(h, ['C:\Users\rskyb\OneDrive\Desktop\Individual Mice Eigens\DR Mice\' DRMiceID(ii,:)],'fig');
    clear NR_Eig NR_Ex TempData L Ex Tau h 
end
for ii = 1:length(DRMice)

    for Tau = 1:350
       TempData = squeeze(DRData(:,Tau,[DRMice(1,ii):DRMice(2,ii)]));
       [~,~,L,~,Ex] = pca(TempData);
       DR_Eig(:,Tau) = L;
       DR_Ex(:,Tau) = Ex;
    end
    
    DRFirst(ii,:) = DR_Eig(1,:);
    DRFirst2(ii,:) = sum(DR_Ex(1:2,:));
    DRFirst3(ii,:) = sum(DR_Ex(1:3,:));
    DRFirst4(ii,:) = sum(DR_Ex(1:4,:));
    DRFirst5(ii,:) = sum(DR_Ex(1:5,:));
    DRFirst6(ii,:) = sum(DR_Ex(1:6,:));
  %  NRt1t1(1,ii) = sum(NR_Ex(1:5,t1t2(1)));
   % NRt1t1(2,ii) = sum(NR_Ex(1:5,t1t2(2)));
    
%     h = figure
%         subplot(221)
%             plot(DR_Eig(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(223)
%             plot(DR_Eig(:,t1t2))
%             xline(5)
%         subplot(222)
%             plot(DR_Ex(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(224)
%             plot(DR_Ex(:,t1t2))
%             xline(5)
% 
%     saveas(h, ['C:\Users\rskyb\OneDrive\Desktop\Individual Mice Eigens\DR Mice\' DRMiceID(ii,:)],'fig');
    clear DR_Eig DR_Ex TempData L Ex Tau h 
end
for ii = 1:length(ANMice)

    for Tau = 1:350
       TempData = squeeze(ANData(:,Tau,[ANMice(1,ii):ANMice(2,ii)]));
       [~,~,L,~,Ex] = pca(TempData);
       AN_Eig(:,Tau) = L;
       AN_Ex(:,Tau) = Ex;
    end
    
    ANFirst(ii,:) = AN_Eig(1,:);
    ANFirst2(ii,:) = sum(AN_Ex(1:2,:));
    ANFirst3(ii,:) = sum(AN_Ex(1:3,:));
    ANFirst4(ii,:) = sum(AN_Ex(1:4,:));
    ANFirst5(ii,:) = sum(AN_Ex(1:5,:));
    ANFirst6(ii,:) = sum(AN_Ex(1:6,:));
  %  NRt1t1(1,ii) = sum(NR_Ex(1:5,t1t2(1)));
   % NRt1t1(2,ii) = sum(NR_Ex(1:5,t1t2(2)));
    
%     h = figure
%         subplot(221)
%             plot(DR_Eig(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(223)
%             plot(DR_Eig(:,t1t2))
%             xline(5)
%         subplot(222)
%             plot(DR_Ex(1:5,:)')
%             xline(t1t2(1))
%             xline(t1t2(2))
%         subplot(224)
%             plot(DR_Ex(:,t1t2))
%             xline(5)
% 
%     saveas(h, ['C:\Users\rskyb\OneDrive\Desktop\Individual Mice Eigens\DR Mice\' DRMiceID(ii,:)],'fig');
    clear AN_Eig AN_Ex TempData L Ex Tau h 
end

for ii = 1:6
    for Tau = 1:500
       TempData = squeeze(ANData(:,Tau,[ANMice(1,ii):ANMice(2,ii)]));
       [~,~,L,~,Ex] = pca(TempData);
       AN_Eig(:,Tau) = L;
       AN_Ex(:,Tau) = Ex;
    end

    
    
end   

 ii =6
 figure
   subplot(212)
   plot(ANFirst5(ii,:))
   xline(120)
   xline(161)
  % ylim([0 100])
   subplot(211)
   plot(ANFirst(ii,:))


    

figure
plot(DRFirst(1,:))

DRt1 = [103 122 105 117 115 113];
NRt1 = [121 123 115 120 110 115 115];
ANt1 = [134  140 133 138 134 162];

figure
plot(ANFirst6(1,ANt1(1):ANt1(1)+40)','k')
hold on
plot(ANFirst6(2,ANt1(2):ANt1(2)+40)','k')
plot(ANFirst6(3,ANt1(3):ANt1(3)+40)','k')
plot(ANFirst6(4,ANt1(4):ANt1(4)+40)','k')
plot(ANFirst6(5,ANt1(5):ANt1(5)+40)','k')
plot(ANFirst6(6,ANt1(6):ANt1(6)+40)','k')

plot(ANFirst6(1,NRt1(1):NRt1(1)+40)','b')
plot(ANFirst6(2,NRt1(2):NRt1(2)+40)','b')
plot(ANFirst6(3,NRt1(3):NRt1(3)+40)','b')
plot(ANFirst6(4,NRt1(4):NRt1(4)+40)','b')
plot(ANFirst6(5,NRt1(5):NRt1(5)+40)','b')
plot(ANFirst6(6,NRt1(6):NRt1(6)+40)','b')
plot(ANFirst6(7,NRt1(7):NRt1(7)+40)','b')

for ii =1:7
   
   NR2(:,ii) = NRFirst6(ii,NRt1(ii):NRt1(ii)+40)
    NR2_norm(:,ii) = NR2(:,ii)/NR2(1,ii);
    
end

for ii =1:6
   
    DR2(:,ii) = DRFirst6(ii,DRt1(ii):DRt1(ii)+40)
    DR2_norm(:,ii) = DR2(:,ii)/DR2(1,ii);
    
end

for ii =1:6
   
    AN2(:,ii) = ANFirst6(ii,ANt1(ii):ANt1(ii)+40)
    AN2_norm(:,ii) = AN2(:,ii)/AN2(1,ii);
    
end

figure
plot(AN2_norm)


for ii =1:7
   
    NR2(:,ii) = ANFirst6(ii,NRt1(ii):NRt1(ii)+40)
    NR2_norm(:,ii) = NR2(:,ii)/NR2(1,ii);
    
end

figure
plot(DR2,'k','LineWidth',3)
hold on 
plot(NR2,'b','LineWidth',3)

TestDR = DR2(1,:)- DR2(41,:)
TestNR = NR2(1,:)-NR2(41,:)
TestAN = AN2(1,:)-AN2(41,:)

DR_ste = std(TestDR)/sqrt(length(TestDR));
NR_ste = std(TestNR)/sqrt(length(TestNR));
AN_ste = std(TestAN)/sqrt(length(TestAN));

figure
bar(2,mean(TestDR))
hold on
bar(1,mean(TestNR))
bar(3,mean(TestAN))

errorbar(1,mean(TestNR),NR_ste,'b','LineWidth', 3)
hold on
errorbar(2,mean(TestDR),DR_ste,'k','LineWidth', 3)

figure
plot(2,TestDR,'ko','LineWidth',2)
hold on
plot(,TestNR,'bo','LineWidth',2)
bar(1,mean(TestDR))
hold on
bar(2,mean(TestNR))






figure
plot(120:161,ANFirst6(:,120:161)','b','LineWidth',3)
hold on
plot(120:161,DRFirst6(:,120:161)','k','LineWidth',3)

NR_F6_norm = ANFirst6(:,120:161)./ANFirst6(:,120);
DR_F6_norm = DRFirst6(:,120:161)./DRFirst6(:,120);

figure
plot(120:161,NR_F6_norm','b','LineWidth',3)
hold on
plot(120:161,DR_F6_norm','k','LineWidth',3)


figure
plot(ANFirst','b','LineWidth',3)
hold on
plot(DRFirst','k','LineWidth',3)




figure
subplot(235)
plot([120:161],ANFirst5(:,[t1t2(1):t1t2(2)])','b')
hold on
plot([120:161],DRFirst5(:,[t1t2(1):t1t2(2)])','k')
title('Eig 1:5')
subplot(231)
plot([120:161],ANFirst(:,[t1t2(1):t1t2(2)])','b')
hold on
plot([120:161],DRFirst(:,[t1t2(1):t1t2(2)])','k')
title('Eig 1')
subplot(232)
plot([120:161],ANFirst2(:,[t1t2(1):t1t2(2)])','b')
hold on
plot([120:161],DRFirst2(:,[t1t2(1):t1t2(2)])','k')
title('Eig 1:2')
subplot(233)
plot([120:161],ANFirst3(:,[t1t2(1):t1t2(2)])','b')
hold on
plot([120:161],DRFirst3(:,[t1t2(1):t1t2(2)])','k')
title('Eig 1:3')
subplot(234)
plot([120:161],ANFirst4(:,[t1t2(1):t1t2(2)])','b')
hold on
plot([120:161],DRFirst4(:,[t1t2(1):t1t2(2)])','k')
title('Eig 1:4')

figure
subplot(235)
plot([120:161],(ANFirst5(:,[t1t2(1):t1t2(2)])./ANFirst5(:,t1t2(1)))','b')
hold on
plot([120:161],(DRFirst5(:,[t1t2(1):t1t2(2)])./DRFirst5(:,t1t2(1)))','k')
title('Eig 1:5')
subplot(231)
plot([120:161],(ANFirst(:,[t1t2(1):t1t2(2)])./ANFirst(:,t1t2(1)))','b')
hold on
plot([120:161],(DRFirst(:,[t1t2(1):t1t2(2)])./DRFirst(:,t1t2(1)))','k')
title('Eig 1')
subplot(232)
plot([120:161],(ANFirst2(:,[t1t2(1):t1t2(2)])./ANFirst2(:,t1t2(1)))','b')
hold on
plot([120:161],(DRFirst2(:,[t1t2(1):t1t2(2)])./DRFirst2(:,t1t2(1)))','k')
title('Eig 1:2')
subplot(233)
plot([120:161],(ANFirst3(:,[t1t2(1):t1t2(2)])./ANFirst3(:,t1t2(1)))','b')
hold on
plot([120:161],(DRFirst3(:,[t1t2(1):t1t2(2)])./DRFirst3(:,t1t2(1)))','k')
title('Eig 1:3')
subplot(234)
plot([120:161],(ANFirst4(:,[t1t2(1):t1t2(2)])./ANFirst4(:,t1t2(1)))','b')
hold on
plot([120:161],(DRFirst4(:,[t1t2(1):t1t2(2)])./DRFirst4(:,t1t2(1)))','k')
title('Eig 1:4')


NRFirstDif = ANFirst(:,120)-ANFirst(:,161);
DRFirstDif = DRFirst(:,120)-DRFirst(:,161);

NRFirst2Dif = ANFirst2(:,120)-ANFirst2(:,161);
DRFirst2Dif = DRFirst2(:,120)-DRFirst2(:,161);

NRFirst3Dif = ANFirst3(:,120)-ANFirst3(:,161);
DRFirst3Dif = DRFirst3(:,120)-DRFirst3(:,161);

NRFirst4Dif = ANFirst4(:,120)-ANFirst4(:,161);
DRFirst4Dif = DRFirst4(:,120)-DRFirst4(:,161);

NRFirst5Dif = ANFirst5(:,120)-ANFirst5(:,161);
DRFirst5Dif = DRFirst5(:,120)-DRFirst5(:,161);
%% 

NRFirstDif = ANFirst(:,161)./ANFirst(:,120);
DRFirstDif = DRFirst(:,161)./DRFirst(:,120);

NRFirst2Dif = ANFirst2(:,161)./ANFirst2(:,120);
DRFirst2Dif = DRFirst2(:,161)./DRFirst2(:,120);

NRFirst3Dif = ANFirst3(:,161)./ANFirst3(:,120);
DRFirst3Dif = DRFirst3(:,161)./DRFirst3(:,120);

NRFirst4Dif = ANFirst4(:,161)./ANFirst4(:,120);
DRFirst4Dif = DRFirst4(:,161)./DRFirst4(:,120);

NRFirst5Dif = ANFirst5(:,161)./ANFirst5(:,120);
DRFirst5Dif = DRFirst5(:,161)./DRFirst5(:,120);

%% 

NRDif = [NRFirstDif NRFirst2Dif NRFirst3Dif NRFirst4Dif NRFirst5Dif ];
DRDif = [DRFirstDif DRFirst2Dif DRFirst3Dif DRFirst4Dif DRFirst5Dif ];

figure
plot([1:5], NRDif,'b','LineWidth',1)
hold on
plot([1:5], DRDif,'k','LineWidth',1)
plot([1:5],mean(NRDif),'b--','LineWidth',3)

plot([1:5],mean(DRDif),'k--','LineWidth',3)








figure
plot([1 2], NRt1t1,'b','LineWidth',1.5)
hold on
plot([1 2], DRt1t1,'k','LineWidth',1.5)
plot([1 2], mean(NRt1t1,2),'b--','LineWidth',4)
plot([1 2], mean(DRt1t1,2),'k--','LineWidth',4)
ylim([30 80])
xlim([115 165])


NRDif = NRt1t1(1,:)-NRt1t1(2,:);
DRDif = DRt1t1(1,:)-DRt1t1(2,:);
BothDif = [mean(NRDif) mean(DRDif)];

NRSTE = std(NRDif)/sqrt(length(NRDif));
DRSTE = std(DRDif)/sqrt(length(DRDif));
BothSTE = [NRSTE DRSTE];

NRRelDif = NRt1t1(:,:)./NRt1t1(1,:);
DRRelDif = DRt1t1(:,:)./DRt1t1(1,:);

figure
plot([1,2],NRRelDif,'b')
hold on
plot([1,2],DRRelDif,'k')

figure
bar(1,mean(NRDif))
hold on
bar(2, mean(DRDif))

figure
bar([1,2],BothDif)
hold on
errorbar(1, BothDif(1), BothSTE(1))
errorbar(2, BothDif(2), BothSTE(2))

NRRate = mean(mean(NRData,3),1)*1000;

DRRate = mean(mean(DRData,3),1)*1000;

figure 
plot(NRRate)
hold on
plot(DRRate)

for Tau = 1:500
    TempData = squeeze(DRData(:,Tau,:));
    [~,~,l,~,Ex] = pca(TempData);
    DR_Eig(:,Tau) = l;
    DR_Ex(:,Tau) = Ex;
end
figure
plot(NR_Eig')
figure
plot(DR_Eig')

figure
plot(NR_Ex(:,120))
hold on
plot(NR_Ex(:,150))


figure
semilogx(NR_Ex(:,120))
hold on
semilogx(NR_Ex(:,150))
semilogx(DR_Ex(:,120))
hold on
semilogx(DR_Ex(:,150))

figure
plot(DR_Eig(1:6,:)', 'LineWidth', 3)
hold on
plot(DR_Eig(7:end,:)','k', 'Linewidth', 1.5)


