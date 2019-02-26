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
%folderpath = '//run/user/1000/gvfs/smb-share:server=10.22.223.98,share=pi/TTT4280/lab/lab3/målinger/';
%folderpath = '/Volumes/pi/TTT4280/lab/lab3/målinger/';
folderpath = '../målinger/';
prompt = 'Velg måling [1-15]: ';
while true
    filenr = input(prompt);
    if filenr >= 1 && filenr <= 15
        break;
    end
end
path = join([folderpath,num2str(filenr),'.bin']);

% Run function to import all data from the binary file. If you change the
% name or want to read more files, you must change the function
% accordingly.
[rawData, nomTp] = raspiImport(path,channels);
Fs=31250;

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
    







