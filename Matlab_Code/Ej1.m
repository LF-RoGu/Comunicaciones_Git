% Deterministic Discrete Sinusoidal Wave with Vpp=2 and offset=0
n = 0:1e3; A=1; f0=1/50; wo= 2*pi*f0; 
xn = A*cos(wo*n); 

%%
% Discrete Random variable (RV) with uniform Probability Mass Function (PMF) 
%randi / genera numeros aleatorios en ([1 6]) un millon de veces
xD=randi([1 6], 1,1e6); 
mean(xD)
var(xD) %Como la media no es CERO la varianza no es la potencia, por lo que calculamos por medio de:
%POTENCIA
pot_xD = sum(xD.^2)/numel(xD)

figure(1);
histogram(xD,6)

%%
% Continuous RV with uniform Probability Density Function (PDF) 
xU=rand(1,1e6); 
mean(xU)
var(xU)
%Metodo alternativo para calcular POTENCIA
pot_xU = sum(xU.^2)/numel(xU)

figure(2);
histogram(xU,'Normalization','pdf'); 

%%
% Continuous RV with Gaussian Probability Density Function (PDF) 
%randn valoren rand NORMAL = GAUSSIANA
xG=randn(1,1e6);
mean(xG) 
var(xG)
%Metodo alternativo para calcular POTENCIA
pot_xG = sum(xG.^2)/numel(xG)

figure(3);
histogram(xG,'Normalization','pdf'); 

%%

