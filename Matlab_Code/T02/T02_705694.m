clear all;
%% 
% T02_705694
% Date: 04/02/2020;

%%Code Starts Here
%Audio Path
audio_path = 'spring.wav';
[data, Fs] = audioread(audio_path);
figure(1);
title('SPECTROGRAM');
%%
% Quantification
% With M = 2^(bits) we obtain the Quantification
bits = 14;
M = 2^bits;

% Interval between the quantification levels
levels = max(data) - min(data);
levels = levels / M;

% Create a Vector
step = levels;
% According to the PP of PCM
start = ( min(data) + (levels/2) );
stop = ( max(data) + (levels/2) );

PCM = ( start:step:stop );
% Create a Vector of pure zeros of length of data
xq_14bits = zeros(1,length(data));

% Send the data to xq
% For cycle to transmit the data to the vector xq
for i = 1: length(data)
    [temp, temp_Fs] = min( abs(data(i) - PCM ) );
    xq_14bits(i) = PCM(temp_Fs);
end

audiowrite('14b_spring.wav', xq_14bits, Fs, 'BitsPerSample',16);
[data_14bits, Fs] = audioread('14b_spring.wav');

% REPRODUCE THE SOUND AND ESPECTOGRAM
% Exercise 3
subplot(4,1,1);
spectrogram(data_14bits, 'yaxis');
title('14 bits');

%%
% Quantification
% With M = 2^(bits) we obtain the Quantification
bits = 10;
M = 2^bits;

% Interval between the quantification levels
levels = max(data) - min(data);
levels = levels / M;

% Create a Vector
step = levels;
% According to the PP of PCM
start = ( min(data) + (levels/2) );
stop = ( max(data) + (levels/2) );

PCM = ( start:step:stop );
% Create a Vector of pure zeros of length of data
xq_10bits = zeros(1,length(data));

% Send the data to xq
% For cycle to transmit the data to the vector xq
for i = 1: length(data)
    [temp, temp_Fs] = min( abs(data(i) - PCM ) );
    xq_10bits(i) = PCM(temp_Fs);
end

audiowrite('10b_spring.wav', xq_10bits, Fs, 'BitsPerSample',16);
[data_10bits, Fs] = audioread('10b_spring.wav');

% REPRODUCE THE SOUND AND ESPECTOGRAM
% Exercise 3
subplot(4,1,2);
spectrogram(data_10bits, 'yaxis');
title('10 bits');

%%
% Quantification
% With M = 2^(bits) we obtain the Quantification
bits = 8;
M = 2^bits;

% Interval between the quantification levels
levels = max(data) - min(data);
levels = levels / M;

% Create a Vector
step = levels;
% According to the PP of PCM
start = ( min(data) + (levels/2) );
stop = ( max(data) + (levels/2) );

PCM = ( start:step:stop );
% Create a Vector of pure zeros of length of data
xq_8bits = zeros(1,length(data));

% Send the data to xq
% For cycle to transmit the data to the vector xq
for i = 1: length(data)
    [temp, temp_Fs] = min( abs(data(i) - PCM ) );
    xq_8bits(i) = PCM(temp_Fs);
end

audiowrite('8b_spring.wav', xq_8bits, Fs, 'BitsPerSample',16);
[data_8bits, Fs] = audioread('8b_spring.wav');

% REPRODUCE THE SOUND AND ESPECTOGRAM
% Exercise 3
subplot(4,1,3);
spectrogram(data_8bits, 'yaxis');
title('8 bits');
%%
% Quantification
% With M = 2^(bits) we obtain the Quantification
bits = 4;
M = 2^bits;

% Interval between the quantification levels
levels = max(data) - min(data);
levels = levels / M;

% Create a Vector
step = levels;
% According to the PP of PCM
start = ( min(data) + (levels/2) );
stop = ( max(data) + (levels/2) );

PCM = ( start:step:stop );
% Create a Vector of pure zeros of length of data
xq_4bits = zeros(1,length(data));

% Send the data to xq
% For cycle to transmit the data to the vector xq
for i = 1: length(data)
    [temp, temp_Fs] = min( abs(data(i) - PCM ) );
    xq_4bits(i) = PCM(temp_Fs);
end

audiowrite('4b_spring.wav', xq_4bits, Fs, 'BitsPerSample',16);
[data_4bits, Fs] = audioread('4b_spring.wav');

% REPRODUCE THE SOUND AND ESPECTOGRAM
% Exercise 3
subplot(4,1,4);
spectrogram(data_4bits, 'yaxis');
title('4 bits');

%%
% For this exercise it would be better to use the fir2 function
% But for simplicity we use the lowpass filter function

%Exercise 4
fc_8k = 8000;
fc_4k = 4000;
fc_1k = 1000;

figure(2);

lowpass_8k = lowpass(data,fc_8k,Fs);
audiowrite('lowpass_filter_8k.wav',lowpass_8k,Fs,'BitsPerSample',16);

lowpass_4k = lowpass(data,fc_4k,Fs);
audiowrite('lowpass_filter_4k.wav',lowpass_4k,Fs,'BitsPerSample',16);

lowpass_1k = lowpass(data,fc_1k,Fs);
audiowrite('lowpass_filter_1k.wav',lowpass_1k,Fs,'BitsPerSample',16);

[lp_8k,Fs] = audioread('lowpass_filter_8k.wav');
subplot(3,1,1);
spectrogram(lp_8k, 'yaxis');
title('8k Hz');


[lp_4k,Fs] = audioread('lowpass_filter_4k.wav');
subplot(3,1,2);
spectrogram(lp_4k, 'yaxis');
title('4k Hz');

[lp_1k,Fs] = audioread('lowpass_filter_1k.wav');
subplot(3,1,3);
spectrogram(lp_1k, 'yaxis');
title('1k Hz');

%%
% Part of the code to play the audio

% Original Sound
sound(data, Fs);

% 14bits
sound(xq_14bits, Fs);
% 10bits
sound(xq_10bits, Fs);
% 8bits
sound(xq_8bits, Fs);
% 4bits
sound(xq_4bits, Fs);

% Filter Audio

% 8k
sound(lp_8k, Fs);
% 4k
sound(lp_4k, Fs);
% 1k
sound(lp_1k, Fs);