clear all; clc; close all;
%%
clear all;
%Ejercicio 1

Fs_1 = 8000; Rb_1 = 1000; 
D_1 = 10; beta_1 = 0.25;
B_1 = (Rb_1 * (1 + beta_1))/2;
Tp_1 = 1/Rb_1;
Ts_1 = 1/Fs_1;
Type_1 = 'srrc';
energy_1 = 0.1; 
[p t] = rcpulse(beta_1, D_1, Tp_1, Ts_1, Type_1, energy_1); 

p_energy = Ts_1*sum(p.*p); % p_energy = energy_1 = 0.1 Joules

%%
%Ejercicio 2

%Coupled Filter
c_filter = p; %coupled filters must have same Impulse Response of the transmitted pulse.

%LPF
mp = Fs_1/Rb_1;
mp_total = mp*D_1; %Total de muestras por pulso
n = mp_total; %Filter order
B = B_1/(Fs_1/2); %Frecuencia de corte digital
wc = [0 B B 1]; %Wc = Bandwidth 
m = [1 1 0 0];
LPF_B = fir2(n, wc, m); %Wc = 625 
LPF_energy = sum(LPF_B.*LPF_B); %Energy already 0.1J so lines 31-34 wont be necessary
LPF_B = (LPF_B/sqrt(LPF_energy))*sqrt(0.1);
LPF_energy = sum(LPF_B.*LPF_B); %all filters must have same energy (0.1J) to compare them objectively

%Rectangular Filter
rect_filter = [zeros(1,30), ones(1, 23), zeros(1,30)];
RF_energy = sum(rect_filter.*rect_filter);
rect_filter = (rect_filter/sqrt(RF_energy))*sqrt(0.1);
RF_energy = sum(rect_filter.*rect_filter);

%Half sine Filter
t_hs=0:1:29;
sin_temp = sin(0.20922*t_hs); %No sé porque esa frecuencia :(
halfsin_filter = sin_temp(1:16);
halfsin_energy = sum(halfsin_filter.*halfsin_filter);
halfsin_filter = (halfsin_filter/sqrt(halfsin_energy))*sqrt(0.1);
halfsin_energy = sum(halfsin_filter.*halfsin_filter);

%figure; plot(t, p);
%figure; plot(t, LPF_B);

%wvtool(p);
%wvtool(LPF_B);
%wvtool(rect_filter);
%wvtool(halfsin_filter);

%%
%Ejercicio 3

h = rect_filter;
%h = LPF_B;
%h = rect_filter;
%h = halfsin_filter;

%N02 = [0.1 0.08 0.06 0.04 0.025 0.01];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
N02 = 0.1;

N = N02*sum(h.*h)*Ts_1

%%
%Ejercicio 4

y_CF = conv(p, c_filter);
y_CF_MAX = max(y_CF)*Ts_1;

y_LPF = conv(p, LPF_B);
y_LPF_MAX = max(y_LPF)*Ts_1;

y_RF = conv(p, rect_filter);
y_RF_MAX = max(y_RF)*Ts_1;

y_HSF = conv(p, halfsin_filter);
y_HSF_MAX = max(y_HSF)*Ts_1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

%%
%Ejercicio 5

yMax = y_CF_MAX;
%yMax = y_LPF_MAX;
%yMax = y_RF_MAX;
%yMax = y_HSF_MAX;

SNR = (yMax^2)/N;

%%
%Ejercicio 6
%Y = yMax;
noise = sqrt(N)*randn(1,1e6);
%hist(noise, 1000); %We make sure that PDF is gaussean 
error = (abs(noise) > yMax);
BER = (sum(error)/2)/1e6;

%%
%Ejercicio 7
semilogx(10*log10(SNR), 10*log10(BER));
title('filtro acoplado');
xlabel('SNR');
ylabel('BER');




%%
%Ejercicio 9

Fs_9 = 8000; Rb_9 = 1000; 
D_9 = 10; beta_9 = 0.25;
B_9 = (Rb_9 * (1 + beta_9))/2;
Tp_9 = 1/Rb_9;
Ts_9 = 1/Fs_9;
Type_9 = 'srrc';
energy_9 = 0.1; 
[p_9 t_9] = rcpulse(beta_9, D_9, Tp_9, Ts_9, Type_9, energy_9); 

mp = Fs_9/Rb_9;

load lena512.mat;
figure; imshow(uint8(lena512));
figure;
lenarec = lena512(252:284, 318:350);
imshow(uint8(lenarec));
bin = de2bi(lenarec,8, 'left-msb'); 
bin = bin';
bits = bin(:); %Vector de bits concatenado

%PNRZ
PNRZ_base = ones(1,mp); %base Polar NRZ
PNRZ_sig = bits;
PNRZ_sig(0 == PNRZ_sig) = -1; %Converting 0 to -1
s = zeros(1,numel(PNRZ_sig)*mp);%Creamos un vector s de bits*mp bits inicializado en 0
s(1:mp:end) = PNRZ_sig;

PNRZ_CL = conv(PNRZ_base,s); %NRZ

pulse_Rx = conv(PNRZ_CL, p_9);

%figure; pwelch(pulse_Rx,[],[],[],Fs_9,'power');
figure; plot(pulse_Rx(40:16*mp+40));
hold on;
lena_rx = [zeros(1,mp/2) 10*s(1:16*mp)];
stem(lena_rx);
rx(10*s(1:16*mp) == lena_rx) = lena_rx;

%rx(-10 == lena_rx) = -1;
