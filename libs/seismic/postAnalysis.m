clc;clear; close all;
%%
file_path_name='NMHB_L463_NMO_1202_DATA_T0.segy';
fid=fopen(file_path_name,'r','ieee-be'); 
binary_header=fread(fid,3600,'uchar');
trace_num=71934;
samplenum=25;
indexCount = 0;
firstCDP = 548;
lastCDP = 2803;
pricdp=firstCDP;
num=0;

for i=1:trace_num
    trace_header  =fread(fid,60, 'int32');
    sgy_data(:,i)= fread(fid, samplenum, 'float32');%适用于sgy_IEEE格式
    cdpindex(1,i)=trace_header(6,1);
%     if trace_header(6,1)==pricdp
%         num=num+1;
%         data(:,num)=sgy_data;         
%     else
%         %%此处对数据data进行拉平
%         %，，，，，，，，，
%         %%
%         num=1;
%         clear data;
%         data(:,num)=sgy_data;
%         pricdp=trace_header(6,1);
%    end
    
end

Dataflat=sgy_data;
pricdp=firstCDP;
num=0;
cdpnum=1;
data=zeros(samplenum,lastCDP-firstCDP+1);
for i=1:trace_num
    if cdpindex(1,i)==pricdp
        num=num+1;
        data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum);         
    else
        data(:,cdpnum)=data(:,cdpnum)./num;
        cdpnum=cdpnum+1;
        num=1;
        data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum); 
        pricdp=cdpindex(1,i);
    end 
end
data(:,cdpnum)=data(:,cdpnum)./num;
[m,n]=size(data);
figure;TX=firstCDP:lastCDP;TY=1:m;
imagesc(TX,TY,data);colorbar;

%%
PostData=data;% -15 15
traceNum = length(PostData);
PostData=PostData(5:20,:);

%% 聚类
clusterNum = 5;
[facies, dataModel] = somCluster(PostData', clusterNum);
seismic= s_convert(-dataModel',0,2);     s_wplot(seismic);

f = 0.10;[b,a] = butter(10, f, 'low');
facies  = filtfilt(b, a, facies); 
repmatnum=15;
faciesMap = repmat(facies, 1, repmatnum);
faciesMap=faciesMap';
faciesMap=min(min(PostData))+20+(faciesMap-min(min(faciesMap)))./(max(max(faciesMap))-min(min(faciesMap))).*(max(max(PostData))-min(min(PostData)));
faciesMap(1:5,:)=min(min(PostData));
PostData=[PostData;faciesMap];

load('L463_593_2399_450_40_TimeT0.txt'); 
horizon=L463_593_2399_450_40_TimeT0(:,2);
Post=fillData(horizon,PostData);
lenths=max(horizon)-min(horizon);

[m,n]=size(Post);
figure;TX=firstCDP:lastCDP;TY=fix(min(horizon)-(20+20)*2):2:fix(max(horizon)+(20+20)*2);
imagesc(TX,TY,-Post);colorbar;
xlabel('沿T0层位地震波形分类图','fontsize',16);ylabel('时间（ms）','fontsize',16);
%%
% file_path_name='NMHB_L463_NMO_1202_DATA_T1.segy';
% fid=fopen(file_path_name,'r','ieee-be'); 
% binary_header=fread(fid,3600,'uchar');
% trace_num=61670;
% samplenum=25;
% indexCount = 0;
% firstCDP = 548;
% lastCDP = 2801;
% pricdp=firstCDP;
% num=0;
% 
% for i=1:trace_num
%     trace_header  =fread(fid,60, 'int32');
%     sgy_data(:,i)= fread(fid, samplenum, 'float32');%适用于sgy_IEEE格式
%     cdpindex(1,i)=trace_header(6,1);
% %     if trace_header(6,1)==pricdp
% %         num=num+1;
% %         data(:,num)=sgy_data;         
% %     else
% %         %%此处对数据data进行拉平
% %         %，，，，，，，，，
% %         %%
% %         num=1;
% %         clear data;
% %         data(:,num)=sgy_data;
% %         pricdp=trace_header(6,1);
% %    end
%     
% end
% 
% Dataflat=sgy_data;
% pricdp=firstCDP;
% num=0;
% cdpnum=1;
% data=zeros(samplenum,lastCDP-firstCDP+1);
% for i=1:trace_num
%     if cdpindex(1,i)==pricdp
%         num=num+1;
%         data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum);         
%     else
%         data(:,cdpnum)=data(:,cdpnum)./num;
%         cdpnum=cdpnum+1;
%         num=1;
%         data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum); 
%         pricdp=cdpindex(1,i);
%     end 
% end
% data(:,cdpnum)=data(:,cdpnum)./num;
% [m,n]=size(data);
% figure;TX=firstCDP:lastCDP;TY=1:m;
% imagesc(TX,TY,data);colorbar;
% 
% %%
% PostData=data;% -15 15
% traceNum = length(PostData);
% PostData=PostData(5:20,:);
% 
% %% 聚类
% clusterNum = 5;
% [facies, dataModel] = somCluster(PostData', clusterNum);
% seismic= s_convert(dataModel',0,2);     s_wplot(seismic);
% f = 0.10;[b,a] = butter(10, f, 'low');
% facies  = filtfilt(b, a, facies); 
% repmatnum=15;
% faciesMap = repmat(facies, 1, repmatnum);
% faciesMap=faciesMap';
% faciesMap=min(min(PostData))+20+(faciesMap-min(min(faciesMap)))./(max(max(faciesMap))-min(min(faciesMap))).*(max(max(PostData))-min(min(PostData)));
% faciesMap(1:5,:)=min(min(PostData));
% PostData=[PostData;faciesMap];
% 
% load('L463_593_2399_450_40_TimeT1.txt'); 
% horizon=L463_593_2399_450_40_TimeT1(:,2);
% Post=fillData(horizon,PostData);
% lenths=max(horizon)-min(horizon);
% 
% [m,n]=size(Post);
% figure;TX=firstCDP:lastCDP;TY=fix(min(horizon)-(20+20)*2):2:fix(max(horizon)+(20+20)*2);
% imagesc(TX,TY,Post);colorbar;
% xlabel('沿T1层位地震波形分类图','fontsize',16);ylabel('时间（ms）','fontsize',16);

%%
% file_path_name='NMHB_L463_NMO_1202_DATA_T2.segy';
% fid=fopen(file_path_name,'r','ieee-be'); 
% binary_header=fread(fid,3600,'uchar');
% trace_num=41045;
% samplenum=25;
% indexCount = 0;
% firstCDP = 548;
% lastCDP = 2801;
% pricdp=firstCDP;
% num=0;
% 
% for i=1:trace_num
%     trace_header  =fread(fid,60, 'int32');
%     sgy_data(:,i)= fread(fid, samplenum, 'float32');%适用于sgy_IEEE格式
%     cdpindex(1,i)=trace_header(6,1);
% %     if trace_header(6,1)==pricdp
% %         num=num+1;
% %         data(:,num)=sgy_data;         
% %     else
% %         %%此处对数据data进行拉平
% %         %，，，，，，，，，
% %         %%
% %         num=1;
% %         clear data;
% %         data(:,num)=sgy_data;
% %         pricdp=trace_header(6,1);
% %    end
%     
% end
% 
% Dataflat=sgy_data;
% pricdp=firstCDP;
% num=0;
% cdpnum=1;
% data=zeros(samplenum,lastCDP-firstCDP+1);
% for i=1:trace_num
%     if cdpindex(1,i)==pricdp
%         num=num+1;
%         data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum);         
%     else
%         data(:,cdpnum)=data(:,cdpnum)./num;
%         cdpnum=cdpnum+1;
%         num=1;
%         data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum); 
%         pricdp=cdpindex(1,i);
%     end 
% end
% data(:,cdpnum)=data(:,cdpnum)./num;
% [m,n]=size(data);
% figure;TX=firstCDP:lastCDP;TY=1:m;
% imagesc(TX,TY,data);colorbar;
% 
% %%
% PostData=data;% -15 15
% traceNum = length(PostData);
% 
% PostData=PostData(5:20,:);
% %% 聚类
% clusterNum = 5;
% [facies, dataModel] = somCluster(PostData', clusterNum);
% seismic= s_convert(dataModel',0,2);     s_wplot(seismic);
% f = 0.10;[b,a] = butter(10, f, 'low');
% facies  = filtfilt(b, a, facies); 
% repmatnum=15;
% faciesMap = repmat(facies, 1, repmatnum);
% faciesMap=faciesMap';
% faciesMap=min(min(PostData))+20+(faciesMap-min(min(faciesMap)))./(max(max(faciesMap))-min(min(faciesMap))).*(max(max(PostData))-min(min(PostData)));
% faciesMap(1:5,:)=min(min(PostData));
% PostData=[PostData;faciesMap];
% 
% load('L463_593_2399_450_40_TimeT2.txt'); 
% horizon=L463_593_2399_450_40_TimeT2(:,2);
% Post=fillData(horizon,PostData);
% lenths=max(horizon)-min(horizon);
% 
% [m,n]=size(Post);
% figure;TX=firstCDP:lastCDP;TY=fix(min(horizon)-(20+20)*2):2:fix(max(horizon)+(20+20)*2);
% imagesc(TX,TY,Post);colorbar;
% xlabel('沿T2层位地震波形分类图','fontsize',16);ylabel('时间（ms）','fontsize',16);
%%

file_path_name='NMHB_L463_NMO_1202_DATA_T3.segy';
fid=fopen(file_path_name,'r','ieee-be'); 
binary_header=fread(fid,3600,'uchar');
trace_num=22252;
samplenum=25;
indexCount = 0;
firstCDP = 548;
lastCDP = 2797;
pricdp=firstCDP;
num=0;

for i=1:trace_num
    trace_header  =fread(fid,60, 'int32');
    sgy_data(:,i)= fread(fid, samplenum, 'float32');%适用于sgy_IEEE格式
    cdpindex(1,i)=trace_header(6,1);
%     if trace_header(6,1)==pricdp
%         num=num+1;
%         data(:,num)=sgy_data;         
%     else
%         %%此处对数据data进行拉平
%         %，，，，，，，，，
%         %%
%         num=1;
%         clear data;
%         data(:,num)=sgy_data;
%         pricdp=trace_header(6,1);
%    end
    
end

Dataflat=sgy_data;
pricdp=firstCDP;
num=0;
cdpnum=1;
data=zeros(samplenum,lastCDP-firstCDP+1);
for i=1:trace_num
    if cdpindex(1,i)==pricdp
        num=num+1;
        data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum);         
    else
        data(:,cdpnum)=data(:,cdpnum)./num;
        cdpnum=cdpnum+1;
        num=1;
        data(:,cdpnum)=Dataflat(:,i)+data(:,cdpnum); 
        pricdp=cdpindex(1,i);
    end 
end
data(:,cdpnum)=data(:,cdpnum)./num;
[m,n]=size(data);
figure;TX=firstCDP:lastCDP;TY=1:m;
imagesc(TX,TY,data);colorbar;

%%
PostData=data;% -15 15
traceNum = length(PostData);
PostData=PostData(5:20,:);

%% 聚类
clusterNum = 5;
[facies, dataModel] = somCluster(PostData', clusterNum);
seismic= s_convert(dataModel',0,2);     s_wplot(seismic);
f = 0.10;[b,a] = butter(10, f, 'low');
facies  = filtfilt(b, a, facies); 
repmatnum=15;
faciesMap = repmat(facies, 1, repmatnum);
faciesMap=faciesMap';
faciesMap=min(min(PostData))+20+(faciesMap-min(min(faciesMap)))./(max(max(faciesMap))-min(min(faciesMap))).*(max(max(PostData))-min(min(PostData)));
faciesMap(1:5,:)=min(min(PostData));
PostData=[PostData;faciesMap];

load('L463_593_2399_450_40_TimeT3.txt'); 
horizon=L463_593_2399_450_40_TimeT3(:,2);
Post=fillData(horizon,PostData);
lenths=max(horizon)-min(horizon);

[m,n]=size(Post);
figure;TX=firstCDP:lastCDP;TY=fix(min(horizon)-(20+20)*2):2:fix(max(horizon)+(20+20)*2);
imagesc(TX,TY,Post);colorbar;
xlabel('沿T3层位地震波形分类图','fontsize',16);ylabel('时间（ms）','fontsize',16);
%%
% file_path_name='NMHB_L463_NMO_1202_DATA_T0_T4.segy';
% fid=fopen(file_path_name,'r','ieee-be'); 
% binary_header=fread(fid,3600,'uchar');
% trace_num=117796;
% samplenum=501;
% indexCount = 0;
% firstCDP = 548;
% lastCDP = 2804;
% pricdp=firstCDP;
% num=0;
% 
% for i=1:trace_num
%     trace_header  =fread(fid,60, 'int32');
%     sgy_data(:,i)= fread(fid, samplenum, 'float32');%适用于sgy_IEEE格式
%     cdpindex(1,i)=trace_header(6,1);
% %     if trace_header(6,1)==pricdp
% %         num=num+1;
% %         data(:,num)=sgy_data;         
% %     else
% %         %%此处对数据data进行拉平
% %         %，，，，，，，，，
% %         %%
% %         num=1;
% %         clear data;
% %         data(:,num)=sgy_data;
% %         pricdp=trace_header(6,1);
% %    end
%     
% end
% 
% Dataflat=sgy_data;
% pricdp=firstCDP;
% num=0;
% cdpnum=1;
% for i=1:trace_num
%     if cdpindex(1,i)==pricdp
%         num=num+1;
%         data(:,num)=Dataflat(:,i);         
%     else
%         
%         %%
%         for j=1:samplenum
%            index=find(data(j,:));
%            newdata(j,cdpnum)=sum(data(j,:))./length(index);
%         end
%         %%
%         cdpnum=cdpnum+1;
%         num=1;
%         clear data;
%             data(:,num)=Dataflat(:,i); 
%             pricdp=cdpindex(1,i);
%     end 
% end
% for j=1:samplenum
%      index=find(data(j,:));
%      newdata(j,cdpnum)=sum(data(j,:))./length(index);
% end
% load('L463_593_2399_450_40_TimeT0.txt');
% horizon=L463_593_2399_450_40_TimeT0(:,2);
% newdata=fillData(horizon,newdata);
% [m,n]=size(newdata);
% figure;TX=firstCDP:lastCDP;TY=fix(min(horizon)-(480+20)*2):2:fix(max(horizon)+(20+20)*2);
% imagesc(TX,TY,newdata);colorbar;
% hold on;
% load('L463_593_2399_450_40_TimeT0.txt');horizonT0=L463_593_2399_450_40_TimeT0(:,2);
% plot(TX,horizonT0);
% hold on;
% load('L463_593_2399_450_40_TimeT1.txt');horizonT1=L463_593_2399_450_40_TimeT1(:,2);addedx=length(horizonT1);TX=firstCDP:firstCDP+addedx-1;
% plot(TX,horizonT1);
% hold on;
% load('L463_593_2399_450_40_TimeT2.txt');horizonT2=L463_593_2399_450_40_TimeT2(:,2);addedx=length(horizonT2);TX=firstCDP:firstCDP+addedx-1;
% plot(TX,horizonT2);
% hold on;
% load('L463_593_2399_450_40_TimeT3.txt');horizonT3=L463_593_2399_450_40_TimeT3(:,2);addedx=length(horizonT3);TX=firstCDP:firstCDP+addedx-1;
% plot(TX,horizonT3);

