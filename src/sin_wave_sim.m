% =========================================================
% SIN_WAVE_SIM.M - Mô phỏng dạng sóng Sin
% Tác giả: Antigravity Agent | MATLAB R2024a
% Ngày: 16/03/2026
% =========================================================

clear; clc;

%% --- Tham số mô phỏng ---
fs     = 1000;          % Tần số lấy mẫu (Hz)
T      = 1;             % Thời gian mô phỏng (giây)
t      = 0:1/fs:T-1/fs; % Vector thời gian

f1     = 5;    A1 = 1.0; phi1 = 0;
f2     = 15;   A2 = 0.6; phi2 = pi/4;
f3     = 30;   A3 = 0.3; phi3 = pi/2;

%% --- Tạo sóng sin ---
s1 = A1 * sin(2*pi*f1*t + phi1);
s2 = A2 * sin(2*pi*f2*t + phi2);
s3 = A3 * sin(2*pi*f3*t + phi3);
s_composite = s1 + s2 + s3;

%% --- FFT ---
N   = length(t);
S   = abs(fft(s_composite)/N);
S_one_sided = 2 * S(1:N/2+1);
f_one_sided = (0:N/2) * fs/N;

%% --- Plot ---
figure('Position', [100,100,1200,700]);
subplot(3,2,[1 2]); hold on;
plot(t, s1,'b-','LineWidth',1.5,'DisplayName',sprintf('f=%dHz',f1));
plot(t, s2,'r--','LineWidth',1.5,'DisplayName',sprintf('f=%dHz',f2));
plot(t, s3,'g:','LineWidth',1.5,'DisplayName',sprintf('f=%dHz',f3));
hold off; xlabel('t (s)'); ylabel('Amplitude'); title('Component Waves'); legend; grid on; xlim([0 0.5]);

subplot(3,2,[3 4]);
plot(t, s_composite,'m-','LineWidth',1.5);
xlabel('t (s)'); ylabel('Amplitude'); title('Composite Signal'); grid on; xlim([0 0.5]);

subplot(3,2,[5 6]);
stem(f_one_sided, S_one_sided,'filled','LineWidth',1.2);
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('FFT Spectrum'); xlim([0 50]); grid on;

sgtitle('Sin Wave Simulation — MATLAB R2024a','FontSize',14,'FontWeight','bold');
saveas(gcf, 'sin_wave_result.png');

fprintf('RMS=%.4f V | Peak=%.4f V | Energy=%.4f J/Ohm\n', rms(s_composite), max(abs(s_composite)), sum(s_composite.^2)/fs);
