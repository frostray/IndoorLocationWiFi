%ʹ��N�εĲ�����,�����ǵ�MUSIC����ӣ�Ȼ���ҷ�ֵ
%theta���Ƕ�
%N��������
function aoa = spotfi_simulation(theta,N)
    frequency = 2400 * 10^6;%����Ƶ��
    sub_freq_delta = (20 * 10^6)/30;%�����������ز�֮���Ƶ�ʲ�
    antenna_distance = 0.06;%�������߾���
    
    theta_range = -90:1:90; 
    tau_range = 0:(1.0 * 10^-9):(100 * 10^-9);
    Pmusic = zeros(length(theta_range), length(tau_range));
    
    %ѭ������N���źţ��������źŵ��׵ĺ�
    for jj = 1:N
        data = data_productor(theta);%�����ź�
        smoothed_sanitized_csi = smooth_csi(data);%ƽ��
        eigenvectors = noise_space_eigenvectors(smoothed_sanitized_csi);%�������ӿռ�
        Pmusic = Pmusic + music_spectrum(theta_range,tau_range,frequency, sub_freq_delta, antenna_distance,eigenvectors);%��AoA�ף�ѭ������N����
    end
    
    [aoa, tof] = find_music_peaks(Pmusic,theta_range,tau_range);%�ҷ�ֵ
    
    %%
    [x,y] = meshgrid(theta_range, tau_range);
    figure(1);
    mesh(x,y,Pmusic');
    xlabel('AoA');
    ylabel('ToF');
    xlim([-90 90]);
    colorbar;

    figure(2);
    mesh(x,y,Pmusic');
    view(2);
    xlabel('AoA');
    ylabel('ToF');
    xlim([-90 90]);
    colorbar;
    
    
%     [aoa, tof] = aoa_tof_music(...
%                 smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, '-');
    
%     data = data_productor(theta);
%     smoothed_sanitized_csi = smooth_csi(data);
%     [aoa, tof] = aoa_tof_music(...
%                 smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, '-');
    
%     data1 = data_productor(30);
%     data2 = data + data1;
%     smoothed_sanitized_csi = smooth_csi(data2);
%     [aoa, tof] = aoa_tof_music(...
%                 smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, '-');
    
end