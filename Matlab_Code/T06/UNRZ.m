%Author: Luis Fernando Rodriguez
%Institution: ITESO
%Date: 

function UPLC = UNRZ(mp,Fs,data)
    Ts = 1/Fs;
    %UPBP (Uni-Polar Base Pulse)
    UPBP = ones(1,mp);
    
    UP_s = zeros(1,numel(data)*mp);
    
    UP_s(1:mp:end) = data; % Impulse Train

    UPLC = conv(UPBP,UP_s); %UPLC (Uni-Polar Line Code)