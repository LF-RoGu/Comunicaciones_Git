%% P02_PII_705694
% cuidar la amplificacion del microfono

%% Rx side
%close all; clear all ; clc;
format longg

%Audio read from WAV file.
filename= 'Lena_RX_7200_ver2.wav';
INFO = audioinfo(filename)
nBits = INFO.BitsPerSample;
Fs_audio = INFO.SampleRate;
%samples = [1,sec*Fs_audio];
[Rx_signal,FsWav] = audioread(filename);
%%
threshold = 0.1; % Detecting the channel energization
start = find(abs(Rx_signal)> threshold,3,'first'); % Initial
stop = find(abs(Rx_signal)> threshold,1,'last'); % End
Rx_signal = Rx_signal (start:stop);

%Rx_signal = Rx_signal*5;

figure; plot(Rx_signal(1:1e2));

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
match_filter = conv(pbase,Rx_signal);

figure; pwelch(match_filter,500,300,500,'one-side','power',Fs);

%% 
%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs,'SamplesPerSymbol',3*mp);
match_filter = match_filter';
%Eye Pattern Received Signal
EP(match_filter(:));

%% Recover Lena

sample_start = 36;

%% Intento 1
%bits_rx
bits_rx = match_filter(sample_start:mp:end);

bits_rx(bits_rx < 0) = 0;
bits_rx(bits_rx > 0) = 1;
figure; plot(bits_rx(1:50));

%Preamble
preamble_bits = bits_rx(sample_start:mp:mp*31);
figure; plot(preamble_bits);

%Header
header_bits = bits_rx(sample_start+mp*32:mp:mp*(32+31) + sample_start);
figure; plot(header_bits);

header_row = header_bits(1:8);
header_row = bi2de(header_row', 'left-msb');

header_col = header_bits(9:17);
header_col = bi2de(header_col', 'left-msb');

%% Intento 2
bit_train = zeros(1,numel(match_filter));
bit_train(sample_start:mp:end) = 1;
%figure; plot(bit_train(1:100));

bits_rx = bit_train.*match_filter';
%figure; plot(bits_rx(1:300)); hold on; plot(match_filter(1:300));

% convert the rx signal into a bit vector
bits_rx = bits_rx(sample_start:mp:end);
bits_rx(bits_rx < 0) = 0;
bits_rx(bits_rx > 0) = 1;
bits_rx = bits_rx(1:end)';
%figure; plot(bits_rx(1:60));

% Preamble
preamble_bits = bits_rx(1:32);
%figure; plot(preamble_bits);

%Header
header_bits = bits_rx(33:48);
%figure; plot(header_bits);

header_row = header_bits(1:8);
%figure; plot(header_row);
header_row = bi2de(header_row', 'left-msb');


header_col = header_bits(9:end);
%figure; plot(header_col);
header_col = bi2de(header_col', 'left-msb');

bits_payload = bits_rx(49:end);

%Recover img
bi2mat = vec2mat(bits_payload,8);
lena_bin2dec = bi2de(bi2mat,'left-msb');
new_mat = vec2mat(lena_bin2dec,header_row);
new_mat = new_mat';
figure; imshow(uint8(new_mat));