%% Assignment 1 - Es 1
clc
close all 
clear all

%% Upload "ES1_emg.mat"

D = load('es1_emg\ES1_emg.mat');
emg = D.Es1_emg.matrix; 

fs = 2000; % sampling frequency

%% Filter the raw EMG signal (band pass filter, 30-450 Hz). It's recommended to use an FIR filter. 
% To compensate for the phase delay, utilize the "filtfilt” function.

nyquist = fs / 2;
low = 30 / nyquist; % cutoff frequency low
high = 450 / nyquist; % cutoff frequency high
n = 100; % Filter order... non so se cambiarlo ma dovrebbe andar bene
b = fir1(n, [low, high], 'bandpass'); % Design the FIR filter
filtered_emg = filtfilt(b, 1, emg); % Apply the filter

%% Rectify the signal by taking the absolute value of the filtered EMG signal
rectified_emg = abs(filtered_emg);


%% Compute the envelope (low pass filter, 3-6 Hz)
lowpass = 6 / nyquist; % cutoff frequency
n = 100; % Filter order ... uguale a sopra
b = fir1(n, lowpass, 'low'); % Design the low-pass FIR filter
envelope = filtfilt(b, 1, rectified_emg); % Apply the filter to the rectified signal


%% Down-sample the signal

N = 10; % 1/10 of data ... "decimizziamo" i dati
downsampled_signal = downsample(envelope, N);
downsampled_accellerometer = downsample(emg(:,2:4), N);

%% Plot
figure(1)
plot(emg(:,1))
hold on
plot(filtered_emg(:,1))
title('Raw EMG signal overlaid with the filtered signa')
legend('Raw Emg', 'Rectified EMG')

figure(2)
plot(rectified_emg(:,1))
hold on
plot(envelope(:,1))
title('Rectified EMG signal overlaid with the envelope')
legend('Rectified EMG', 'Envelope EMG')

% figure(3)
% plot(100*emg(:,2:4)) % amplify movement of a 100 factor to see better in the graph
% hold on
% plot(envelope(:,1))
% title('Movement signal overlaid with the envelope signal')
% legend('Accellerometer - x','Accellerometer - y','Accellerometer - z', 'Envelope EMG')
%
% or
%
figure(3)
plot(100*downsampled_accellerometer(:,1:3)) % amplify movement of a 100 factor only to see better in the graph
hold on                                     % non so se va bene fare sta mossa
plot(downsampled_signal(:,1))
title('Movement signal overlaid with the envelope signal')
legend('Accellerometer - x','Accellerometer - y','Accellerometer - z', 'Envelope EMG')

% Plot extra
% figure
% title('emg - filtered')
% subplot(3,1,1)
% plot(emg(:,1))
% subplot(3,1,2)
% plot(rectified_emg(:,1))
% subplot(3,1,3)
% plot(downsampled_signal(:,1))

% figure Non ha senso filtrare l accellerometro
% title('accellerometer x-y-z filtered')
% subplot(3,1,1)
% plot(downsampled_signal(:,2))
% subplot(3,1,2)
% plot(downsampled_signal(:,3))
% subplot(3,1,3)
%plot(downsampled_signal(:,4))

% figure
% title('accellerometer x-y-z not-filtered')
% subplot(3,1,1)
% plot(emg(:,2))
% subplot(3,1,2)
% plot(emg(:,3))
% subplot(3,1,3)
% plot(emg(:,4))

%% Question

% Question A: Why is the down-sampling performed after the envelope computation?
% 
% Down-sampling is performed after envelope computation to reduce 
% the data size and computational complexity. Enveloping the EMG signal results 
% in a lower-frequency signal compared to the raw EMG, which can be down-sampled 
% without losing significant information. This reduces the amount of data that 
% needs to be processed, making it more efficient for further analysis.

% Question B: Based on the motion signal, when does the muscle activation 
% commence in relation to the movement?
%
% To determine when muscle activation start in relation to the
% movement, we can analize the envelope signal. Muscle activation typically
% begins when the envelope signal rises above a certain threshold. We can 
% define a threshold value based on our data and the. Once we ve set a
% threshold, we can detect the time points when the envelope signal crosses it 
% to determine the set of muscle activation in relation to the movement