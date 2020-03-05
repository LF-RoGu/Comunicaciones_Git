bits = randi([0 1],1024,1); % Generate random bits
mp = 20; % samples per pulse
Fs = mp; % It can be different
Ts=1/Fs; % The bit rate is Rb= Rs= Fs / mp
pnrz = ones(1,mp); % pnrz = [1 1 1 … 1 1]; % Pulse type with mp samples
s1 = bits;
s1(s1==0) = -1; % Convert “0” to “-1”
s = zeros(1,numel(s1)*mp);
s(1:mp:end) = s1;
xPNRZ = conv(pnrz,s);
plot(xPNRZ(1:mp*16))
pwelch(xPNRZ,500,300,500,Fs,'power');