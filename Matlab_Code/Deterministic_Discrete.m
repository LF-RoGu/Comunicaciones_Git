% Deterministic Discrete Sinusoidal Wave with Vpp=2 and offset=0
n = 0:1e3; A=1; f0=1/50; wo= 2*pi*f0; 
xn = A*cos(wo*n); 

% Discrete Random variable (RV) with uniform Probability Mass Function (PMF) 
%randi / genera numeros aleatorios en ([1 6]) un millon de veces
xD=randi([1 6], 1,1e6); 
figure(1);
histogram(xD,6)
mean(xD)
% Continuous RV with uniform Probability Density Function (PDF) 
xU=rand(1,1e6); 
figure(2);
histogram(xU,'Normalization','pdf'); 
% plots an estimate of the PDF for X. 
mean(xU)
var(xU) 
figure(3);
% Continuous RV with Gaussian Probability Density Function (PDF) 
xG=randn(1,1e6); 
histogram(xG,'Normalization','pdf'); 
mean(xG) 
var(xG)


%% Comandos para size de alguna variable poco pesadas para el sistema
%Indica valor total de argumentos
numel(xn)
%Indica tamano del vector y total de argumentos
size(xn)

%manera de aproximarnos a la media estadistica (Ux)
sum(xn)/numel(xn)
%manera eficiente de obtener Ux (media estadistica)
mean(xn)
%% Varianza de la senal
var(xn)

%sumatoria de los elementos al cuadrado entre el num de elementos
%AVISO
%Esto solamente cuando la media en CERO
%Es decir calcular la POTENCIA

%% Manera de calcular la integral de la senal o Varianza de la senal
sum(xn.^2)/numel(xn)

%Valor RMS
sqrt(var(xn))