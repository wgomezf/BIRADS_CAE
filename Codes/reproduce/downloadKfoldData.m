function [net,Ytt,kf,fnames] = downloadKfoldData(k)
    % Download masked ROIs from Google drive
    BUSfolder = fullfile(pwd,"BUSBRA");
    if ~exist(BUSfolder,'dir')
        fileId = "1NGuHThMSNYiqJBkmESP1454Sczm4UBJ5"; % Do not modify
        fileName = "busbra.zip";
        Drive2Local(fileId,fileName);
        unzip(fileName,BUSfolder)
        delete(fileName)
    end
    
    % Model list in Google Drive
    folds = {'1KdqdDcjK2zHPP0MVVfbhfWUcPA8mUNTI','1CszLIkWS4kSBsZKu3eEfSx_K5MvtB0FG',...
             '1MVbEB3tVPIVuT7wa_hMtcANTcKsRE8FB','1hnFoKMuD-6eYSj64CRYtG7X4GESX7cx4',...
             '1h-rSxFIqAmJELs5o-MWmzZn-hHrEbR9X'}; % Do not modify
    % Choose a k-fold experiment
    if max(k,1) <= numel(folds)
        fileId = folds{k};
        fileName = "model.mat";
        if exist(fileName,'file')
            delete(fileName)
        end
        Drive2Local(fileId,fileName);
    else
        error('Just 5-folds are available.')
    end
    % Load CAE model
    load(fileName,'net','Ytt') % Get network and true labels of current fold
    
    % Load k-folds
    fileId = "1NeipRMBe593GWZ0_EgRIcBMDzmuiSwfw"; % Do not modify
    fileName = "kfolds.mat";
    if exist(fileName,'file')
        delete(fileName)
    end
    Drive2Local(fileId,fileName);
    load(fileName,'kf','fnames')

    fprintf('Model data downloaded successfully!\n')
end

%***********************************************************************************
function Drive2Local(fileId,fileName)
    fileUrl = sprintf("https://drive.google.com/uc?export=download&id=%s", fileId);
    options = weboptions('Timeout', Inf);
    websave(fileName, fileUrl, options);
end