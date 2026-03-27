%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Wilfrido Gómez-Flores (Cinvestav)        %
% e-mail: wgomez@cinvestav.mx                      %
% Date:   february 2026                            %
% Subject: Pre-trained CAE-based feature extractor %
%          for BI-RADS classification              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars; close all; clc

k = 1; % k-fold experiment
[net, Y_true, kf, fnames] = downloadKfoldData(k); % Download data
% analyzeNetwork(net); % Uncomment to see the model structed

idx = kf==k; % Indentify samples of the kth-fold
fnames = fullfile(pwd,"BUSBRA/ROIs/",fnames(idx)); % Full path to images

n = numel(fnames);
Rec = zeros(128,128,n,"single"); % Reconstructions
Prb = zeros(n,4); % Posterior probabilities
SSIM = zeros(n,1); % SSIM values
for i = 1:n
    I = impreproc(imread(fnames{i})); % Preprocess image
    [Rec(:,:,i),Prb(i,:)] = minibatchpredict(net,I); % Predict with model
    SSIM(i) = ssim(I,Rec(:,:,i));
end
% Classify by maximum probability
[~,Y_pred] = max(Prb,[],2);

% Calculate confusion matrix
C = confusionmat(Y_true,Y_pred);
confusionchart(C,["B2","B3","B4","B5"]);

% Calculate accuracy
fprintf("Accuracy:\n");
acci = diag(C./sum(C,2)); % Per-class
accg = trace(C)/sum(C,"all"); % Global
for i = 1:numel(acci)
    fprintf("BI-RADS %d: %0.3f\n",i+1,acci(i));
end
fprintf("Global: %0.3f\n",accg);

% Show 10 images randomly
figure("Color","w","Position",[100 100 1440 380]);
idx = randperm(n,10);
ids = reshape(1:20,10,2);
for i = 1:10
    I = impreproc(imread(fnames{idx(i)}));
    subplot(2,10,ids(i,1));
    imshow(I)
    title(sprintf("True class: %d",Y_true(idx(i))+1));
    if ids(i,1)==1
        ylabel("Original");
    end
    subplot(2,10,ids(i,2));
    imshow(Rec(:,:,idx(i)));
    if Y_true(idx(i)) == Y_pred(idx(i))
        title(sprintf("Pred class: %d",Y_pred(idx(i))+1),'Color','k');
    else
        title(sprintf("Pred class: %d",Y_pred(idx(i))+1),'Color','r');
    end
    xlabel(sprintf("SSIM: %0.3f",SSIM(idx(i))))
    if ids(i,2)==11
        ylabel("Reconstructed");
    end
end