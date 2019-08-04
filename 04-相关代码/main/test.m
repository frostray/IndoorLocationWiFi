clear;
csi_trace = read_bf_file('data/Test1/64_HT20_test1.dat');
% --------------------------------------------------------------------------------------------
% ��������
fc = 5.63e9; 
M = 3;    
fs = 40e6; 
c = 3e8;  
d = 2.6e-2;  

SubCarrInd = [-58,-54,-50,-46,-42,-38,-34,-30,-26,-22,-18,-14,-10,-6,-2,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58]; %WiFi子载波索引，其中CSI是可用的
N = length(SubCarrInd); % 子载波的数量 30
fgap = 312.5e3; % WiFi中连续子载波之间的频率间�?(Hz)
lambda = c/fc;  % 波长=光�??/频率
T = 1; % 发射天线的数�?

paramRange = struct; % 定义paramRange结构�?
paramRange.GridPts = [101 101 1]; % 格式为[ToF，AoA�? 1]
paramRange.delayRange = [-50 50]*1e-9; % 要�?�虑的ToF网格的最大�?�和�?小�?��?�[-25ns,25ns]
paramRange.angleRange = 90*[-1 1]; % 要�?�虑的AoA网格的最大�?�和�?小�?��?�[-90,90]
do_second_iter = 0; % 第二通路�?
paramRange.K = floor(M/2)+1; % 与平滑相关的参数�? 
paramRange.L = floor(N/2); % 与平滑相关的参数�? 
paramRange.T = 1; % ?
paramRange.deltaRange = [0 0];  %变量�?

maxRapIters = Inf; % inf为无穷大的意�?
useNoise = 0;
paramRange.generateAtot = 2;% 生成Atot �?
AoA = [];%���aoaֵ������
% --------------------------------------------------------------------------------------------
% ѭ������csi����
for i=1:10 %������ȡ�����ݰ��ĸ���
    % --------��ȡ���ݰ�----------------
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry); %��ȡcsi����   
    % --------TOF----------------
    csi_plot = reshape(csi, N, M);% ת��Ϊ30*3�ľ��� 
    [PhsSlope, PhsCons] = removePhsSlope(csi_plot,M,SubCarrInd,N);
    ToMult = exp(1i* (-PhsSlope*repmat(SubCarrInd(:),1,M) - PhsCons*ones(N,M) ));
    csi_plot = csi_plot.*ToMult;
    relChannel_noSlope = reshape(csi_plot, N, M, T);
    sample_csi_trace_sanitized = relChannel_noSlope(:);
    % --------AOA----------------
    aoaEstimateMatrix = backscatterEstimationMusic(sample_csi_trace_sanitized, M, N, c, fc,...
                    T, fgap, SubCarrInd, d, paramRange, maxRapIters, useNoise, do_second_iter, ones(2)) ;  
    tofEstimate = aoaEstimateMatrix(:,1); % ToF in nanoseconds
    aoaEstomate = aoaEstimateMatrix(:,2); % AoA in degrees
    % --------��Ž���A0A����----------------
    aoaEstomate = aoaEstomate';
    AoA = [AoA;aoaEstomate];
end
