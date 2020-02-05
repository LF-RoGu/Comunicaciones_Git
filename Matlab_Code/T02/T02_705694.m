clear all;
%% 
% T02_705694
% Date: 04/02/2020;

%%Code Starts Here
%Audio Path
audio_path = 'spring.wav';
%Test Bench Config
frameLength = 1024;
%% BitsPerSample 4
%Audio object for reading and audico file
fileReader_per_sample_4 = dsp.AudioFileReader(audio_path,'SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter_per_sample_4 = audioDeviceWriter('SampleRate',fileReader_per_sample_4.SampleRate);
%Object for Visualization
scope_per_sample_4 = dsp.TimeScope('SampleRate',fileReader_per_sample_4.SampleRate,'TimeSpan',2,'BufferLength',fileReader_per_sample_4.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");

%Quantization process(Q)
bits_per_sample_4 = 4;                 %Cantidad de bits
swing_per_sample_4 = (2^bits_per_sample_4-1)/2;      %

%Audio Stream Loop
while ~isDone(fileReader_per_sample_4)
    signal_per_sample_4 = fileReader_per_sample_4();
    xq_int_per_sample_4 = round(signal_per_sample_4*swing_per_sample_4+swing_per_sample_4);
    
    xq_per_sample_4 = (xq_int_per_sample_4-swing_per_sample_4)/swing_per_sample_4;
    
    scope_per_sample_4([signal_per_sample_4,xq_per_sample_4])
    deviceWriter_per_sample_4(xq_per_sample_4);
end

release(fileReader_per_sample_4)
release(deviceWriter_per_sample_4)
release(scope_per_sample_4)

%% BitsPerSample 8
%Audio object for reading and audico file
fileReader_per_sample_8 = dsp.AudioFileReader(audio_path,'SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter_per_sample_8 = audioDeviceWriter('SampleRate',fileReader_per_sample_8.SampleRate);
%Object for Visualization
scope_per_sample_8 = dsp.TimeScope('SampleRate',fileReader_per_sample_8.SampleRate,'TimeSpan',2,'BufferLength',fileReader_per_sample_8.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");

%Quantization process(Q)
bits_per_sample_8 = 8;                 %Cantidad de bits
swing_per_sample_8 = (2^bits_per_sample_8-1)/2;      %

%Audio Stream Loop
while ~isDone(fileReader_per_sample_8)
    signal_per_sample_8 = fileReader_per_sample_8();
    xq_int_per_sample_8 = round(signal_per_sample_8*swing_per_sample_8+swing_per_sample_8);
    
    xq_per_sample_8 = (xq_int_per_sample_8-swing_per_sample_8)/swing_per_sample_8;
    
    scope_per_sample_8([signal_per_sample_8,xq_per_sample_8])
    deviceWriter_per_sample_8(xq_per_sample_8);
end

release(fileReader_per_sample_8)
release(deviceWriter_per_sample_8)
release(scope_per_sample_8)

%% BitsPerSample 10
%Audio object for reading and audico file
fileReader_per_sample_10 = dsp.AudioFileReader(audio_path,'SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter_per_sample_10 = audioDeviceWriter('SampleRate',fileReader_per_sample_10.SampleRate);
%Object for Visualization
scope_per_sample_10 = dsp.TimeScope('SampleRate',fileReader_per_sample_10.SampleRate,'TimeSpan',2,'BufferLength',fileReader_per_sample_10.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");

%Quantization process(Q)
bits_per_sample_10 = 10;                 %Cantidad de bits
swing_per_sample_10 = (2^bits_per_sample_10-1)/2;      %

%Audio Stream Loop
while ~isDone(fileReader_per_sample_10)
    signal_per_sample_10 = fileReader_per_sample_10();
    xq_int_per_sample_10 = round(signal_per_sample_10*swing_per_sample_10+swing_per_sample_10);
    
    xq_per_sample_10 = (xq_int_per_sample_10-swing_per_sample_10)/swing_per_sample_10;
    
    scope_per_sample_10([signal_per_sample_10,xq_per_sample_10])
    deviceWriter_per_sample_10(xq_per_sample_10);
end

release(fileReader_per_sample_10)
release(deviceWriter_per_sample_10)
release(scope_per_sample_10)

%% BitsPerSample 14
%Audio object for reading and audico file
fileReader_per_sample_14 = dsp.AudioFileReader(audio_path,'SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter_per_sample_14 = audioDeviceWriter('SampleRate',fileReader_per_sample_14.SampleRate);
%Object for Visualization
scope_per_sample_14 = dsp.TimeScope('SampleRate',fileReader_per_sample_14.SampleRate,'TimeSpan',2,'BufferLength',fileReader_per_sample_14.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");

%Quantization process(Q)
bits_per_sample_14 = 10;                 %Cantidad de bits
swing_per_sample_14 = (2^bits_per_sample_14-1)/2;      %

%Audio Stream Loop
while ~isDone(fileReader_per_sample_14)
    signal_per_sample_14 = fileReader_per_sample_14();
    xq_int_per_sample_14 = round(signal_per_sample_14*swing_per_sample_14+swing_per_sample_14);
    
    xq_per_sample_14 = (xq_int_per_sample_14-swing_per_sample_14)/swing_per_sample_14;
    
    scope_per_sample_14([signal_per_sample_14,xq_per_sample_14])
    deviceWriter_per_sample_14(xq_per_sample_14);
end

release(fileReader_per_sample_14)
release(deviceWriter_per_sample_14)
release(scope_per_sample_14)