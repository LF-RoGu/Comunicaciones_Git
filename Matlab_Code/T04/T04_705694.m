clear all; clc; close all;
%% 
% T02_705694
% Date: 16/02/2020;

%%Code Starts Here

%% Exercise 1
clear all; clc; close all;

load lena512.mat;

figure;
imshow(uint8(lena512));
title('Original Img');

lenarec=lena512(252:284,318:350);

figure;
imshow(uint8(lenarec));
title('Cutted Img');

%% Part 2

b = de2bi(lenarec,8); %For Default it is the 'right-msb'
%% 
b = b'; %Transponse operation
bits_rx = b(:); %Concatena el resto de bits, para que sea un solo vector

% Inverted Process
    %Recover the vector bits, into a matrix of 8 bits
matrix_recovered = vec2mat(bits_rx,8); %Function to recover to a matrix a vector
    %Convert the binary matrix into decimal matrix
bin_dec = bi2de(matrix_recovered);

img_recovered = vec2mat(bin_dec,33);

img_recovered = img_recovered';

figure;
imshow(uint8(img_recovered));
title('Recovered Img');
%% Exercise 2

%% Unipolar NRZ
% We use the example code made in class as base
clc; close all;clear all;

mp = 10;
Fs = 96000;
Rs = Fs / mp;
% Since we are working one bit it is equal to one symbol
Rb = Rs;

t = 0:0.01:1;

x = zeros(1,length(t));

x(find( (t > 0.4) & (t < 0.8) ))  = 1;

pnrz = rectwin(mp);

s_unipolar = pnrz;

s_unipolar(s_unipolar == 0) = 0;

s = zeros(1,numel(pnrz)*mp);

s(1:mp:end) = s_unipolar; % Impulse Train

x = conv(x,s);

figure;

stem(x);

title('UNIPOLAR NRZ');
xlabel('tiempo'); ylabel('magnitud');

%% Polar RZ

%% Bipolar NRZ (AMI)
clc; close all;clear all;

bipolar_flag = 1;

mp = 10;
Fs = 96000;
Rs = Fs / mp;
% Since we are working one bit it is equal to one symbol
Rb = Rs;

t = 0:0.01:1;

x = zeros(1,length(t));

x(find( (t > 0.3) & (t < 0.8) ))  = 1;

pnrz = rectwin(mp);

s_bipolar = pnrz;

for i = 1:length(s_bipolar)
    if(s_bipolar(i) == 1)
        s_bipolar(i) = bipolar_flag;
        %switch flag value
        bipolar_flag = bipolar_flag * -1;
    end
end

s = zeros(1,length(s_bipolar)*mp);
s(1:mp:end) = s_bipolar; % Impulse Train

x = conv(s,x);

figure;
stem(x);

title('BIPOLAR NRZ');
xlabel('tiempo'); ylabel('magnitud');
%% Manchester
