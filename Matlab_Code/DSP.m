%Test Bench Config
frameLength = 1024;
%Audio object for reading and audico file
fileReader = dsp.AudioFileReader('Counting-16-44p1-mono-15secs.wav','SamplesPerFrame',frameLength);
%Audio objecto for writing the audio device
deviceWriter = audioDeviceWriter('SampleRate',fileReader.SampleRate);
%Object for Visualization
scope = dsp.TimeScope('SampleRate',fileReader.SampleRate,'TimeSpan',2,'BufferLength',fileReader.SampleRate*2*2,'YLimits',[-1,1],'TimeSpanOverrunAction',"Scroll");
%Quantization process(Q)
b = 4;                 %Cantidad de bits
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