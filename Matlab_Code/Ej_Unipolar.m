bits = randi([0 1],1024,1); % Generate Random bits
mp = 20; % samples per pulse
Fs = mp; % It can be different
Ts=1/Fs;
% The bit rate is Rb= Rs= Fs / mp, because 1 bit= 1 symbol and every symbol has mp
% samples per bit
%pnrz = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; % Pulse type with mp samples
pnrz = 5* ones(1,mp); % Similar to Arduino pulses with 5V
wvtool(pnrz)
s = zeros(1,numel(bits)*mp);
s(1:mp:end) = bits; % Impulse Train
xUNRZ = conv(pnrz,s); % Pulse Train
pwelch(xUNRZ,[],[],[],Fs,'power'); % PSD of Unipolar NRZ