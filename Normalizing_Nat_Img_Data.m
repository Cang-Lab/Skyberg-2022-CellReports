function Normalizing_Nat_Img_Data(Drive, Mouse, Section)

    % Finding and Loading Natural Image Response Data
    NI_Block = inputdlg('Input Natural Image Block Number.');
    NI_Block = str2num(NI_Block{1,1});

    if ~isempty(NI_Block)
        NI_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(NI_Block) '\' Mouse '_Section_' num2str(Section) '_NI_Filt_Data.mat'];
        load(NI_FilePath);
        NI_Data = Filt_Data;
        Num_NI_Imgs = length(NI_Data(1).FilteredPSTH(:,1));
        clear Filt_Data
    else
       % clear NI_Block
    end

    % Finding and Loading Whitened Image Response Data
    WI_Block = inputdlg('Input Whitened Image Block Number.');
    WI_Block = str2num(WI_Block{1,1});

    if ~isempty(WI_Block)
        WI_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(WI_Block) '\' Mouse '_Section_' num2str(Section) '_WI_Filt_Data.mat'];
        load(WI_FilePath);
        WI_Data = Filt_Data;
        Num_WI_Imgs = length(WI_Data(1).FilteredPSTH(:,1));
        clear Filt_Data
    else 
        %clear WI_Block
    end

    Answer = inputdlg(['Does Mouse ' Mouse ' Section ' num2str(Section) ' have a mixed image block (Input must be Y or N)?']);

    if Answer{1,1} == 'Y'

        % Finding and Loading Mixed Image Response Data
        MI_Block = inputdlg('Input Mixed Image Block Number.');
        MI_Block = str2num(MI_Block{1,1});

        if ~isempty(MI_Block)
            MI_FilePath = [Drive ':\Science\MountainSort\' Mouse '\' Mouse '_Section_' num2str(Section) '\Processed Data\Block ' num2str(MI_Block) '\' Mouse '_Section_' num2str(Section) '_MI_Filt_Data.mat'];
            load(MI_FilePath);
            MI_Data = Filt_Data;
            Num_MI_Imgs = length(MI_Data(1).FilteredPSTH(:,1));
            clear Filt_Data
        else 
            clear MI_Block
        end

        % Concatinating Data from Same Section, Normalizing and then Separating
        for Cluster = 1:length(NI_Data)

            TempData_Concat(:,:,Cluster) = [NI_Data(Cluster).FilteredPSTH(:,1:500); WI_Data(Cluster).FilteredPSTH(:,1:500); MI_Data(Cluster).FilteredPSTH(:,1:500)];
            TempData_Concat(:,:,Cluster) = TempData_Concat(:,:,Cluster)/max(max(TempData_Concat(:,:,Cluster)));


            NI_Data(Cluster).Normalized = TempData_Concat(1:Num_NI_Imgs,:,Cluster);
            WI_Data(Cluster).Normalized = TempData_Concat((Num_NI_Imgs + 1):(Num_NI_Imgs + Num_WI_Imgs),:,Cluster);
            MI_Data(Cluster).Normalized = TempData_Concat((Num_NI_Imgs + Num_WI_Imgs + 1):(Num_NI_Imgs + Num_WI_Imgs + Num_MI_Imgs),:,Cluster);

        end

        Filt_Data = NI_Data;
        save(NI_FilePath, 'Filt_Data');
        clear Filt_Data

        Filt_Data = WI_Data;
        save(WI_FilePath, 'Filt_Data');
        clear Filt_Data

        Filt_Data = MI_Data;
        save(MI_FilePath, 'Filt_Data');
        clear Filt_Data

    elseif Answer{1,1} == 'N'

        % Concatinating Data from Same Section, Normalizing and then Separating if
        % no MI block exists
        
        if ~isempty(WI_Block)
        
            for Cluster = 1:length(NI_Data)

                TempData_Concat(:,:,Cluster) = [NI_Data(Cluster).FilteredPSTH(:,1:500); WI_Data(Cluster).FilteredPSTH(:,1:500)];
                TempData_Concat(:,:,Cluster) = TempData_Concat(:,:,Cluster)/max(max(TempData_Concat(:,:,Cluster)));


                NI_Data(Cluster).Normalized = TempData_Concat(1:Num_NI_Imgs,:,Cluster);
                WI_Data(Cluster).Normalized = TempData_Concat((Num_NI_Imgs + 1):(Num_NI_Imgs + Num_WI_Imgs),:,Cluster);

            end

            Filt_Data = NI_Data;
            save(NI_FilePath, 'Filt_Data');
            clear Filt_Data

            Filt_Data = WI_Data;
            save(WI_FilePath, 'Filt_Data');
            clear Filt_Data

        
        else %if no WI block exists then this is run
            
            for Cluster = 1:length(NI_Data)

                TempData_Concat(:,:,Cluster) = NI_Data(Cluster).FilteredPSTH(:,1:500);
                TempData_Concat(:,:,Cluster) = TempData_Concat(:,:,Cluster)/max(max(TempData_Concat(:,:,Cluster)));


                NI_Data(Cluster).Normalized = TempData_Concat(:,:,Cluster);
                
            end
            
            Filt_Data = NI_Data;
            save(NI_FilePath, 'Filt_Data');
            clear Filt_Data
            
        end
        
    end

end

