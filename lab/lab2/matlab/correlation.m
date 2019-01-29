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
path = '//run/user/1000/gvfs/smb-share:server=10.22.43.82,share=pi/TTT4280/lab/lab2/adcData.bin';

% Run function to import all data from the binary file. If you change the
% name or want to read more files, you must change the function
% accordingly.
[rawData, nomTp] = raspiImport(path,channels);
selectedData = rawData(1:end,1:selectedChannels);
Fs = 31250;
upSampleRate = 16;

% Separating the array 
mic1 = selectedData(1:end,1);
mic2 = selectedData(1:end,2);
mic3 = selectedData(1:end,3);

% Upsampling the array
umic1 = interp(mic1,upSampleRate);
umic2 = interp(mic2,upSampleRate);
umic3 = interp(mic3,upSampleRate);

% Filtering out DC, f<5 Hz
fmic1 = highpass(umic1,5/Fs);
fmic2 = highpass(umic2,5/Fs);
fmic3 = highpass(umic3,5/Fs);

% Crosscorrelation between the different pairs
[xc12,lags12] = xcorr(fmic1,fmic2);
[xc13,lags13] = xcorr(fmic1,fmic3);
[xc23,lags23] = xcorr(fmic2,fmic3);

% Finding indices for max values 
[val12,ind12] = max(abs(xc12));
[val13,ind13] = max(abs(xc13));
[val23,ind23] = max(abs(xc23));

% Finding delay in seconds
delay12 = (ind12-max(lags12))/(upSampleRate*Fs);
delay13 = (ind13-max(lags13))/(upSampleRate*Fs);
delay23 = (ind23-max(lags23))/(upSampleRate*Fs);

fprintf("1-2: %.2e\t 1-3: %.2e\t 2-3: %.2e\n",delay12,delay13,delay23);
