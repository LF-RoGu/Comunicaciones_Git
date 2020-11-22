%% P02_PIII_705694
% cuidar la amplificacion del microfono

%% Rx side
close all; clear all ; clc;
format longg

%% Pass-Band Modulation, AM-DSB- SC. 
Fcarrier = 10e3;    % Carrier Frequency 

%Audio read from WAV file.
filename= 'Lena_RX_AM_7200.wav';
INFO = audioinfo(filename)
nBits = INFO.BitsPerSample;
Fs = INFO.SampleRate;
%samples = [1,sec*Fs_audio];
[Rx_signal,FsWav] = audioread(filename);

figure; plot(Rx_signal(1:5e2));
%%
threshold = 0.1; % Detecting the channel energization
start = find(abs(Rx_signal)> threshold,3,'first'); % Initial
stop = find(abs(Rx_signal)> threshold,1,'last'); % End
Rx_signal = Rx_signal (start:stop);

figure; plot(Rx_signal(1:5e2));

%% PSD de Rx_signal
%pwelch(Rx_signal,500,300,500,Fs,'oneside','power');
SA = dsp.SpectrumAnalyzer('SampleRate',Fs, ... 
    'PlotAsTwoSidedSpectrum',false, ... 
    'YLimits',[-60 40]); 
SA(Rx_signal); release(SA)
%% Demod Rx_signal y PSD en banda base

B =7200; 
[num,den] = butter(10,(B)*2/Fs); % Lowpass filter (LPF) to recover Base Band signal 
Rx_signal_demod = amdemod(Rx_signal,Fcarrier,Fs,0,0,num,den); 

figure; plot(Rx_signal_demod(1:5e2));

SA = dsp.SpectrumAnalyzer('SampleRate',Fs, ... 
    'PlotAsTwoSidedSpectrum',false, ... 
    'YLimits',[-60 40]); 
SA(Rx_signal_demod); release(SA)

%% Creamos pulse base para match filter

Fs      =   96e3;              % Samples per second
Ts      =   1/Fs;              %  
beta    =   0.5;               % Roll-off factor
B       =   7200;              % Bandwidth available
Rb      =   2*B/(1+beta);      % Bit rate = Baud rate
mp      =   ceil(Fs/Rb);        % samples per pulse
Rb      =   Fs/mp;             % Recompute bit rate
Tp      =   1/Rb;              % Symbol period
B       =   (Rb*(1+beta)/2);    % Bandwidth consumed
D       =   6;                 % Time duration in terms of Tp
type    =   'srrc';            % Shape pulse: Square Root Rise Cosine
E       =   Tp;                % Energy
[pbase ~] = rcpulse(beta, D, Tp, Ts, type, E);    % Pulse Generation
%% 
Rx_signal_Match = conv(pbase,Rx_signal_demod); 
Rx_signal_Match = normalize(Rx_signal_Match, 'scale'); %Scale by its standard deviation.
Rx_signal_Match = -Rx_signal_Match;

figure; plot(Rx_signal_Match(1:5e2));

%% 
%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs,'SamplesPerSymbol',mp);
match_filter = Rx_signal_Match';
%Eye Pattern Received Signal
EP(Rx_signal_Match(:));

%% Diagrama de constelacion
M = 2; 
refC = qammod(0:M-1,M); 
constdiag = comm.ConstellationDiagram('ReferenceConstellation',refC, ... 
    'XLimits',[-2 2],'YLimits',[-2 2]); 
% Considering the plot(Rx_signal_Match(1:2000)) 
% The initial point with the max amplitud is around the sample 169 
% This number of sample includes the delay of the Match filter 
ns= 167; % Move the sample around the sample 169 and verify the RMS-EVM (less is better) 
rxSam = Rx_signal_Match(ns:mp:end); 
constdiag(rxSam(1:1e4)); % Constellation Diagram of the first 1e4 samples 

%% Recover Lena

sample_start = 37;

%% Intento 2
bit_train = zeros(1,numel(Rx_signal_Match));
bit_train(sample_start:mp:end) = 1;
%figure; plot(bit_train(1:100));

bits_rx = bit_train.*Rx_signal_Match';
figure; plot(bits_rx(1:500)); hold on; plot(Rx_signal_Match(1:500));

%% convert the rx signal into a bit vector
bits_rx = bits_rx(sample_start:mp:end);
bits_rx(bits_rx < 0.5) = 0;
bits_rx(bits_rx > 0.5) = 1;
bits_rx = bits_rx(1:end)';
figure; plot(bits_rx(1:48));

%% Preamble
preamble_bits = bits_rx(1:32);
%figure; plot(preamble_bits);

%% Header
header_bits = bits_rx(33:48);
% figure; plot(header_bits);

header_row = bits_rx(59:64);
% figure; plot(header_row);
header_row = bi2de(header_row', 'left-msb');


header_col = bits_rx(43:48);
%figure; plot(header_col);
header_col = bi2de(header_col', 'left-msb');
%%
bits_payload = bits_rx(65:end);

%Recover img
bi2mat = vec2mat(bits_payload,8);
lena_bin2dec = bi2de(bi2mat,'left-msb');
new_mat = vec2mat(lena_bin2dec,header_col);
new_mat = new_mat';
figure; imshow(uint8(new_mat));