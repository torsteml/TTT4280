[file, path] = uigetfile(join(['*.mat']));
path = join([path,file]);
load(path);
channelsBPass = bandpass(output_channels,[0.67 3.33],sample_rate); % 0.67-3.33 Hz <-> 40-200 bpm
l = length(channelsBPass);
fcb=abs(fft(channelsBPass,8192));
P2 = abs(fcb/l);
P1 = P2(1:8192/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
fp = 60*sample_rate*(0:8192/2)/8192;
[val.red,pos.red] = max(P1(:,1));
[val.green,pos.green] = max(P1(:,2));
[val.blue,pos.blue] = max(P1(:,3));


fprintf('Red Pulse: %.1f\t Green Pulse: %.1f\t Blue Pulse: %.1f\n',fp(pos.red),fp(pos.green),fp(pos.blue));
subplot(3,1,1)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
plot(linspace(0,length(output_channels)/sample_rate,length(output_channels)),output_channels)
title('Rådata')
xlabel('Tid [s]')
subplot(3,1,2)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
plot(linspace(0,length(channelsBPass)/sample_rate,length(channelsBPass)),channelsBPass)
title('Filtrert (40-200 Hz)')
xlabel('Tid [s]')
subplot(3,1,3)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
plot(fp,P1)
xlim([0 210])
title('Frekvens -> pulsplot')
xlabel('Puls [bpm]')
