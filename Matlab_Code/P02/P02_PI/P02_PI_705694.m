%% P02_PI_705694

%close all; clc; clear;

Fs = 48e3;
Ts = 1/2*Fs;
n_bits = 16;
n_channels = 1;

recorderObj  = audiorecorder(Fs,n_bits,n_channels);

disp('Start Recording');
    % Recordblocking(recorderObj, length) records audio from an input device
    %such as a microphone connected to your system, for the number of seconds specified by length.
recordblocking(recorderObj ,20);
disp('Stop Recording');

play(recorderObj);

%% sine
amp = 1.0;
phase =  0;
Fs_sin = 5e3;
Ts_sin = 1/(8e3);
dt = Ts_sin;
    
t_s = 1.0; %time in seconds

t_sin = (0 : dt : t_s - dt)';

sine = amp*sin(2*pi*Fs_sin*t_sin + phase);

figure(1); plot(t_sin,sine); xlabel ('t (segundos)'); title ('Señal'); grid on;

%soundsc(sine);
%% impulse
imp = [zeros(1, Fs) 1 zeros(1, Fs)];

stem(imp);

%soundsc(imp);
%% noise
noise = rand(1,5*Fs);

plot(noise);

%soundsc(noise);
%% chirp
start_t = 0;
end_t = 5;
t = start_t : 1/Fs : end_t;

fo = 50; 
f1 = 20e3; 
chirp_data = chirp(t,fo,end_t,f1,'linear'); 
figure;
pwelch(chirp_data,500,300,500,'one-side','power',Fs);

%% reception of data

dataObj = getaudiodata(recorderObj);

%% reception of sine signal
subplot(4,1,1); plot(dataObj); title('Rx Signal');

subplot(4,1,2); plot(t_sin,sine); title ('Tx Signal');

subplot(4,1,3); pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

subplot(4,1,4); pwelch(sine,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of impulse signal
subplot(4,1,1); plot(dataObj); title('Rx Signal');

subplot(4,1,2); plot(imp); title ('Tx Signal');

subplot(4,1,3); pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

subplot(4,1,4); pwelch(imp,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of gaussian noise signal
subplot(4,1,1); plot(dataObj); title('Rx Signal');

subplot(4,1,2); plot(noise); title ('Tx Signal');

subplot(4,1,3); pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

subplot(4,1,4); pwelch(noise,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of chirp signal
subplot(4,1,1); plot(dataObj); title('Rx Signal');

subplot(4,1,2); plot(chirp_data); title ('Tx Signal');

subplot(4,1,3); pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

subplot(4,1,4); pwelch(chirp_data,500,300,500,'one-side','power',Fs); title('Spectre / Tx Signal');