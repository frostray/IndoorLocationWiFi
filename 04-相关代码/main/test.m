clear;
csi_trace = read_bf_file('data/Test1/64_HT20_test1.dat'); % ��ȡCSI�ļ�
% --------------------------------------------------------------------------------------------
% ��������
fc = 5.63e9; % ����Ƶ��
M = 3;    % rx��������
fs = 40e6; % �ŵ�����
c = 3e8;  %  ����
d = 2.6e-2;  % ��������������������֮��ľ���

SubCarrInd = [-58,-54,-50,-46,-42,-38,-34,-30,-26,-22,-18,-14,-10,-6,-2,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58]; % WiFi���ز�����������CSI�ǿ��õ�
N = length(SubCarrInd); % ���ز���
fgap = 312.5e3; % WiFi���������ز�֮���Ƶ�ʼ��(Hz)
lambda = c/fc;  % ����
T = 1; % ������������

paramRange = struct; % ����һ���ṹ��
paramRange.GridPts = [101 101 1]; % ��ʽΪ[ToF�����(����ʱ��)������Ǹ����(AoA)�� 1]
paramRange.delayRange = [-50 50]*1e-9; % Ҫ���ǵ�ToF��������ֵ����Сֵ��
paramRange.angleRange = 90*[-1 1]; % ΪAoA�����ǵ���Сֵ��ֵ��
do_second_iter = 0; 
paramRange.K = floor(M/2)+1; % ��ƽ����صĲ�����
paramRange.L = floor(N/2); % ��ƽ����صĲ�����
paramRange.T = 1; 
paramRange.deltaRange = [0 0];  

maxRapIters = Inf;
useNoise = 0;
paramRange.generateAtot = 2;
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
