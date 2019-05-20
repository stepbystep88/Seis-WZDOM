%%%绘制已经抽取38层的图像
close all
clear all
clc

[wellname x y] = textread('D:\stochastic modeling\all source data\well_cdp.txt','%s %d %d');
load('D:\stochastic modeling\all source data\time_he8.mat');
load('D:\stochastic modeling\all source data\time_sh2.mat');
load('D:\stochastic modeling\all source data\time_sh1.mat');
H_data = load('D:\stochastic modeling\plot\plot cross section\input\rho_less_38_11.mat');
H_data = struct2cell(H_data);
H_data = H_data{1};

thiswell = 'SU59-9-48';
%%  找出thiswell的坐标
well_sum = size(wellname,1);
index = 1;
for i = 1:well_sum
    if(strcmp(wellname{i},thiswell))
        break;
    end
    index = index + 1;
end
this_cdp = x(index);
this_y = y(index);
%%  提取井数据及过井剖面数据
load('D:\stochastic modeling\newData\pos_know.mat');
load('D:\stochastic modeling\newData\time_he8.mat');
this_line = this_cdp - 2468 + 1;
t = this_line*601;


pos = find(pos_know(:,1) == this_cdp);
pos_y = find(pos_know(pos,2) == this_y);
pos = pos(pos_y);

well_pos = pos_know(pos,2) - 1500 + 1;
basetime = time_he8(t-600:t)';
time1 = time_sh1(t-600:t)';
time2 = time_sh2(t-600:t)';

data = H_data(:,t-600:t);
[row column]=size(data);
for i=1:row
    a = ButtLowPassFilter(data(i,:),0.2);
    data(i,:) = a;
end

path = ['D:\petrel\training_data\SLG\wells\',thiswell,'.txt'];
well = load(path);


well_num = (x(index)-2468)*601 + y(index);
this_he8 = time_he8(well_num);
well_start = this_he8 - 2*3;

start_num = max(find(well(:,1) <well_start));
sum = size(well,1);
if (start_num+37 < sum)
    well_data = well(start_num:start_num+37,7);
else 
    well_data(1:sum-start_num+1) = well(start_num:sum,7); 
    well_data(sum-start_num+2:38) = data(sum-start_num+2:38,well_pos);
end
% b = ButtLowPassFilter(well_data,0.4);
% well_data= b;
%% 绘图
horizon_restore2(data,basetime,2,time1,time2, well_pos, well_data);
xlabel('rho')


figure
plot(data(:,well_pos), 'r-');
hold on
% plot(well_p, 'b-');
plot(well_data, 'b-');













