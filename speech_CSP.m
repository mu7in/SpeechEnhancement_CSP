clc;
clear all;
close all;

%% speech_CSP.m - Complete Script using audio.wav

%% 1. Load Speech Signal from WAV file
[x, fs] = audioread('audio.wav');
x = x(:,1)';                          % Convert to mono (use left channel if stereo)
t = (0:length(x)-1) / fs;             % Time vector based on actual audio
report_dir = 'Project_Final_220932386_Muhsin';

%% 2. Add Noise
rng(0);                                % Reproducible noise for consistent metrics and plots
noise_power = 0.05;
noisy_signal = x + noise_power * randn(size(x));

%% 3. FIR Filter (Low-pass, cutoff 3400 Hz)
fir_order = 50;
fir_cutoff = 3400 / (fs/2);           % Normalized cutoff frequency
b_fir = fir1(fir_order, fir_cutoff);
fir_output = filter(b_fir, 1, noisy_signal);

%% 4. IIR Filter (Butterworth Low-pass, cutoff 3400 Hz)
iir_order = 4;
iir_cutoff = 3400 / (fs/2);
[b_iir, a_iir] = butter(iir_order, iir_cutoff, 'low');
iir_output = filter(b_iir, a_iir, noisy_signal);

%% 5. Save Figures for LaTeX

% Original Signal
figure;
plot(t, x);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '1_original_signal.png');
saveas(gcf, fullfile(report_dir, 'original_signal.png'));

% Noisy Signal
figure;
plot(t, noisy_signal);
title('Noisy Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '2_noisy_signal.png');
saveas(gcf, fullfile(report_dir, 'noisy_signal.png'));

% FIR Output
figure;
plot(t, fir_output);
title('FIR Filter Output');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '3_fir_output.png');
saveas(gcf, fullfile(report_dir, 'fir_output.png'));

% IIR Output
figure;
plot(t, iir_output);
title('IIR Filter Output');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '4_iir_output.png');
saveas(gcf, fullfile(report_dir, 'iir_output.png'));

%% Frequency Domain Analysis (FFT)

% FFT of Original Signal
figure;
plot(abs(fft(x)));
title('Frequency Spectrum of Original Signal');
xlabel('Frequency Bins');
ylabel('Magnitude');
saveas(gcf, '5_fft_original.png');
saveas(gcf, fullfile(report_dir, 'fft_original.png'));

% FFT of Noisy Signal
figure;
plot(abs(fft(noisy_signal)));
title('Frequency Spectrum of Noisy Signal');
xlabel('Frequency Bins');
ylabel('Magnitude');
saveas(gcf, '6_fft_noisy.png');
saveas(gcf, fullfile(report_dir, 'fft_noisy.png'));

% FFT of FIR Output
figure;
plot(abs(fft(fir_output)));
title('Frequency Spectrum of FIR Output');
xlabel('Frequency Bins');
ylabel('Magnitude');
saveas(gcf, '7_fft_fir.png');
saveas(gcf, fullfile(report_dir, 'fft_fir.png'));

% FFT of IIR Output
figure;
plot(abs(fft(iir_output)));
title('Frequency Spectrum of IIR Output');
xlabel('Frequency Bins');
ylabel('Magnitude');
saveas(gcf, '8_fft_iir.png');
saveas(gcf, fullfile(report_dir, 'fft_iir.png'));

% FIR Filter Response
figure;
freqz(b_fir,1);
saveas(gcf, '9_fir_response.png');
saveas(gcf, fullfile(report_dir, 'fir_response.png'));

% IIR Filter Response
figure;
freqz(b_iir,a_iir);
saveas(gcf, '10_iir_response.png');
saveas(gcf, fullfile(report_dir, 'iir_response.png'));

disp('Done! All figures saved.');

% SNR calculation
snr_noisy = snr(x, noisy_signal - x);
snr_fir = snr(x, fir_output - x);
snr_iir = snr(x, iir_output - x);

fprintf('SNR Noisy: %.2f dB\n', snr_noisy);
fprintf('SNR FIR: %.2f dB\n', snr_fir);
fprintf('SNR IIR: %.2f dB\n', snr_iir);

% MSE Calculation
mse_noisy = mean((x - noisy_signal).^2);
mse_fir = mean((x - fir_output).^2);
mse_iir = mean((x - iir_output).^2);

fprintf('MSE Noisy: %.6f\n', mse_noisy);
fprintf('MSE FIR: %.6f\n', mse_fir);
fprintf('MSE IIR: %.6f\n', mse_iir);

%% Play Original Signal
disp('Playing Original Signal...');
sound(x, fs);
pause(length(x)/fs + 1);

%% Play Noisy Signal
disp('Playing Noisy Signal...');
sound(noisy_signal, fs);
pause(length(noisy_signal)/fs + 1);

%% Play FIR Output
disp('Playing FIR Filter Output...');
sound(fir_output, fs);
pause(length(fir_output)/fs + 1);

%% Play IIR Output
disp('Playing IIR Filter Output...');
sound(iir_output, fs);
