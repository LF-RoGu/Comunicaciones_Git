%P02_PII

Fs=96e3; sec=5; % Time duration of the whole communication including the silence

recObj = audiorecorder(Fs,16,1);

disp('Start speaking');
recordblocking(recObj, sec);
disp('End of Recording');

Rx_signal = getaudiodata(recObj);

threshold = 0.1; % Detecting the channel energization
start = find(abs(Rx_signal)> threshold,3,'first'); % Initial
stop = find(abs(Rx_signal)> threshold,1,'last'); % End
Rx_signal = Rx_signal (start:stop); 