%% P03_705694_tx

preamble_bits = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1]'; 
load lena512.mat 
img = uint8(lena512);

%imshow(img); 

size_img = de2bi(size(img),16,'left-msb');
header_bits= [size_img(1,:) size_img(2,:)]';

payload_bits = de2bi(img,8,'left-msb'); %usar esta de preferencia
payload_bits = payload_bits';
payload_bits = payload_bits(:); 
bits2Tx = [preamble_bits; header_bits; payload_bits]; 


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

wvtool(pbase)
%% POLAR Base Pulse
PBP = pbase;
    %We do a casting because we had problems identifying the ceros
PS_s = double(bits2Tx);

PS_s( PS_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(PS_s)*mp);

s(1:mp:end) = PS_s;

PSLC_Tx = conv(PBP, s); %PSLC (Polar Signal Line Code Tx)

    %sec2Tx
    sec2Tx = numel(bits2Tx)/Rb
    
%% Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs*mp,'SamplesPerSymbol',mp);

%Eye Pattern Received Signal
EP(PSLC_Tx');
%%
audio_file = normalize(PSLC_Tx, 'range', [-1 1]);

audio_file = [zeros(1,Fs/2) audio_file];

audiowrite('lena_tx.wav', audio_file, Fs);

%%
soundsc( [zeros(1,Fs/2) audio_file] )