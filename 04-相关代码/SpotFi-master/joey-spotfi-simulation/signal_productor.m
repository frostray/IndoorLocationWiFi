%s��Դ�ź�
%theta���Ƕ�
%fc������Ƶ��
%d������֮��ľ���
%s1������ź�
function s1 = signal_productor(s, theta, fc, d)

    scale = 0.01;%��������
    c = 3.0 * 10^8;%����
    sub_freq_delta = (20 * 10^6)/30;%�������ز�֮���Ƶ�ʲ�
    theta = (theta/180)*pi;
    tau = sin(theta)*d/c;%ʱ���
%     s1 = s*exp(-i*fc*tau);
    s1 = zeros(1,30);
    for ii = 1:30
        sub_freq = 2*pi* (fc + (ii-1)*sub_freq_delta);%���ز���Ƶ��
        s1(1,ii) = s*exp(-i*sub_freq*tau)+scale*(rand(1,1)+rand(1,1)*i);
    end
end