%Full Natural Image Preprocessing
Drive = ['F'];
Mouse = ['RS_M192'];
Section = [1];
NI_ImgBlock = [3]; %Set to Nat Img Block OR leave empty if no NI Block
WI_ImgBlock = []; %Set to Whitened Img Block OR leave empty if no WI Block
MI_ImgBlock = []; %Set to Mixed Img Block OR leave empty if no MI Block

%% 

%Natural Image Block Preprossesing

    if ~isempty(NI_ImgBlock)
        Condition = ['NI']; % Do not Change
        Natural_Image_PSTH_Generation(Drive, Mouse, Section, NI_ImgBlock, Condition)
        clear Condition
    end

% % Whitened Image Block Preprocessing
% 
%     if ~isempty(WI_ImgBlock)
%         Condition = ['WI']; % Do not Change
%         Natural_Image_PSTH_Generation(Mouse, Section, WI_ImgBlock, Condition)
%         clear Condition
%     end
% 
% % Mixed Image Block Preprocessing
% 
%     if ~isempty(MI_ImgBlock)
%         Condition = ['MI']; % Do not Change
%         Natural_Image_PSTH_Generation(Mouse, Section, MI_ImgBlock, Condition) 
%         clear Condition
%     end

% Combining, Normalizing and Separating Data from Same Section
    
    Normalizing_Nat_Img_Data(Drive, Mouse, Section)

% Natural Image Block Preprossesing

    Condition = ['NI'];
    Finding_SUs(Drive, Mouse, Section, NI_ImgBlock, Condition)
    Finding_Responsive_SUs(Drive, Mouse, Section, NI_ImgBlock, Condition)
    Computing_PCA_Nat_Img(Drive, Mouse, Section, NI_ImgBlock, Condition)
    clear Condition
    
% % Whitened Image Block Preprossesing
% 
%     Condition = ['WI'];
%     Finding_SUs(Mouse, Section, WI_ImgBlock, Condition)
%     Finding_Responsive_SUs(Mouse, Section, WI_ImgBlock, Condition)
%     Computing_PCA_Nat_Img(Mouse, Section, WI_ImgBlock, Condition)
%     clear Condition
%  
% % Mixed Image Block Preprossesing
% 
%     Condition = ['MI'];
%     Finding_SUs(Mouse, Section, NI_ImgBlock, Condition)
%     Finding_Responsive_SUs(Mouse, Section, NI_ImgBlock, Condition)
%     Computing_PCA_Nat_Img(Mouse, Section, NI_ImgBlock, Condition)
%     clear Condition
%     