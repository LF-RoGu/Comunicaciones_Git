clear all;close all;
% señal muy similar a la analógica
Ts = 1/1000;
t = 0:Ts:1;
x = cos(2*pi*t*10);
% señal con muestreo natural fs veces más lento (53Hz)
fs = 19;
tm = t(1:fs:end);
xm = cos(2*pi*tm*10);
% señal muestreada con sample-and-hold
ts = fs;
xs = zeros(1,length(t));
for i=1:length(t)
if( rem(i,ts)==1 )
tmp = x(i);
end
xs(i) = tmp;
end
% cuantificación
bits = 4;
M = 2^bits;
int = (max(xs)-min(xs))/M;
m = (min(xs)+int/2):int:(max(xs)-int/2);
xq = zeros(1,length(t));
for i=1:length(t)
[tmp k] = min(abs(xs(i)-m));
xq(i) = m(k);
end
% diferencia
xd = xs - xq;
% graficas
figure(1)
plot(t,x)  %analog signal
hold on
stem(tm,xm,'r','filled') %natural sampling
figure(2)
plot(t,xs)  %sample and hold
figure(3)
plot(t,xq) %quantified
figure(4)
plot(t,xd) %difference
% Calculate the Px of the signal for SNR
Px = 0;
for i=1:length(t)
Px = ((1/fs)*(xs(i)^2)) + Px;
end
% Calculate the Pq of the signal for SNR
Pq = 0;
for i=1:length(t)
Pq = ((xq(i)-xs(i))^2) + Pq;
end

%Calculate the SNR
SNR = Px/Pq
SNRdb = 10*log10(SNR)