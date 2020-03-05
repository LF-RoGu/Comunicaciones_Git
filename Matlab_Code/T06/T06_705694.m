clc; clear; close all;
%% Lena to bits
load lena512.mat;

lenarec=lena512(252:284,318:350);

b = de2bi(lenarec,8); %For Default it is the 'right-msb'
b = b'; %Transponse operation
bits_tx = b(:); %Concatena el resto de bits, para que sea un solo vector

temp = bits_tx; % 8 bits
%% LPF Fc = 0.394
    %Fc
Fc = 0.394;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = 100;
fir = fir2(order,f,m);
%% LPF Fc = 0.1594
    %Fc
Fc = 0.1594;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = 100;
fir = fir2(order,f,m);
%% LPF Fc = 0.094
    %Fc
Fc = 0.094;
    %Frequency band edges
f = [0, Fc, Fc, 1];
    %Amplitudes
m = [1, 1, 0, 0];
    %Filter order
order = 100;
fir = fir2(order,f,m);
%% Uni-Polar signal NRZ
mp = 10;
Fs = 96000;

Ts = 1/Fs;

UPBP = ones(1,mp); % UPPB (Uni-Polar Base Pulse)

UP_s = zeros(1,numel(temp)*mp);

UP_s(1:mp:end) = temp; % Impulse Train

UPLC = conv(UPBP,UP_s); %UPLC (Uni-Polar Line Code)
   
%figure; stem(UPLC(1:mp*20));

UPRS_rx = conv(fir,UPLC); %UPRS (Uni-Polar Received Signal)
figure; pwelch(UPRS_rx,500,300,500,Fs,'power'); title('Uni Polar Fc 0.094');
figure; plot(UPLC(1:mp*20)); hold on; plot(UPRS_rx(1:mp*20));

% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_UPRS = UPRS_rx( ( mp/2 + (order/2) ) : mp : (end - (order/2) - (mp/2)) );
figure; scatterplot(rx_UPRS);

bits_rx = zeros(1,numel(rx_UPRS));
% Define a value that if it is above that value it is a 1 or below a 0
bits_rx( find( (rx_UPRS > 0.5) ) ) = 1;
bits_rx( find( (rx_UPRS < 0.5) ) ) = 0;

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

%% Polar Signal NRZ
mp = 10;
Fs = 96000;

Ts = 1/Fs;

PBP = ones(1,mp); % PSPB (Polar Base Pulse)

PS_s = temp;

PS_s( PS_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(PS_s)*mp);

s(1:mp:end) = PS_s;

PSLC = conv(s, PBP); %PSLC (Polar Signal Line Code)

%figure; stem(PSLC(1:mp*10));

PRS_rx = conv(fir,PSLC); %PSRS (Polar Received Signal)
figure; pwelch(PRS_rx,500,300,500,Fs,'power'); title('Polar Fc 0.094');
figure; plot(PSLC(1:mp*20)); hold on; plot(PRS_rx(1:mp*20));

% Tenemos order/2 + y - por el retardo del orden del filtro
% Take a sample each mp/2 in time domain to recover the data
rx_PRS = PRS_rx( ( mp/2 + (order/2) ) : mp : (end - (order/2) - (mp/2)) );
figure; scatterplot(rx_PRS);

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

%% Manchester Signal NRZ
%Cambiar metodo para revisar, mejor opcion es revisar la pendiente, tomas
%muestra en mp/4 y 3*mp/4 para obtener pendiente. Dependiendo del valor de
%la pendiente, este sera un 1 o un 0

mp = 10;
Fs = 96000;

Ts = 1/Fs;

%Manchester encoding data type B
MBP = [ones(1,mp/2) -ones(1,mp/2)]; %MBP (Manchester Base Pulse)

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
rx_MRS = MRS_rx( ( 3*mp/4 + (order/2) ) : mp : (end - (order/2) - (3*mp/4)) );
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
%% Bipolar Signal RZ

mp = 10;
Fs = 96000;

Ts = 1/Fs;

BPBP = [ones(1,mp/2) -ones(1,mp/2)]; %BPBP (Bi-Polar Base Pulse)

BP_s = temp;

BP_s( BP_s == 0 ) = -1; % Convert “0” to “-1”

s = zeros(1,numel(BP_s)*mp);

s(1:mp:end) = BP_s;

flag = 0;
for i = 1; numel(s)
    if( s(i) == 1 )
        flag = ~flag;
    else
        flag = flag;
    end
    if ( flag && s(i) == 1 )
        s(i) = s(i) * -1;
    end
        
end

BPLC = conv(s, BPBP); %BPLC (Bi-Polar Line Code)

%figure; stem(BPLC(1:mp*10));

BPRS_rx = conv(fir,BPLC); %MRS_rx (Bi-Polar Received Signal)
figure; pwelch(BPRS_rx,500,300,500,Fs,'power'); title('Bi-Polar Fc 0.094');
figure; plot(BPLC(1:mp*20)); hold on; plot(BPRS_rx(1:mp*20));

% Take a sample each mp/2 in time domain to recover the data
rx_BPRS = BPRS_rx( ( 3*mp/4 + (order/2) ) : mp : (end - (order/2) - (3*mp/4)) );
figure; scatterplot(rx_BPRS);

bits_rx = zeros(1,numel(rx_BPRS));

% Define a value that if it is above that value it is a 1 or below a 0
bits_rx( find( (rx_BPRS > 0) ) ) = 0;
bits_rx( find( (rx_BPRS < 0) ) ) = 1;

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

%% Ej 3. El valor maximo de la correlacion de un pulso consigo mismo es igual a la energia del pulso

pulso = triang(100); % pulso triangular de 100 muestras
Ep = sum(pulso.*pulso); % energía del pulso
E1 = max(conv(pulso,fliplr(pulso))); % máximo de la convolución
E2 = conv(pulso,fliplr(pulso));
E2(100); % elemento 100 de la convolución

if( (Ep == E1) & (E1 == E2(100)) )
    disp('Max Value Conv is EQUAL to Pulse Energy');
else
    disp('Max Value Conv is NOT equal to Pulse Energy');
end

%% Ej 4.
L = 100;
%Triangular
triang_pulse = triang(L);
    %Para normalizar la ENERGIA se calcula la energia de la senal, una vez calculada
    %esta se divide la senal normalizada entre la raiz de la energia.
    % Divide entre la raiz cuadrada de la ENERGIA DESEADA

Ep = sum(triang_pulse.*triang_pulse) / 33.33;

%Sine
t = 0:1:L;

half_sine_pulse = sin(pi*t / (L / 6));
half_sine_pulse(t > (L / 6)) = 0;
half_sine_pulse = half_sine_pulse';

E1_sin = max(conv(half_sine_pulse,fliplr(half_sine_pulse)));

%Rectangular
rect_pulse = ones(1,L);
rect_pulse = rect_pulse';

E1_rect = max(conv(rect_pulse,fliplr(rect_pulse)));

%Manchester
    %Manchester encoding data type B
Manchester_pulse = [ones(1,L/2) -ones(1,L/2)];
Manchester_pulse = Manchester_pulse';

E1_manch = max(conv(Manchester_pulse,fliplr(Manchester_pulse)));

Gauss_pulse = gausswin(L);
E1_gauss = max(conv(Gauss_pulse,fliplr(Gauss_pulse)));
Cheby_pulse = chebwin(L);
E1_cheby = max(conv(Cheby_pulse,fliplr(Cheby_pulse)));
Kaiser_pulse = kaiser(L);
E1_kaiser = max(conv(Kaiser_pulse,fliplr(Kaiser_pulse)));
Tukey_pulse = tukeywin(L);
E1_turkey = max(conv(Tukey_pulse,fliplr(Tukey_pulse)));