%% Assignment 1 - Es 2
clc
close all 
clear all

%% Upload "ES2_emg.mat"

D = load('es2_emg/ES2_emg.mat');
signals = D.ES2_emg.signals;
time = D.ES2_emg.time;

figure()
plot(time,signals(:,1))