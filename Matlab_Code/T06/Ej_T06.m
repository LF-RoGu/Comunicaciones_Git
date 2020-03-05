%% Lena to bits
clc; clear; close all;

load lena512.mat;

lenarec=lena512(252:284,318:350);

b = de2bi(lenarec,8); %For Default it is the 'right-msb'
b = b'; %Transponse operation
bits_tx = b(:); %Concatena el resto de bits, para que sea un solo vector

temp = bits_tx; % 8 bits

% LPF Fc = 0.1594
    %Fc
Fc = 0.1594;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = 100;
fir = fir2(order,f,m);

% Manchester Signal NRZ
%Cambiar metodo para revisar, mejor opcion es revisar la pendiente, tomas
%muestra en mp/4 y 3*mp/4 para obtener pendiente. Dependiendo del valor de
%la pendiente, este sera un 1 o un 0

mp = 10;
Fs = 96000;

Ts = 1/Fs;

mb2 = round(mp/2);

n = 0:mb2-1; w0 = pi/mb2;

half_sine = sin(w0*n);

%Manchester encoding data type B
MBP = [half_sine, -half_sine]; %MBP (Manchester Base Pulse)

MS_s = temp;

MS_s( MS_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(MS_s)*mp);

s(1:mp:end) = MS_s;

MLC = conv(s, MBP); %MLC (Manchester Line Code)

%figure; stem(MLC(1:mp*10));

MRS_rx = conv(fir,MLC); %MRS_rx (Manchester Received Signal)
figure; pwelch(MRS_rx,500,300,500,Fs,'power'); title('Manchester Fc 0.094');
figure; plot(MLC(1:mp*20)); hold on; plot(MRS_rx(1:mp*20));

% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_MRS = MRS_rx( ( round(3*mp/4) + (order/2) ) : mp : (end - (order/2) - round(3*mp/4)) );
figure; scatterplot(rx_MRS);

bits_rx = zeros(1,numel(rx_MRS));
%extra data fix
%bits_rx = bits_rx(1 : end-1);

% Define a value that if it is above that value it is a 1 or below a 0
bits_rx( find( (rx_MRS > 0) ) ) = 0;
bits_rx( find( (rx_MRS < 0) ) ) = 1;
% Changes contrast
%bits_rx( find( (rx_MRS > 0) ) ) = 0;
%bits_rx( find( (rx_MRS < 0) ) ) = 1;

bits_rx = bits_rx';

%checksum if the recovered data it is correct
% CheckSum
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