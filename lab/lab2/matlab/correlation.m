% This script will import the binary data from files written by the C
% program on Raspberry Pi.
%
% The script uses the function raspiImport to do the actual import and
% conversion from binary data to numerical values. Make sure you have
% downloaded it as well.
%
% After the import function is finished, the data are written to the
% variable rawData. The number of samples is returned in a variable samples

% Definitions
channels = 5;   % Number of ADC channels used
selectedChannels = 3; % First channels

% Open, import and close binary data file produced by Raspberry Pi
%% FIXME: Change this.
path = '//run/user/1000/gvfs/smb-share:server=pigt.local,share=pi/TTT4280/lab/lab2/adcData.bin';

% Run function to import all data from the binary file. If you change the
% name or want to read more files, you must change the function
% accordingly.
[rawData, nomTp] = raspiImport(path,channels);
selectedData = rawData(1:end,1:selectedChannels);
Fs = 31250;
upSampleRatio = 16;

% Separating the array 
mic1 = selectedData(1:end,1);
mic2 = selectedData(1:end,2);
mic3 = selectedData(1:end,3);

% Upsampling the array
umic1 = interp(mic1,upSampleRatio);
umic2 = interp(mic2,upSampleRatio);
umic3 = interp(mic3,upSampleRatio);

% Filtering out DC, f<5 Hz
fmic1 = highpass(umic1,5,upSampleRatio*Fs);
fmic2 = highpass(umic2,5,upSampleRatio*Fs);
fmic3 = highpass(umic3,5,upSampleRatio*Fs);

% Crosscorrelation between the different pairs, maxlags
[xc21,lags21] = xcorr(fmic2,fmic1,100);
[xc31,lags31] = xcorr(fmic3,fmic1,100);
[xc32,lags32] = xcorr(fmic3,fmic2,100);

% Finding indices for max values 
[val21,ind21] = max(abs(xc21));
[val31,ind31] = max(abs(xc31));
[val32,ind32] = max(abs(xc32));

% Finding delay in seconds
delay21 = (ind21-max(lags21))/(upSampleRatio*Fs);
delay31 = (ind31-max(lags31))/(upSampleRatio*Fs);
delay32 = (ind32-max(lags32))/(upSampleRatio*Fs);

%Print delays between the different pairs
fprintf("2-1: %.2e\t 3-1: %.2e\t 3-2: %.2e\n",delay21,delay31,delay32);

%Angle from the centerpoint, counterclockwise
theta = atan(sqrt(3)*(delay21+delay31)/(delay21-delay31-2*delay32));

%Print angle in degrees
fprintf("Angle: %.2f\n",mod(theta*360/(2*pi),360));

refreshdata
subplot(2,3,1)
plot(lags21,xc21);
title("XCorr 2-1");
subplot(2,3,2)
plot(lags31,xc31);
title("XCorr 3-1");
subplot(2,3,3)
plot(lags32,xc32);
title("XCorr 3-2");
subplot(2,3,[4 5])
plot(fmic1);
hold on
plot(fmic2);
hold on
plot(fmic3);
hold off
title("Signals");
legend('Mic 1','Mic 2','Mic 3');
subplot(2,3,6)
rose(theta);
title("Angle");
hold off
