%sesion online 2
%ejecucion de la practica 
filename= 'organfinale.wav';
Fs_audio = 44100;
sec = 10;
samples = [1,sec*Fs_audio];
[x,Fs] = audioread(filename,samples);   %obtencion del archivo wav 
info = audioinfo(filename);

%pasar a señal mono 
xMono = (x(:,1)+ x(:,2))/2;

%filtrar la señal 
%LPF 15 kHz
fc = 15000 / (Fs_audio/2);
B = 15e3;
fc_15KHz = [0 fc fc 1];
m = [1 1 0 0];
orden = 100;
LPF_15KHz = fir2(orden, fc_15KHz, m);
fvtool(LPF_15KHz, 'Analysis', 'impulse');
xa = filter(LPF_15KHz, 1, xMono); %señal analogica filtrada
%mean(xa) componente de directa
%min(xa)
%max(xa) %entre -1 y 1 v
%pwelch(xa)

%normalizacion de la potencia 
%calcular la potencia
pot = sum(xa.*xa)/numel(xa);
xa = xa/sqrt(pot);
P_signal = var(xa); %verificar la potencia 

%SNR
B =15e3 ; % Ancho de Banda del filtro receptor
N0 = 1./(B.*10.^(0:0.3:3)); % Vector PSD del ruido
P_noise = B*N0; % Vector de Pot del Ruido Filtrado
P_noise_dB = 10.*log10(P_noise); % Pot. Ruido en Decibeles
SNR_A = P_signal ./ P_noise; % Relacion Señal a Ruido
SNR_A_dB = 10*log10(SNR_A); % SNR en dB

%ruido AWGN 
%for i=1:length(N0)
noise = sqrt(P_noise(11)) * randn(size(xa)); %Muestras de ruido
%end 

%sumatoria del ruido con la señal original 
xa_noised = xa + noise; 

xa_noised = xa_noised ./ max(abs(xa_noised));%normalizar entre 1 y -1
filename = strcat('AnalogSignal_P1', num2str(11), '_', num2str(round(SNR_A_dB(11)), 4), 'dB','.wav');
audiowrite(filename, xa_noised, Fs); %obtencion del archivo 

