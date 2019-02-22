% Open channel
path = 'R:\Exercises\Lab3\output\';
ip = '10.22.43.64';
%ip = '172.16.42.25';
sample_count = 2*67000;
sample_countStr = num2str(sample_count);
roundCount = 1;
pause on
c=sshfrommatlab('pi',ip,'12C7uO35');
v_view_range = [-4,4];
%% Create highpass filter
% hpFilt = designfilt('highpassiir','PassbandFrequency',40, ...
%          'StopbandFrequency', 10,...
%          'PassbandRipple',0.1, ...
%          'SampleRate',fs,...
%          'StopbandAttenuation',70,'DesignMethod','ellip');
% fvtool(hpFilt)
for roundN = 1:roundCount
    c=sshfrommatlab('pi',ip,'12C7uO35');
    fname = ['output/measurement_' num2str(roundN) '.bin'];
    fname2 = ['\\measurement_' num2str(roundN) '.bin'];
    command = ['cd Exercises/Lab3 && sudo ./adc_sampler ' sample_countStr ' ' fname];
    %%
     fprintf("STARTING IN\n");
    for n = 3:-1:1
       fprintf("\t..%c..\n",num2str(n));
       pause(0.5)
    end
    fprintf("NOW!\n");
   %%
    [c,r]=sshfrommatlabissue(c,command);
    if size(r,1) == 0
        error('SSH command failed');
    end
    fprintf("DONE!\n");
    sshfrommatlabclose(c);
    %% Import measurements 
    channels = 2;   % Number of ADC channels used

    % Open, import and close binary data file produced by Raspberry Pi
    full_path = [path fname2];
    [rawData, nomTp] = raspiImport(full_path,channels);
    fs = 1/nomTp;
    Ivec = rawData(:,1);
    Qvec = rawData(:,2);
    %%
    Ivec_m = Ivec-mean(Ivec);
    Qvec_m = Qvec-mean(Qvec);
    s = Ivec+i.*Qvec;
    s_m = Ivec_m+1i.*Qvec_m;
    s_array(II)={s_m};
    II=II+1;
    return
    %% Take FFT
%     s_fft = fft(s);
%     s_fft(1)=0;
%     s_fft_shft = fftshift(s_fft);
%     % Normalize
%     s_fft_shft = s_fft_shft./max(s_fft_shft);
%     s_abs = abs(s_fft_shft);
%     f = linspace(-fs/2,fs/2,size(s_fft_shft,1))/1e3;
%     figure
%     plot(f,s_abs)
%     ax = gca;
%     %ax.XLim=[0,f(round(numel(f)/2))];
%     ax.XLim=[-0.4,0.4];
%     ax.YLim=[-.1,1.1];
%     xlabel('f [kHz]');
%     ylabel('|F(f)|');
%     title('Spectrum');
%     % Velocity
%     fhz = linspace(-fs/2,fs/2,size(s_fft,1));
%     c=2.998;
%     f0=2*24.150;
%     v= (c*1/f0).*fhz;
%     figure
%     plot(v, s_abs)
%     ax = gca;
%     %ax.XLim=[0,f(round(numel(f)/2))];
%     ax.XLim=[-0.4*1000*c/f0,0.4*1000*c/f0];
%     ax.YLim=[-.1,1.1];
%     xlabel('v [m/s]');
%     ylabel('|F(I/Q)|');
%     title('Velocity Spectrum');
    %% Find max positive and negative velocities
%     midpoint = size(s_abs,1)/2;
%     [m,i_pos] = max(s_abs(midpoint:end));
%     [m,i_neg] = max(s_abs(1:midpoint-1));
%     i_neg = midpoint-i_neg+1;
%     i_neg=-i_neg*1/fs
%     i_pos=i_pos*1/fs
    %% V-T Display
    winlen = 1024/2;
    nfft = 4*1024;
    [spec, freqs, times, p] = spectrogram(s_m,hamming(winlen),[],nfft, fs,'centered', 'yaxis');
    %%
    fhz = linspace(-fs/2,fs/2,size(freqs,1));
    c=0.2998;
    f0=2*24.150;
    v= (c*1/f0).*fhz;
    f=figure;
    surf(times, v, 20*log10(abs(spec)), 'EdgeColor', 'none');
    axis xy; 
    axis tight; 
    ax = gca;
    ax.YLim = v_view_range;
    colormap(jet); view(0,90);
    xlabel('Time [s]');
    ylabel('Velocity [m/s]');
    colorbar;
    title("Doppler Velocity-Time diagram");
    %%
    hold on
    m1 = medfreq(p,v);
    plot3(times,m1,500.*ones(numel(m1),1),'linewidth',4)
    axis xy;
    hold off
    max_v = max(m1);
    min_v = min(m1);
    mean_v = mean(m1);
    std_v = std(m1);
    fprintf("The maximum velocities are %.2f m/s and %.2f m/s\n", max_v, min_v);
    fprintf("The average velocity was %.2f m/s\n", mean_v);
    fprintf("The standard deviation was %.2f m/s\n", std_v);
    

%     bucket_size = 1024; % Samples
%     bucket_num = floor(sample_count/bucket_size);
%     bucket_totalSamples = bucket_num*bucket_size;
%     %wf_mat = zeros(bucket_num, bucket_size); % Waterfall matrix
%     samples = reshape(s(1:bucket_totalSamples),[bucket_num, bucket_size]);
%     wf_mat = fft(samples);
%     wf_mat_sft = fft_shift(wf_mat);
%     wf_mat_sft = wf_mat_sft./max(wf_mat_sft(:));
%     wf_mag = abs(wf_mat_sft);
    
end

%%
f_range = abs(2.*(24.050-24.250));
c=0.2998;
v_range= c./f_range
