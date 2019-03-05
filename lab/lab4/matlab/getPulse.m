clear;
folderpath = '/Volumes/pi/Videos/lab4/';
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.223.81,share=pi/Videos/lab4/';
[file, path] = uigetfile(join([folderpath,'*.mp4']));
path = join([folderpath,file]);
[output_channels, sample_rate] = read_video_and_extract_roi(path);
redChannel = output_channels(1:end,1);
redChannelHPass = highpass(redChannel,1,sample_rate);
[autocorrelation,lags] = xcorr(redChannelHPass, length(redChannelHPass), 'coeff');
[peaks,locs] = findpeaks(autocorrelation);
locsStored = locs-1199;
locsStored = locsStored(locsStored>=0);
%locsStoredCropped = locsStored(1:end-57);

diffPulse = diff(locsStoredCropped);
pulse = (sample_rate/mean(diffPulse))*60;
stdPulse = std((sample_rate/diffPulse)*60);
fprintf('Estimated pulse: %.0f\n',pulse);
fprintf('Estimated standard deviation: %.0f\n',stdPulse);