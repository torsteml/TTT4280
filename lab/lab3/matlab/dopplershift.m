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
selectedChannels = 2; % First channels

% Open, import and close binary data file produced by Raspberry Pi
%% FIXME: Change this.
%path = '//run/user/1000/gvfs/smb-share:server=10.22.42.193,share=pi/TTT4280/lab/lab3/adcData.bin';
path = '/Volumes/pi/TTT4280/lab/lab3/adcData.bin';

% Run function to import all data from the binary file. If you change the
% name or want to read more files, you must change the function
% accordingly.
[rawData, nomTp] = raspiImport(path,channels);
Fs=31250;

% % Plot all raw data and corresponding amplitude response
% close all
% fh_raw = figure;    % fig handle
% subplot(2,1,1);
% selectedData=rawData(1:end,1:selectedChannels);
% plot(selectedData);
% ylim([0, 4095]) % 12 bit ADC gives values in range [0, 4095]
% xlabel('sample');
% ylabel('conversion value');
% legendStr = cell(1,selectedChannels);
% for i = 1:selectedChannels
%     legendStr{1,i} = ['ch. ' num2str(i)];
% end
% legend(legendStr,'location','best');
% title('Raw ADC data');
% 
% Fs=31250;
% freqres=abs(fft(selectedData,Fs));
% subplot(2,1,2);
% semilogx(freqres(2:end,1:end));
% xlabel('frequency');
% ylabel('amplitude');
% legendStr = cell(1,selectedChannels);
% for i = 1:selectedChannels
%     legendStr{1,i} = ['ch. ' num2str(i)];
% end
% legend(legendStr,'location','best');
% title('Frequency response');

I = rawData(1:end,1);
Im = I-mean(I);
Q = rawData(1:end,2);
Qm = Q-mean(Q);
a = Im+1i.*Qm;

winlen = 1024/2;
N = 4*1024;
[s,f,t,p] = spectrogram(a,hamming(winlen),[],N, Fs,'centered', 'yaxis');
fhz = linspace(-Fs/2,Fs/2,size(f,1));

v = freqToSpeed(f);
surf(t, v, 20*log10(abs(s)), 'EdgeColor', 'none');
axis xy; axis tight; ax = gca;
ax.YLim = [-4,4];
colormap(jet); view(0,90);
xlabel('Tid [s]');
ylabel('Hastighet [m/s]');
colorbar;
title("Hastighet-tid diagram");

hold on
m = medfreq(p,v);
plot3(t,m,500.*ones(numel(m),1),'linewidth',2)
axis xy;
hold off
max_v = max(m);
min_v = min(m);
mean_v = mean(m);
std_v = std(m);
fprintf("Maks hastighet er: %.2f m/s og %.2f m/s\n", max_v, min_v);
fprintf("Gjennomsnittlig hastighet er: %.2f m/s\n", mean_v);
fprintf("Standardavviket er: %.2f m/s\n", std_v);
    







