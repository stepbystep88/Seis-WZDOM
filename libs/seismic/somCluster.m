function [facies, dataModel] = somCluster(seiData, clusterNum)
% 聚类数据

sD = som_data_struct(seiData);
sM = som_make(sD, 'msize', [1 clusterNum],'training', 'long');
dataModel = sM.codebook;
facies = som_bmus(sM,sD); % 查找匹配单元

end