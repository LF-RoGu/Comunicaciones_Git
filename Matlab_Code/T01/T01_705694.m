clear all;close all;
% señal muy similar a la analógica
amp = 1;
Ts = 1/1000;
t = 0:Ts:1;
x = amp*cos(2*pi*t*10);
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
%%
subplot(2,2,3);
plot(t,x)  %analog signal
title('analog signal') 
hold on
stem(tm,xm,'r','filled') %natural sampling
%%
subplot(2,2,1);
plot(t,xs)  %sample and hold
title('sample and hold')
%%
subplot(2,2,2);
plot(t,xq) %quantified
title('quantified')
%%
subplot(2,2,4);
plot(t,xd) %difference
title('difference')

%% Calculate the mean of the signal
mean(xd)
%if the result it is not ZERO we go by this method
pot_xs = sum(xs.^2)/numel(xs)
pot_xq = sum(xd.^2)/numel(xd)
SNRdb = 10*log10(pot_xs/pot_xq)