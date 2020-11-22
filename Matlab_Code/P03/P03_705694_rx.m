%% P03_705694
% cuidar la amplificacion del microfono

%% Rx side
clear all ; clc;
format longg

%Audio read from WAV file.
filename= 'lena_rx.wav';
INFO = audioinfo(filename)
nBits = INFO.BitsPerSample;
Fs_audio = INFO.SampleRate;
%samples = [1,sec*Fs_audio];
[Rx_signal,FsWav] = audioread(filename);
Rx_signal = normalize(Rx_signal, 'range', [-1 1]);

figure; plot(Rx_signal);
%%
threshold = 0.1; % Detecting the channel energization
start = find(abs(Rx_signal)> threshold,3,'first'); % Initial
stop = find(abs(Rx_signal)> threshold,1,'last'); % End
Rx_signal = Rx_signal (start:stop);

figure; plot(Rx_signal(1:500));
%% Creamos pulse base para match filter

Fs      =   96e3;              % Samples per second
Ts      =   1/Fs;              %  
beta    =   0.22;              % Roll-off factor
B       =   16e3;              % Bandwidth available
Rb      =   2*B/(1+beta);      % Bit rate = Baud rate
mp      =   ceil(Fs/Rb);       % samples per pulse
Rb      =   Fs/mp;             % Recompute bit rate
Tp      =   1/Rb;              % Symbol period
B       =   (Rb*(1+beta)/2);   % Bandwidth consumed
D       =   6;                 % Time duration in terms of Tp
type    =   'srrc';            % Shape pulse: Square Root Rise Cosine
E       =   Tp;                % Energy
[pbase ~] = rcpulse(beta, D, Tp, Ts, type, E);    % Pulse Generation
%% 
match_filter = conv(pbase,Rx_signal);

figure; pwelch(match_filter,500,300,500,'one-side','power',Fs);

figure; plot(match_filter(1:0.5e3));

norm_signal = normalize(Rx_signal, 'range', [-1 1]);

%% 
%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs,'SamplesPerSymbol',mp);
%Eye Pattern Received Signal
EP(norm_signal(:));

%% Sync
% Sampler:
symSync = comm.SymbolSynchronizer('TimingErrorDetector','Early-Late (non-data-aided)','SamplesPerSymbol', mp);
% El sincronizador utiliza la señal del Match Filter
% y también muestrea, dejando solamente los símbolos
rxSym = symSync(norm_signal);
release(symSync); % Liberar el objeto

%% Convert rxSym to bits

bits_rxSym = rxSym(:);

bits_rxSym(bits_rxSym < 0) = 0;
bits_rxSym(bits_rxSym > 0) = 1;
figure; plot(bits_rxSym(1:60));

%% Preambulo
preamble_bits = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1]';

preamble_detect = comm.PreambleDetector(preamble_bits,'Input','Bit');
% Deteccion de preámbulo. El índice indica dónde termina la trama
idx = preamble_detect(bits_rxSym(1:128)) % Ventana de 128 bits
% Una vez que encuentra el índice, se descartan los “bits basura”
% Una forma de hacerlo es la siguiente:
rxData= bits_rxSym(idx+1-numel(preamble_bits):end);

%% 
%preamble num elements
preamble_size = numel(preamble_bits);
header_size = 16;

header_bits = rxData(preamble_size+1:preamble_size+(2*header_size));

header_row = bi2de(header_bits(1:numel(header_bits)/2)','left-msb');
header_col = bi2de(header_bits(numel(header_bits)/2:end)','left-msb');

%% Payload
payload_size = header_row * header_col * 8;
bits_payload = rxData(preamble_size+(2*header_size)+1:end); 

%Recover img
bi2mat = vec2mat(bits_payload,8);
lena_bin2dec = bi2de(bi2mat,'left-msb');
new_mat = vec2mat(lena_bin2dec,header_row);
new_mat = new_mat';
figure; imshow(uint8(new_mat));