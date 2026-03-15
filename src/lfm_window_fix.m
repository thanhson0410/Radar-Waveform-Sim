% =========================================================
% LFM_WINDOW_FIX.M - Fix Issue #1: PSL via Window Functions
% Method: Time-domain windowing on reference signal (MF template)
% nfft = 2^nextpow2(2N-1) for correct linear convolution
% MATLAB R2024a | 16/03/2026
% =========================================================
clear; clc; close all;

T_lfm=0.1; BW=200; fs=4000; f0=100;
kr=BW/T_lfm; BT=BW*T_lfm;
t=0:1/fs:T_lfm-1/fs; N=length(t);
nfft_conv=2^nextpow2(2*N-1);

rng(42);
s_tx = exp(1j*2*pi*(f0*t+(kr/2)*t.^2));
P_s = mean(abs(s_tx).^2);
sig = sqrt(P_s/10^(25/10)/2);
s_rx = s_tx + sig*(randn(1,N)+1j*randn(1,N));

w_names={'Rectangular','Hamming','Hanning','Taylor(n=5)','Blackman'};
wins={ones(1,N),hamming(N)',hanning(N)',taylorwin(N,5,-35)',blackman(N)'};
w_colors={[0 0 0],[0 0.45 0.74],[0.47 0.67 0.19],[0.85 0.32 0.10],[0.49 0.18 0.56]};

L_out=2*N-1; t_out_ms=((0:L_out-1)/fs-(N-1)/fs)*1000;
env_all=zeros(5,L_out); PSL_all=zeros(1,5); MLW_all=zeros(1,5);

for i=1:5
    s_ref=s_tx.*wins{i};
    H_MF=conj(fft(s_ref,nfft_conv));
    y_mf=ifft(fft(s_rx,nfft_conv).*H_MF);
    env=abs(y_mf(1:L_out));
    env_all(i,:)=env;
    [pv,pi_]=max(env);
    above=env>=pv/sqrt(2); idx_ml=find(above);
    if length(idx_ml)>=2, MLW_all(i)=(idx_ml(end)-idx_ml(1)+1)/fs*1000;
    else, MLW_all(i)=1/fs*1000; end
    n2n=max(4,round(2*fs/BW));
    env_sl=env; env_sl(max(1,pi_-n2n):min(L_out,pi_+n2n))=0;
    PSL_all(i)=20*log10(max(env_sl)/pv+eps);
    fprintf('[%d] %-18s PSL=%7.2f dB | MLW=%.2f ms\n',i,w_names{i},PSL_all(i),MLW_all(i));
end

fig=figure('Position',[50 50 1400 920]);
subplot(3,2,[1 2]); hold on;
for i=1:5, ev=env_all(i,:)/max(env_all(i,:)); plot(t_out_ms,ev,'Color',w_colors{i},'LineWidth',1.5,'DisplayName',w_names{i}); end
hold off; xlim([-30 30]); ylim([0 1.05]);
title('Normalized MF Output (Linear)','FontWeight','bold'); xlabel('Delay (ms)'); ylabel('Norm. Amplitude'); legend; grid on;

subplot(3,2,[3 4]); hold on;
for i=1:5
    ev_dB=20*log10(env_all(i,:)/max(env_all(i,:))+1e-10);
    plot(t_out_ms,ev_dB,'Color',w_colors{i},'LineWidth',1.5,'DisplayName',sprintf('%s (PSL=%.1fdB)',w_names{i},PSL_all(i)));
end
yline(-13.2,'k:','-13.2dB','LineWidth',2); yline(-35,'r:','-35dB target','LineWidth',2);
hold off; xlim([-30 30]); ylim([-80 5]);
title('MF Output dB — PSL Comparison','FontWeight','bold'); xlabel('Delay (ms)'); ylabel('dB'); legend('Location','northeast'); grid on;

subplot(3,2,5); b=bar(PSL_all,'FaceColor','flat','EdgeColor','k');
for i=1:5, b.CData(i,:)=w_colors{i}; end
set(gca,'XTickLabel',w_names,'XTickLabelRotation',20,'FontSize',9);
yline(-13.2,'k--','LineWidth',2); yline(-35,'r--','LineWidth',2);
ylabel('PSL (dB)'); title('PSL Comparison','FontWeight','bold'); ylim([-80 5]); grid on;

subplot(3,2,6); b2=bar(MLW_all,'FaceColor','flat','EdgeColor','k');
for i=1:5, b2.CData(i,:)=w_colors{i}; end
set(gca,'XTickLabel',w_names,'XTickLabelRotation',20,'FontSize',9);
yline(1000/BW,'r--',sprintf('Theory=%.0fms',1000/BW),'LineWidth',2);
ylabel('Mainlobe Width (ms)'); title('Resolution Trade-off','FontWeight','bold'); grid on;
sgtitle('Fix Issue #1 — PSL Window Functions (LFM BT=20, fs=4kHz)','FontSize',13,'FontWeight','bold');
saveas(fig,'psl_window_comparison.png');

fprintf('\nSUMMARY:\n');
for i=1:5, fprintf('  %-18s PSL=%7.2f dB | MLW=%.2f ms\n',w_names{i},PSL_all(i),MLW_all(i)); end
[~,bi]=min(PSL_all); fprintf('BEST: %s (%.2f dB)\n',w_names{bi},PSL_all(bi));
