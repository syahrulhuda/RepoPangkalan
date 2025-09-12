clc
clear all
close all

A = 5;
f = 5;
Fs = 50;
t = 0:0.001:1;
ts = 0:(1/Fs):1;
phi = 0;

x = A*sin((2*pi*f*t)+phi);
xs = A*sin((2*pi*f*ts)+phi);

subplot(3,1,1), plot(t, x, 'r');
xlabel('Time (t)'); ylabel('Amplitude (A)');
title('ANALOG');
subplot(3,1,2), stem((0:Fs), xs, 'b');
xlabel('Sampling Points'); ylabel('Amplitude (A)');
title('SAMPLED');
subplot(3,1,3), plot(t, x, 'r'); hold on;
stem(ts, xs, 'b');
xlabel('Time (t)'); ylabel('Amplitude (A)');
title('COMBINED');
legend('Original Analog Signal', 'Sampled Points');