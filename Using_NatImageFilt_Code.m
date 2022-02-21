


NI_Imgs = dir(['C:\Users\rskyb\OneDrive\Desktop\Natural Images\Used Image Set\150 Natural Images ' '/*.tif'])


for ii = 1:length(NI_Imgs)
    
   filename = [NI_Imgs(ii).folder '\' NI_Imgs(ii).name];
   ImgName =  NI_Imgs(ii).name;
   
   NatImageFilt(filename, ImgName); 
    
   
end

