%% P02_PI_705694
%% sine

Fs = 48e3;
Ts = 1/Fs;

amp = 1.0;
phase =  0;
Fs_sin = 5e3;
Ts_sin = 1/(8e3);
dt = Ts_sin;
    
t_s = 1.0; %time in seconds

t_sin = (0 : dt : t_s - dt)';

sine = amp*sin(2*pi*Fs_sin*t_sin + phase);

%figure(1); plot(t_sin,sine); xlabel ('t (segundos)'); title ('Señal'); grid on;

soundsc(sine);
%% impulse
imp = [zeros(1, Fs) 1 zeros(1, Fs)];

stem(imp);

soundsc(imp);
%% noise
noise = rand(1,5*Fs);

plot(noise);

soundsc(noise);
%% chirp
start_t = 0;
end_t = 5;
t = start_t : 1/Fs : end_t;

fo = 50; 
f1 = 20e3; 
chirp_data = chirp(t,fo,end_t,f1,'linear'); 
figure;
pwelch(chirp_data,500,300,500,'one-side','power',Fs);

soundsc(chirp_data);

%% reception of data

dataObj = getaudiodata(recorderObj);

%% reception of sine signal
figure; plot(dataObj); title('Rx Signal');

figure; plot(t_sin,sine); title ('Tx Signal');

figure; pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

figure; pwelch(sine,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of impulse signal
figure; plot(dataObj); title('Rx Signal');

figure; plot(imp); title ('Tx Signal');

figure; pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

figure; pwelch(imp,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of gaussian noise signal
figure; plot(dataObj); title('Rx Signal');

figure; plot(noise); title ('Tx Signal');

figure; pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

figure; pwelch(noise,500,300,500,'power'); title('Spectre / Tx Signal');

%% reception of chirp signal
figure; plot(dataObj); title('Rx Signal');

figure; plot(chirp_data); title ('Tx Signal');

figure; pwelch(dataObj,500,300,500,'power'); title('Spectre / Rx Signal');

pwelch(chirp_data,500,300,500,'one-side','power',Fs); title('Spectre / Tx Signal');