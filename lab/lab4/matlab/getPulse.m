clear;
<<<<<<< HEAD
%folderpath = '/Volumes/pi/Videos/lab4/';
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.220.161,share=pi/Videos/lab4/';
folderpath = '~/Videos/lab4/';
=======
folderpath = '/Volumes/pi/Videos/lab4/';
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.223.81,share=pi/Videos/lab4/';
>>>>>>> 29ea9b8cbb0e5a68a651b3d71ef8ee6691de8be6
[file, path] = uigetfile(join([folderpath,'*.mp4']));
path = join([path,file]);
[output_channels, sample_rate] = read_video_and_extract_roi(path);
redChannel = output_channels(1:end,1);
redChannelHPass = highpass(redChannel,1,sample_rate);
[autocorrelation,lags] = xcorr(redChannelHPass, length(redChannelHPass), 'coeff');
[peaks,locs] = findpeaks(autocorrelation);
locsStoredCropped = locs((((length(locs))+1)/2):((length(locs))+1)/2+20);
diffPulse = diff(locsStoredCropped);
filtDiffPulse = zeros(0);
for i = 1:length(diffPulse)
    if i == 1
        if diffPulse(i) > sample_rate/200*60
            filtDiffPulse(end+1)=diffPulse(i);
        end
    elseif diffPulse(i) > mean(diffPulse)
        filtDiffPulse(end+1)=diffPulse(i);
    end
end
pulse = (sample_rate./filtDiffPulse)*60;
stdPulse = std(pulse);
fprintf('Estimated pulse: %.0f\n',mean(pulse));
fprintf('Estimated standard deviation: %.0f\n',stdPulse);