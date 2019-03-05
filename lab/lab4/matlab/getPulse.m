clear;
path = '/Volumes/pi/Videos/lab4/';
files = dir(path);
for i=3:length(files)
    disp(files(i).name);
end
newline;
path = join([path,input('Filename: ','s')]);
[output_channels, sample_rate] = read_video_and_extract_roi(path);
redChannel = output_channels(1:end,1);
redChannelHPass = highpass(redChannel,1,sample_rate);
[autocorrelation,lags] = xcorr(redChannelHPass, length(redChannelHPass), 'coeff');
[peaks,locs] = findpeaks(autocorrelation);
locsStored = locs-1199;
locsStored = locsStored(locsStored>=0);
locsStoredCropped = locsStored(1:end-35);
diffPulse = diff(locsStoredCropped);
pulse = (sample_rate/mean(diffPulse))*60;
stdPulse = (sample_rate/std(diffPulse))*60;
fprintf('Estimated pulse: %.0f\n',pulse);
fprintf('Estimated standard deviation: %.0f\n',stdPulse);