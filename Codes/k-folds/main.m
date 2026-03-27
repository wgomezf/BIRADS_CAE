%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Wilfrido Gómez-Flores (Cinvestav)        %
% e-mail: wgomez@cinvestav.mx                      %
% Date:   february 2026                            %
% Subject: Convolutional Autoencoder-Based Feature %
%          Extractor for BI-RADS Classification    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Download masked ROIs from Google drive
BUSfolder = fullfile(pwd,"BUSBRA");
if ~exist(BUSfolder,'dir')
    fileId = "1NGuHThMSNYiqJBkmESP1454Sczm4UBJ5";
    fileName = "busbra.zip";
    fileUrl = sprintf("https://drive.google.com/uc?export=download&id=%s", fileId);
    websave(fileName, fileUrl);
    unzip(fileName,BUSfolder)
    delete(fileName)
end
% Create k-fold partitions
K = 5; % number of folds
mB = 64; % mini-batch size
T = readtable(fullfile(BUSfolder,"bus_data.csv"));
Y = categorical(T.BIRADS-1); % BI-RADS classes
numClasses = numel(unique(Y));
files = T.ID; % file names
[dsTrain,dsValid,dsTest] = SplitCombineImageDataStore(fullfile(BUSfolder,"ROIs"),fullfile(BUSfolder,"ROIs"),files,Y,mB,K);
% Create convolutional autoencoder with classification network
imSize = [128 128 1];
lgraph = EncDecConv(imSize,numClasses);
% Loss function
lossFcn = @(Y1,Y2,T1,T2) crossentropy(Y2,T2) + 0.1*mse(Y1,T1);
% k-fold cross-validation experiments
mkdir(fullfile(pwd,"Results"))
for k = 1:K
    % Validation frequency each epoch
    valFreq = floor(numel(dsTrain{k}.UnderlyingDatastores{1}.UnderlyingDatastores{3}.readall)/mB);
    % Training options
    options = trainingOptions("adam", ...
                            MaxEpochs=200, ...
                            InitialLearnRate=1e-4, ...
                            LearnRateSchedule="cosine", ...
                            MiniBatchSize=mB, ...
                            ValidationData=dsValid{k}, ...
                            ValidationPatience=Inf, ...
                            ValidationFrequency=valFreq, ...
                            Plots="none", ...
                            ExecutionEnvironment="gpu", ...
                            Shuffle="every-epoch",... 
                            OutputNetwork="best-validation", ...
                            Verbose=true);    
    % Train network
    [net,info] = trainnet(dsTrain{k},lgraph,lossFcn,options);
    % Predict: Y1 decoder output, Y2 classifier output
    [Y1,Y2] = minibatchpredict(net,dsTest{k});
    % Maximum probability classification rule
    [~,Ypp] = max(Y2,[],2);
    % Extract true class labels
    Ytt = double(cat(1,dsTest{k}.UnderlyingDatastores{1}.UnderlyingDatastores{3}.readall{:}));
    % Performance indices
    [ACC,ACP,PRE,SEN,SPE,F1S,MCC,AUC,C] = mulclassperf(Ytt,Ypp,Y2);
    perf = [ACC,ACP,PRE,SEN,SPE,F1S,MCC,AUC];
    % Save results
    save(fullfile(pwd,"Results",sprintf("fold%d.mat",k)),"net","info","Ypp","Ytt","Y2","C","perf");
end