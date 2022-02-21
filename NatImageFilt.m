


function NatImageFilt(filename, ImgName)

%% Read and initialize gray scale values
X = imread(filename);
X = double(X);
X = X - mean(X(:));

%% Filtering
h = fspecial('gaussian',50,2);
X_filt = filter2(h,X,'same');

%% Hi-pass filtering is the same as subtracting Lo-pass from original
X_res = X - X_filt;

%% Normalizing so the Dynamic Range is between 0 and 1
X = X - min(X(:));
X_filt = X_filt - min(X_filt(:));
X_res = X_res - min(X_res(:));

X = X/max(X(:));
X_filt = X_filt/max(X_filt(:));
X_res = X_res/max(X_res(:));

%% Using FFT2 for Fourier analysis
X_f = abs(fftshift(fft2(X)));
X_filt_f = abs(fftshift(fft2(X_filt)));
X_res_f = abs(fftshift(fft2(X_res)));

%% Plotting the results
% figure;
% subplot(2,3,1); imagesc(X); colormap('gray');
% subplot(2,3,2); imagesc(X_filt); colormap('gray');
% subplot(2,3,3); imagesc(X_res); colormap('gray');
% 
% subplot(2,3,4); imagesc(X_f); colormap('gray'); caxis([0 400])  
% subplot(2,3,5); imagesc(X_filt_f); colormap('gray');caxis([0 400])
% subplot(2,3,6); imagesc(X_res_f); colormap('gray');caxis([0 400])

%% Saving Filtered Images

savePath = 'C:\Users\rskyb\OneDrive\Desktop\Natural Images\Used Image Set\';

imwrite(X_filt, [savePath '150 Natural Images - LPF2\LPF_' ImgName ],'tif');
imwrite(X_res, [savePath '150 Natural Images - HPF2\HPF_' ImgName ],'tif');

end

%Written by Seiji Tanabe