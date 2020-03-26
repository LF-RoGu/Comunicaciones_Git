clear all; clc; close all;

%%Exercise 1
beta = 0.25;
Fs = 8000;
D = 10;
Rb = 1000; %bps
Tp = 1/Rb;
Ts = 1/Fs;
energy = 0.1;
B = ( Rb * ( 1 + beta ) ) / 2;
mp = Fs / Rb;

[p,t] = rcpulse(beta, D, Tp, Ts, 'srrc', energy);

p_energy = Ts*sum(p.*p); % energy = 1mJ

%p = p*sqrt(0.1); % pulso por energia deseada

%% Exercise 2
% LPF Comunication Channel
    %Fc
Fc = (B*2)/Fs;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = mp*D;

%LowPass filter
fir = fir2(order,f,m);
LPF_energy = Ts*sum(fir.*fir);
fir = ( fir/sqrt(LPF_energy) ) * sqrt(0.1);

%Rectangular filter
r_fir = [zeros(1,33),ones(1,15),zeros(1,33)];
r_fir_energy = Ts*sum(r_fir.*r_fir);
r_fir = ( r_fir/sqrt(r_fir_energy) )*sqrt(0.1);

%Half Sine filter
L = 81;
t = linspace(0,pi,L);
hs_fir = sin(t);
hs_fir_energy = Ts*sum(hs_fir.*hs_fir);
hs_fir = ( hs_fir/sqrt(hs_fir_energy) )*sqrt(0.1);

%Coupled filter
c_fir = p;

%% Exercise 3
clc;
fir_sel = 1;
h = [c_fir, fir, r_fir, hs_fir];
No_2 = 0.1;
%N = No_2*Ts*sum(h(fir_sel).*h(fir_sel))
N_c = No_2*Ts*sum(c_fir.*c_fir)
N_lp = No_2*Ts*sum(fir.*fir)
N_r = No_2*Ts*sum(r_fir.*r_fir)
N_hs = No_2*Ts*sum(hs_fir.*hs_fir)

%% Exercise 4
clc;
yt_cfir = Ts*conv(p,c_fir);
yt_cfir_max = max(yt_cfir)

yt_fir = Ts*conv(p,fir);
yt_fir_max = max(yt_fir)

yt_rfir = Ts*conv(p,r_fir);
yt_rfir_max = max(yt_rfir)

yt_hsfir = Ts*conv(p,hs_fir);
yt_hsfir_max = max(yt_hsfir)

%% Exercise 5
clc;

No_2 = 0.01;

%h = [c_fir, fir, r_fir, hs_fir];

%y_max = [yt_cfir_max, yt_rf_max, yt_hsfir_max, yt_fir_max];

SNR_c = (yt_cfir_max^2)/N_c
SNR_lp = (yt_fir_max^2)/N_c
SNR_r = (yt_rfir_max^2)/N_c
SNR_hs = (yt_hsfir_max^2)/N_c

%dB

SNR_c = 10*log10(SNR_c);
SNR_lp = 10*log10(SNR_lp);
SNR_r = 10*log10(SNR_r);
SNR_hs = 10*log10(SNR_hs);

%% Exercise 6
clc;

noise_c = sqrt(N_c)*rand(1,1e6);
noise_lp = sqrt(N_lp)*rand(1,1e6);
noise_r = sqrt(N_r)*rand(1,1e6);
noise_hs = sqrt(N_hs)*rand(1,1e6);

error_c = ( abs( noise_c ) >  yt_cfir_max);
error_lp = ( abs( noise_lp ) >  yt_fir_max);
error_r = ( abs( noise_r ) >  yt_rfir_max);
error_hs = ( abs( noise_hs ) >  yt_hsfir_max);

BER_c = ( sum( error_c ) / 2 ) / 1e6
BER_lp = ( sum( error_lp ) / 2 ) / 1e6
BER_r = ( sum( error_r ) / 2 ) / 1e6
BER_hs = ( sum( error_hs ) / 2 ) / 1e6

%% Exercise 7

clc; close all;

% Coupled
figure;
semilogx( SNR_c, BER_c);
title('Coupled');xlabel('SNR');ylabel('BER');

% Low Pass 
figure;
semilogx( SNR_lp, BER_lp);
title('Low Pass');xlabel('SNR');ylabel('BER');

% Rectangular
figure;
semilogx( SNR_r, BER_r);
title('Rectangular');xlabel('SNR');ylabel('BER');

% Half Sin
figure;
semilogx( SNR_hs, BER_hs);
title('Half Sin');xlabel('SNR');ylabel('BER');

%% Exercise 9
close all; clc;

load lena512.mat;

Fs_p = 8000;
Rb_p = 1000;
beta_p = 0.25;
D_p = 10;
energy_p = 0.1;
Ts_p = 1/Fs_p;
Tp_p = 1/Rb_p;

mp_p = Fs_p / Rb_p;

[x,t_p] = rcpulse(beta_p,D_p,Tp_p,Ts_p,'srrc',energy_p);

lenarec = lena512(252:284,318:350);

b = de2bi(lenarec,8); %For Default it is the 'right-msb'
b = b'; %Transponse operation
bits_tx = b(:); %Concatena el resto de bits, para que sea un solo vector
temp = bits_tx; % 8 bits

PBP = ones(1,mp); % PSPB (Polar Base Pulse)
PS_s = temp;
PS_s( PS_s == 0 ) = -1; % Convert “0” to “-1”
s = zeros(1,numel(PS_s)*mp);
s(1:mp:end) = PS_s;
PSLC = conv(s, PBP); %PSLC (Polar Signal Line Code)

PRS_rx = conv(x,PSLC); %PSRS (Polar Received Signal)

figure; pwelch(PRS_rx,500,300,500,Fs,'power'); title('Polar Fc 0.094');
figure; plot(PRS_rx(40:16*mp+40)); hold on;
stem_rx = [zeros(1,mp/2) 10*s(1:16*mp)]; stem(stem_rx);
scatterplot(stem_rx);

%Eye Pattern
EP = comm.EyeDiagram('SampleRate',Fs*mp,'SamplesPerSymbol',mp);

PRS_rx = PRS_rx';

%Eye Pattern Received Signal
EP(PRS_rx);

%% Exercise 10
% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_PRS = PRS_rx( ( (D*mp)/2 + (order/2) + 1 ) : mp : end - ( (D*mp)/2 + (order/2) + 1 ));
%figure; scatterplot(rx_PRS);

rx_PRS = rx_PRS(1:numel(bits_tx) - 10);

bits_rx = zeros(1,numel(rx_PRS));
bits_tx = bits_tx(1:numel(bits_tx) - 10);

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




