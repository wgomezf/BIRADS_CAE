function [ACC,ACP,PRE,SEN,SPE,F1S,MCC,AUC,C] = mulclassperf(Y,Yp,Prb)
c  = unique(Y);
k  = numel(c);
C  = zeros(k);
for i = 1:k
    for j = 1:k
        C(i,j) = sum((Y==c(i))&(Yp==c(j)));
    end
end
n  = sum(C(:));
tp = zeros(1,k);   % True positives
tn = zeros(1,k);   % True negatives
fp = zeros(1,k);   % False negatives
fn = zeros(1,k);   % False positives
for i = 1:k
    tp(i) = C(i,i);
    fp(i) = sum(C(i,:))-C(i,i);
    fn(i) = sum(C(:,i))-C(i,i);
    tn(i) = n-(tp(i)+fp(i)+fn(i));
end
ACC = trace(C)/n; % Exactitud global
ACP = sum(tp+tn)/(n*k); % Exactitud promedio
PRE = mean(tp./(tp+fp)); % Presicion
SEN = mean(tp./(tp+fn)); % Sensibilidad
SPE = mean(tn./(tn+fp)); % Especificidad
F1S = (2*PRE*SEN)/(PRE+SEN); % F1-score
% Compute multiclass MCC
NC = k;
Skl_num  = 0;
Skl_den1 = 0;
Skl_den2 = 0;
Ct = C';
for k = 1:NC
    for l = 1:NC
        Skl_num  = Skl_num  + sum(C(k,:).*(C(:,l)'));
        Skl_den1 = Skl_den1 + sum(C(k,:).*(Ct(:,l)'));
        Skl_den2 = Skl_den2 + sum(Ct(k,:).*(C(:,l)'));
    end
end
MCC = (n*trace(C) - Skl_num)/(sqrt(n*n - Skl_den1)*sqrt(n*n - Skl_den2));
AUC = zeros(1,NC);
for i = 1:NC
    [~,~,~,AUC(i)] = perfcurve(Y==c(i),Prb(:,i),1);
end
AUC = mean(AUC);