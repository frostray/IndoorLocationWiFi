%theta���ź������
function data = data_productor(theta)
    s = randn(1,1);%Դ�ź�
    d = 0.06;%���߾���
    fc = 2400 * 10^6;%����Ƶ��
    s1 = signal_productor(s,theta,fc,d);%��һ�������ź�
    s2 = signal_productor(s,theta,fc,2*d);%�ڶ��������ź�
    s3 = signal_productor(s,theta,fc,3*d);%�����������ź�
    data = [s1;s2;s3];
end