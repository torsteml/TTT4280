clear;
%folderpath = '~/Videos/lab4/';
folderpath = '/Volumes/pi/Videos/lab4/';
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.223.81,share=pi/Videos/lab4/';
[file, path] = uigetfile(join([folderpath,'*.mat']));
%[file, path] = uigetfile(join(['*.mat']));
path = join([path,file]);
load(path);
channelsBPass = bandpass(output_channels,[0.67 3.33],sample_rate); % 0.67-3.33 Hz <-> 40-200 bpm
for j = 1:3
    [autocorrelation(:,j),lags] = xcorr(channelsBPass(1:end,j), length(channelsBPass), 'coeff');
end
[peaks.red,locs.red] = findpeaks(autocorrelation(:,1));
[peaks.green,locs.green] = findpeaks(autocorrelation(:,2));
[peaks.blue,locs.blue] = findpeaks(autocorrelation(:,3));
if ~(isempty(locs.red))
    locsStoredCropped.red = locs.red((((length(locs.red))+1)/2):length(locs.red));
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
    pulses.red = (sample_rate./filtDiffPulse.red)*60;
    stdPulse.red = std(pulses.red);
else
   pulses.red = NaN;
   stdPulse.red = NaN;
end
if ~(isempty(locs.green))
    locsStoredCropped.green = locs.green((((length(locs.green))+1)/2):length(locs.green));
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
    pulses.green = (sample_rate./filtDiffPulse.green)*60;
    stdPulse.green = std(pulses.green);
else
    pulses.green = NaN;
    stdPulse.green = NaN;
end
if ~(isempty(locs.blue))
    locsStoredCropped.blue = locs.blue((((length(locs.blue))+1)/2):length(locs.blue));
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
    pulses.blue = (sample_rate./filtDiffPulse.blue)*60;
    stdPulse.blue = std(pulses.blue);
else
    pulses.blue = NaN;
    stdPulse.blue = NaN;
end
pulse.red = mean(pulses.red);
pulse.green = mean(pulses.green);
pulse.blue = mean(pulses.blue);
% FFT for SNR and freq plot --------------------
fcb=abs(fft(channelsBPass,8192));
l = length(channelsBPass);
P2 = abs(fcb/l);
P1 = P2(1:8192/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
fp = 60*sample_rate*(0:8192/2)/8192;
% --------------------------------------
leak = 3;
if ~isnan(pulse.red)
    sigpos.red = floor([pulse.red-leak,pulse.red+leak]*4096/1200);
    sigpow.red = sum(P1(sigpos.red(1):sigpos.red(end),1));
    noise.red = P1(:,1); noise.red(sigpos.red(1):sigpos.red(end))= 0; 
    noisepow.red = sum(noise.red);
    SNR.red = 10*log10(sigpow.red/noisepow.red);
else
    SNR.red = NaN;
end
if ~isnan(pulse.green)
    sigpos.green = floor([pulse.green-leak,pulse.green+leak]*4096/1200);
    sigpow.green = sum(P1(sigpos.green(1):sigpos.green(end),2));
    noise.green = P1(:,2); noise.green(sigpos.green(1):sigpos.green(end))= 0; 
    noisepow.green = sum(noise.green);
    SNR.green = 10*log10(sigpow.green/noisepow.green);
else
    SNR.green = NaN;
end
if ~isnan(pulse.blue)
    sigpos.blue = floor([pulse.blue-leak,pulse.blue+leak]*4096/1200);
    sigpow.blue = sum(P1(sigpos.blue(1):sigpos.blue(end),3));
    noise.blue = P1(:,3); noise.blue(sigpos.blue(1):sigpos.blue(end))= 0; 
    noisepow.blue = sum(noise.blue);
    SNR.blue = 10*log10(sigpow.blue/noisepow.blue);
else
    SNR.blue = NaN;
end
fprintf('Red Pulse: %.1f STD: %.1f\t Green Pulse: %.1f STD: %.1f\t Blue Pulse: %.1f STD: %.1f\n',mean(pulse.red),stdPulse.red,mean(pulse.green),stdPulse.green,mean(pulse.blue),stdPulse.blue);
fprintf('SNR[dB]: %.2f \t %.2f \t %.2f\n',SNR.red,SNR.green,SNR.blue);
should_plot = false;
if should_plot 
    subplot(3,1,1)
    set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
    plot(linspace(0,length(output_channels)/sample_rate,length(output_channels)),output_channels)
    subplot(3,1,2)
    set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
    plot(linspace(0,length(channelsBPass)/sample_rate,length(channelsBPass)),channelsBPass)
    subplot(3,1,3)
    set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
    plot(fp,P1)
    xlim([0 210])
    title('')
    xlabel('Puls [bpm]')
    ylabel('[a.u.]')
end