clc;clear; close all;

fc_05 = 0.05;
fc_2 = 0.2;
fc_4 = 0.4;

%% Low pass filter 
    %Frequency band edges
f = [0, fc_4, fc_4, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
n = 100;
fir = fir2(n,f,m);
 
%fir_temp = firls(n,f,m);
%fvtool(fir,1,fir_temp,1);
%phasez(fir);
 
    %Better way of getting frequency response.
freqz(fir,1);   title('Filter frequency response Fc = 0.4');

%% Lena
load lena512.mat;

figure;
imshow(uint8(lena512));
title('Original Img');
 
lenarec=lena512(252:284,318:350);
 
figure;
imshow(uint8(lenarec));
title('Cutted Img');
 
b = de2bi(lenarec,8); %For Default it is the 'right-msb'
b = b'; %Transponse operation
bits_rx = b(:); %Concatena el resto de bits, para que sea un solo vector
 
lena_size = size(lenarec);
y = bits_rx(1:256);
 
mp = 10;
t = 0:0.1:1;
    %Use numel because it is less heavy operation
    %We follow the examples made in class
x = zeros(1,numel(t));
x(find((t>=0)&(t<0.5)))=1;
x(find((t>=0.5)&(t<1)))=-1;
s1 = y;
 
s1(s1==0) = -1;
 
s = zeros(1,numel(y)*mp);
s(1:mp:end) = s1;
x = conv(s,x);
figure;
pwelch(x);
 
    %Filer
%Low Pass filter fc = 0.4
LPF = conv(x,fir);
pwelch(LPF);