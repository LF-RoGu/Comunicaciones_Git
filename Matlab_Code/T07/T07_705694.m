clc; clear; close all;
%% Lena to bits
load lena512.mat;

lenarec=lena512(252:284,318:350);

b = de2bi(lenarec,8); %For Default it is the 'right-msb'
b = b'; %Transponse operation
bits_tx = b(:); %Concatena el resto de bits, para que sea un solo vector

temp = bits_tx; % 8 bits
% LPF Comunication Channel
    %Fc
Fc = 0.394;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = 100;
fir = fir2(order,f,m);

%% Polar Signal NRZ
mp = 10;
Fs = 96000;

Ts = 1/Fs;

% Base Pulse Starts
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
PBP = ones(1,mp); % PSPB (Polar Base Pulse)

mb2 = round(mp/2);
n = 0:mb2-1; w0 = pi/mb2;
PBPHS = sin(w0*n);  % PBPHS (Polar Base Pulse Half Sine)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Base Pulse Ends
PS_s = temp;

PS_s( PS_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(PS_s)*mp);

s(1:mp:end) = PS_s;

PSLC = conv(s, PBP); %PSLC (Polar Signal Line Code)
%PSLC = conv(s, PBPHS); %PSLC (Polar Signal Line Code)

%figure; stem(PSLC(1:mp*10));

PRS_rx = conv(fir,PSLC); %PSRS (Polar Received Signal)
%figure; pwelch(PRS_rx,500,300,500,Fs,'power'); title('Polar Fc 0.094');
%figure; plot(PSLC(1:mp*20)); hold on; plot(PRS_rx(1:mp*20));

%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs*mp,'SamplesPerSymbol',mp);
%Eye Pattern Received Signal
EP(PRS_rx');

% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_PRS = PRS_rx( ( mp/2 + (order/2) ) : mp : (end - (order/2) - (mp/2)) );
%figure; scatterplot(rx_PRS);

bits_rx = zeros(1,numel(rx_PRS));
% Define a value that if it is above that value it is a 1 or below a 0
bits_rx( find( (rx_PRS > 0) ) ) = 1;
bits_rx( find( (rx_PRS < 0) ) ) = 0;

bits_rx = bits_rx';

%checksum if the recovered data it is correct
error = (sum( xor(bits_tx,bits_rx) ) / numel(bits_rx))*100;

if (error == 0)
    disp('No ERROR')
else
    disp('ERROR FOUND')
end
%% RCPULSE

%% Exercise 1
Fs = 8000;
B = 1000;
Rb = 2000; Rs = Rb;
D = 10;
beta = (( 2*B ) / ( Rb )) - 1;
%beta = 0.2;
Tp = 1/Rb;
Ts = 1/Fs;
energy = 1;
mp = Fs / Rb;
%mp = Tp/Ts;

[BP,t] = rcpulse(beta, D, Tp, Ts, 'rc', energy);

%% Exercise 2
Fs = 8000;
B = 1000;
beta = 0.2;
D = 10;
Rb = ( 2*B ) / ( 1 + beta );
Rb = 1600;
Tp = 1/Rb;
Ts = 1/Fs;
%mp = Fs / Rb;
mp = Tp/Ts;
energy = 1;

[BP,t] = rcpulse(beta, D, Tp, Ts, 'rc', energy);

%% Exercise 3
Fs = 4000;
B = 1000;
beta = 0.8;
D = 10;
Rb = 2000;
Tp = 1/Rb;
Ts = 1/Fs;
mp = Fs / Rb;
%mp = Tp/Ts;

B = (( 1 + beta ) * Rb) / 2;

[BP,t] = rcpulse(beta, D, Tp, Ts, 'rc', energy);

%% Exercise 5

beta = 0;
Fs = 1000;
Tp = 1/100;
Ts = 1/Fs;
D = 10;
mp = Tp/Ts;
energy = 1;

[BPRC,t] = rcpulse(beta, D, Tp, Ts, 'rc', Tp); %BPRC (Base Pulse Rised Cosine)

bits_seq = [1 0 1 1 0 0 1 1 1 1 1];

%PS_s = bits_seq;
PS_s = temp;

PS_s( PS_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(PS_s)*mp);

s(1:mp:end) = PS_s;

PSLC = conv(s, BPRC); %PSLC (Polar Signal Line Code)

PRS_rx = conv(fir,PSLC); %PSRS (Polar Received Signal)

%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs*mp,'SamplesPerSymbol',mp);

PRS_rx = PRS_rx';

%Eye Pattern Received Signal
EP(PRS_rx);

%Para calcular potencia, calcularmos la media, si la media es 0 o cercana,
%la varianza sera su potencia
mean(PRS_rx);

var(PRS_rx);

% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_PRS = PRS_rx( ( (D*mp)/2 + (order/2) + 1 ) : mp : end - ( (D*mp)/2 + (order/2) + 1 ));
%figure; scatterplot(rx_PRS);

rx_PRS = rx_PRS(1:numel(bits_tx));

bits_rx = zeros(1,numel(rx_PRS));

% Define a value that if it is above that value it is a 1 or below a 0
bits_rx( find( (rx_PRS > 0) ) ) = 1;
bits_rx( find( (rx_PRS < 0) ) ) = 0;

bits_rx = bits_rx';

%checksum if the recovered data it is correct
error = (sum( xor(bits_tx,bits_rx) ) / numel(bits_rx))*100;

if (error == 0)
    disp('No ERROR')
else
    disp('ERROR FOUND')
end
%Convert vector to mat
mat = vec2mat(bits_rx,8);
%Convert mat to dec
lena_bin2dec = bi2de(mat);
new_mat = vec2mat(lena_bin2dec,33);
new_mat = new_mat';
figure; imshow(uint8(new_mat));