s=randn(1,30);%Դ�ź�
theta = 0;%�Ƕ�
theta_pi = (theta/180)*pi;
d = 0.06;%���߾���
c = 3.0*10^8;%����
fc = 2400 * 10^6;%Ƶ��
tau = cos(theta_pi)*d/c;%ʱ��
s1 = s*exp(-i*fc*tau);%����ź�

