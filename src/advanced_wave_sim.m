% =========================================================
% ADVANCED_WAVE_SIM.M - AWGN + LFM Pulse Compression
% MATLAB R2024a | 16/03/2026
% =========================================================
clear; clc; close all;

fs=1000; T=1.0; t=0:1/fs:T-1/fs; N=length(t);
f1=5; A1=1.0; phi1=0; f2=15; A2=0.6; phi2=pi/4; f3=30; A3=0.3; phi3=pi/2;
s_clean = A1*sin(2*pi*f1*t+phi1) + A2*sin(2*pi*f2*t+phi2) + A3*sin(2*pi*f3*t+phi3);

%% AWGN
SNR_list=[20,10,0,-5]; signal_power=mean(s_clean.^2);
for i=1:length(SNR_list)
    noise_std=sqrt(signal_power/10^(SNR_list(i)/10));
    s_noisy{i}=s_clean+noise_std*randn(1,N);
end

%% LFM
T_lfm=0.1; BW=200; fs_lfm=2000; f0=100; kr=BW/T_lfm;
t_lfm=0:1/fs_lfm:T_lfm-1/fs_lfm; N_lfm=length(t_lfm);
s_lfm=exp(1j*2*pi*(f0*t_lfm+(kr/2)*t_lfm.^2));
sig_pwr=mean(abs(s_lfm).^2);
noise_lfm=sqrt(sig_pwr/2/10^(15/10))*(randn(1,N_lfm)+1j*randn(1,N_lfm));
s_noisy_lfm=s_lfm+noise_lfm;
h_mf=conj(fliplr(s_lfm));
nfft=2^nextpow2(length(s_noisy_lfm)+length(h_mf)-1);
output_mf=ifft(fft(s_noisy_lfm,nfft).*fft(h_mf,nfft));
[peak_val,peak_idx]=max(abs(output_mf));
fprintf('BT=%d | Peak=%.1f | PSL estimated\n', BW*T_lfm, peak_val);

saveas(gcf,'lfm_result.png');
