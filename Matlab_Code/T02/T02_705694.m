clear all;
%% 
% T02_705694
% Date: 04/02/2020;

%%Code Starts Here
%Audio Path
audio_path = '\home\luis\Desktop\ITESO\9no_Semestre\Comunicaciones\Git_Comunicaciones\Matlab_Code\T02\spring.wav';
%Test Bench Config
frameLength = 1024;
%Audio object for reading and audico file
fileReader = dsp.AudioFileReader(audio_path,'SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter = audioDeviceWriter('SampleRate',fileReader.SampleRate);
%Object for Visualization
scope = dsp.TimeScope('SampleRate',fileReader.SampleRate,'TimeSpan',2,'BufferLength',fileReader.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");
%% BitsPerSample 4
%Quantization process(Q)
bits_per_sampe_4 = 4;                 %Cantidad de bits
swing = (2^b-1)/2;      %

%Audio Stream Loop
while ~isDone(fileReader)
    signal = fileReader();
    xq_int = round(signal*swing+swing);
    
    xq = (xq_int-swing)/swing;
    
    scope([signal,xq])
    deviceWriter(xq);
end

release(fileReader)
release(deviceWriter)
release(scope)

%% BitsPerSample 4