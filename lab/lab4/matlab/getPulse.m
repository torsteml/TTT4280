clear;
%folderpath = '~/Videos/lab4/';
%folderpath = '/Volumes/pi/Videos/lab4/';
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.223.81,share=pi/Videos/lab4/';
%[file, path] = uigetfile(join([folderpath,'*.mat']));
[file, path] = uigetfile(join(['*.mat']));
path = join([path,file]);
load(path);
channelsHPass = highpass(output_channels,1,sample_rate);
for j = 1:3
    [autocorrelation(:,j),lags] = xcorr(channelsHPass(1:end,j), length(channelsHPass), 'coeff');
end
[peaks.red,locs.red] = findpeaks(autocorrelation(:,1));
[peaks.green,locs.green] = findpeaks(autocorrelation(:,2));
[peaks.blue,locs.blue] = findpeaks(autocorrelation(:,3));

if ~(isempty(locs.red))
    locsStoredCropped.red = locs.red(((((length(locs.red))+1)/2):((length(locs.red))+1)/2+20));
    diffPulse.red = diff(locsStoredCropped.red);
    filtDiffPulse.red = zeros(0);
    for j = 1:length(diffPulse.red)
        if j == 1
            if diffPulse.red(j) > sample_rate/200*60
                filtDiffPulse.red(end+1)=diffPulse.red(j);
            end
        elseif diffPulse.red(j) > mean(diffPulse.red)
            filtDiffPulse.red(end+1)=diffPulse.red(j);
        end
    end
    pulse.red = (sample_rate./filtDiffPulse.red)*60;
    stdPulse.red = std(pulse.red);
else
   pulse.red = 0;
   stdPulse.red = 0;
end

if ~(isempty(locs.green))
    locsStoredCropped.green = locs.green(((((length(locs.green))+1)/2):((length(locs.green))+1)/2+20));
    diffPulse.green = diff(locsStoredCropped.green);
    filtDiffPulse.green = zeros(0);         
    for j = 1:length(diffPulse.green)
        if j == 1
            if diffPulse.green(j) > sample_rate/200*60
                filtDiffPulse.green(end+1)=diffPulse.green(j);
            end
        elseif diffPulse.green(j) > mean(diffPulse.green)
        filtDiffPulse.green(end+1)=diffPulse.green(j);
        end
    end
    pulse.green = (sample_rate./filtDiffPulse.green)*60;
    stdPulse.green = std(pulse.green);
else
    pulse.green = 0;
    stdPulse.green = 0;
end

if ~(isempty(locs.blue))
    locsStoredCropped.blue = locs.blue(((((length(locs.blue))+1)/2):((length(locs.blue))+1)/2+20));
    diffPulse.blue = diff(locsStoredCropped.blue);
    filtDiffPulse.blue = zeros(0);   
    for j = 1:length(diffPulse.blue)
        if j == 1
            if diffPulse.blue(j) > sample_rate/200*60
                filtDiffPulse.blue(end+1)=diffPulse.blue(j);
            end
        elseif diffPulse.blue(j) > mean(diffPulse.blue)
            filtDiffPulse.blue(end+1)=diffPulse.blue(j);
        end
    end
    pulse.blue = (sample_rate./filtDiffPulse.blue)*60;
    stdPulse.blue = std(pulse.blue);
else
    pulse.blue = 0;
    stdPulse.blue = 0;
end
fprintf('Red Pulse: %.1f STD: %.1f\t Green Pulse: %.1f STD: %.1f\t Blue Pulse: %.1f STD: %.1f\n',mean(pulse.red),stdPulse.red,mean(pulse.green),stdPulse.green,mean(pulse.blue),stdPulse.blue);