clear all; clc; close all;
%% 
% T02_705694
% Date: 09/02/2020;

%%Code Starts Here
Fs = 100;
Ts = 1/Fs;

start = 0;
step = Ts;
%Signal duration of 1s
stop = 1.0;

% Create a vector starting on ZERO, step of 0.1 and it will be finished at
% 1.0
t = start : step : stop;

% Find and mark as 1 in the vector x, the values that goes according to the
% condition.
find_low = 0.4;
find_high = 0.6;

find_low_t = 0.7;
find_high_t = 0.9;

%% Exercise 1
% Create a vector filled with ZERO's. As the same length of (t).
x_1 = zeros(1,length(t));
%x1 = [ones(1,20) zeros(1,80)];

x_1( find( (t >= find_low) & (t < find_high_t) ) ) = 1;

plot(t,x_1);
wvtool(x_1);

%% Exercise 2
% Create a vector filled with ZERO's. As the same length of (t).
x_2 = zeros(1,length(t));
 
x_2( find( (t >= find_low) & (t < find_high) ) ) = 1;
x_2( find( (t >= find_low_t) & (t < find_high_t) ) ) = 1;

plot(t,x_2);
wvtool(x_2);

%% Exercise 3
% Create a vector filled with ZERO's. As the same length of (t).
x_3 = zeros(1,length(t));
 
x_3( find( (t >= find_low) & (t < find_high) ) ) = 1;
x_3( find( (t >= find_low_t) & (t < find_high_t) ) ) = -1;

plot(t,x_3);
wvtool(x_3);

%% Exercise 4
% Create a vector filled with ZERO's. As the same length of (t).
x_4_1 = zeros(1,length(t));
 
x_4_1( find( (t >= 0.45) & (t < 0.55) ) ) = 1;

plot(t,x_4_1);
wvtool(x_4_1);

% Create a vector filled with ZERO's. As the same length of (t).
x_4_05 = zeros(1,length(t));
 
x_4_05( find( (t >= 0.475) & (t < 0.525) ) ) = 1;

plot(t,x_4_05);
wvtool(x_4_05);

% Create a vector filled with ZERO's. As the same length of (t).
x_4_4 = zeros(1,length(t));
 
x_4_4( find( (t >= 0.3) & (t < 0.7) ) ) = 1;

plot(t,x_4_4);
wvtool(x_4_4);

% Create a vector filled with ZERO's. As the same length of (t).
x_4_6 = zeros(1,length(t));
 
x_4_6( find( (t >= 0.2) & (t < 0.8) ) ) = 1;

plot(t,x_4_6);
wvtool(x_4_6);