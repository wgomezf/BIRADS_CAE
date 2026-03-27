function [dsTrain,dsValid,dsTest] = SplitCombineImageDataStore(pathIn,pathOut,files,Y,mB,K)
dsTrain = cell(1,K);
dsValid = cell(1,K);
dsTest = cell(1,K);
kf = crossvalind('Kfold',Y,K);
for k = 1:K
    [dsTrain{k},dsValid{k},dsTest{k}] = SplitCombine(pathIn,pathOut,files,Y,mB,kf,k);
    dsTrain{k} = transform(dsTrain{k},@commonPreprocessing);
    dsValid{k} = transform(dsValid{k},@commonPreprocessing);
    dsTest{k}  = transform(dsTest{k},@commonPreprocessing);
    dsTrain{k} = transform(dsTrain{k},@augmentImages);
end
%************************************************************************
function [dsTrain,dsValid,dsTest] = SplitCombine(pathIn,pathOut,files,Y,mB,kf,k)
tr = kf~=k;
tt = kf==k;
filesTr = files(tr); Ytr = Y(tr);
filesTt = files(tt); Ytt = Y(tt);
[lr,vd] = crossvalind('HoldOut',Ytr,0.2);
filesLr = filesTr(lr); Ylr = Ytr(lr);
filesVd = filesTr(vd); Yvd = Ytr(vd);
imdsTrainIn  = getDatastore(pathIn,filesLr,Ylr,mB);
imdsTrainOut = getDatastore(pathOut,filesLr,Ylr,mB);
imdsValidIn  = getDatastore(pathIn,filesVd,Yvd,mB);
imdsValidOut = getDatastore(pathOut,filesVd,Yvd,mB);
imdsTestIn   = getDatastore(pathIn,filesTt,Ytt,mB);
imdsTestOut  = getDatastore(pathOut,filesTt,Ytt,mB);
lbTrain = arrayDatastore(Ylr);
lbTrain.ReadSize = mB;
lbValid = arrayDatastore(Yvd);
lbValid.ReadSize = mB;
lbTest = arrayDatastore(Ytt);
lbTest.ReadSize = mB;
dsTrain = combine(imdsTrainIn,imdsTrainOut,lbTrain);
dsValid = combine(imdsValidIn,imdsValidOut,lbValid);
dsTest  = combine(imdsTestIn,imdsTestOut,lbTest);
%************************************************************************
function imds = getDatastore(pathImgs,files,Y,mB)
fs = matlab.io.datastore.FileSet(fullfile(pathImgs,append(files,".png")));
imds = imageDatastore(fs);
imds.Labels = Y;
imds.ReadSize = mB;