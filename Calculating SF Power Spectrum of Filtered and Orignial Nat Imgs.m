

NI_Imgs = dir(['C:\Users\rskyb\OneDrive\Desktop\Natural Images\Used Image Set\150 Natural Images ' '/*.tif'])


for ii = 1:length(NI_Imgs)

Img = imread([NI_Imgs(ii).folder '\' NI_Imgs(ii).name]);

F_S = fft2(Img);
F_S = abs(fftshift(F_S));
% figure; subplot(121); imagesc(NIImgs); colormap('gray');
%  subplot(122); imagesc (F_S(30:40,40:52));
ImageFourier_2D_to_1D(F_S);

NI_xy(:,:,ii) = ans;

end

NI_x = squeeze(NI_xy(:,1,:));
NI_y = squeeze(NI_xy(:,2,:));

NI_x_m = mean(NI_x,2);
NI_y_m = mean(NI_y,2);
%% 

LPF = dir(['C:\Users\rskyb\OneDrive\Desktop\Natural Images\Used Image Set\150 Natural Images - LPF 2SD Gaussian ' '/*.tif']);
for ii = 1:length(LPF)

Img = imread([LPF(ii).folder '\' LPF(ii).name]);

F_S = fft2(Img);
F_S = abs(fftshift(F_S));
% figure; subplot(121); imagesc(NIImgs); colormap('gray');
%  subplot(122); imagesc (F_S(30:40,40:52));
ImageFourier_2D_to_1D(F_S);

LPF_xy(:,:,ii) = ans;

end

LPF_x2 = squeeze(LPF_xy(:,1,:));
LPF_y2 = squeeze(LPF_xy(:,2,:));

LPF_x_m2 = mean(LPF_x2,2);
LPF_y_m2 = mean(LPF_y2,2);

%% 

HPF = dir(['C:\Users\rskyb\OneDrive\Desktop\Natural Images\Used Image Set\150 Natural Images - HPF 2SD Gaussian ' '/*.tif']);
for ii = 1:length(HPF)
 
Img = imread([HPF(ii).folder '\' HPF(ii).name]);

F_S = fft2(Img);
F_S = abs(fftshift(F_S));
% figure; subplot(121); imagesc(NIImgs); colormap('gray');
%  subplot(122); imagesc (F_S(30:40,40:52));
ImageFourier_2D_to_1D(F_S);

HPF_xy(:,:,ii) = ans;

end

HPF_x2 = squeeze(HPF_xy(:,1,:));
HPF_y2 = squeeze(HPF_xy(:,2,:));

HPF_x_m2 = mean(HPF_x2,2);
HPF_y_m2 = mean(HPF_y2,2);

%% 

figure
    subplot(131)
    loglog(NI_x, NI_y)
    hold on
    loglog(NI_x_m, NI_y_m, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])

    subplot(132)
    loglog(LPF_x1, LPF_y1)
    hold on
    loglog(LPF_x_m1, LPF_y_m1, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])

    subplot(133)
    loglog(HPF_x1, HPF_y1)
    hold on
    loglog(HPF_x_m1, HPF_y_m1, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])

figure
    subplot(131)
    plot(NI_x, NI_y)
    hold on
    plot(NI_x_m, NI_y_m, 'k', 'LineWidth', 2)
    ylim([0 7*10^4])

    subplot(132)
    plot(LPF_x, LPF_y)
    hold on
    plot(LPF_x_m, LPF_y_m, 'k', 'LineWidth', 2)
    ylim([0 7*10^4])

    subplot(133)
    plot(HPF_x, HPF_y)
    hold on
    plot(HPF_x_m, HPF_y_m, 'k', 'LineWidth', 2)
    ylim([0 7*10^4])

figure
    subplot(131)
    semilogy(NI_x, NI_y)
    hold on
    semilogy(NI_x_m, NI_y_m, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])
    
    subplot(132)
    semilogy(LPF_x, LPF_y)
    hold on
    semilogy(LPF_x_m, LPF_y_m, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])

    subplot(133)
    semilogy(HPF_x, HPF_y)
    hold on
    semilogy(HPF_x_m, HPF_y_m, 'k', 'LineWidth', 2)
    ylim([10^1 10^5])

    
 figure
semilogy(NI_x_m, NI_y_m, 'LineWidth', 2)
hold on
semilogy(LPF_x_m1, LPF_y_m1, 'LineWidth', 2)
semilogy(HPF_x_m1, HPF_y_m1, 'LineWidth', 2)

 figure
plot(NI_x_m, NI_y_m, 'LineWidth', 2)
hold on
plot(LPF_x_m2, LPF_y_m2, 'LineWidth', 2)
plot(HPF_x_m2, HPF_y_m2, 'LineWidth', 2)

figure
semilogy(NI_x_m, NI_y_m, 'LineWidth', 2)
hold on
semilogy(LPF_x_m2, LPF_y_m2, 'LineWidth', 2)
semilogy(HPF_x_m2, HPF_y_m2, 'LineWidth', 2)

