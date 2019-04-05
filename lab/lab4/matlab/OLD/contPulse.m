clear;
% Connect to pi and cameraboard if a connection doesn't exist
if ~exist('rpi','var')
    rpi = raspi('hostname.local','user','password');
end
if ~exist('cam','var')
   % Options for the camera
   H_Res = 640;
   V_Res = 480;
   Resolution = join([num2str(H_Res) 'x' num2str(V_Res)]);
   % --------------------------------------------------------------------------------
   Options.Resolution.String = 'Resolution'; Options.Resolution.Value = Resolution;
   Options.Quality.String = 'Quality'; Options.Quality.Value = 10;
   Options.FrameRate.String = 'FrameRate'; Options.FrameRate.Value = 30;
   Options.ExposureMode.String = 'ExposureMode'; Options.ExposureMode.Value = 'off';
   Options.AWBMode.String = 'AWBMode'; Options.AWBMode.Value = 'off';
   % --------------------------------------------------------------------------------
   cam = cameraboard(rpi,Options.Resolution.String, Options.Resolution.Value...
       ,Options.Quality.String, Options.Quality.Value...
       ,Options.FrameRate.String, Options.FrameRate.Value...
       ,Options.ExposureMode.String, Options.ExposureMode.Value...
       ,Options.AWBMode.String, Options.AWBMode.Value);
end

imshow(snapshot(cam))
choice = questdlg('Choose region?','Choose region or whole image','Yes','No','No');
switch choice
    case 'Yes'
        r = round(getrect);
        ROI = [r(1)/V_Res r(2)/H_Res r(3)/H_Res r(4)/V_Res];
        clear cam
        cam = cameraboard(rpi,Options.Resolution.String, Options.Resolution.Value...
       ,Options.Quality.String, Options.Quality.Value...
       ,Options.FrameRate.String, Options.FrameRate.Value...
       ,Options.ExposureMode.String, Options.ExposureMode.Value...
       ,Options.AWBMode.String, Options.AWBMode.Value...
       ,'ROI', ROI);
    case 'No'
end
close all;

% Number of seconds to hold the captured frames for
holdTime = 5;
% Initalization variable to prevent the processing from starting with too
% little data
init = true;
% Vector consisting of the images
% vid = zeros(V_Res,H_Res,3,holdTime*cam.FrameRate);
% Sample rate periods for contniuously measuring sample rate
sr_periods = zeros(holdTime*cam.FrameRate,1);
% Elapsed time for the capturing
elapsed_time = 0;
x_label='';
while true
    for i = 1:holdTime*cam.FrameRate
        % Taking images and showing it
%         vid = circshift(vid,1,4);
%         vid(:,:,:,1) = snapshot(cam);
        vid(:,:,:,i) = snapshot(cam);
        imagesc(vid(:,:,:,i));
        if i > cam.FrameRate
            init = false;
        end
        sr_periods = circshift(sr_periods,1,1);
        sr_periods(1) = toc;
        tic;
        sample_rates = 1./sr_periods;
        valid_sample_rates= sample_rates > cam.FrameRate/2 & sample_rates < cam.FrameRate;
        sr_mean = mean(sample_rates(valid_sample_rates));
        if i > 1
            elapsed_time = elapsed_time + sr_periods(1);
        end
        xlabel(x_label)
        title(sprintf('Frame: %d\t FPS: %.2f\t\t Avg. FPS: %.2f Elapsed time: %.1f s\n',i,sample_rates(1),sr_mean,elapsed_time));
        drawnow;
        %-----------------------------
        % Processing the data
        if floor(mod(i,holdTime*sr_mean)) == 0 & ~init
            clear autocorrelation lags peaks locs locsStoredCropped diffPulse filtDiffPulse
            output_channels = read_video_and_extract_roi_cont(vid);
            channelsHPass = highpass(output_channels,1,sr_mean);
            for j = 1:3
                [autocorrelation(:,j),lags] = xcorr(channelsHPass(1:end,j), length(channelsHPass), 'coeff');
            end
            [peaks.red,locs.red] = findpeaks(autocorrelation(:,1));
            [peaks.green,locs.green] = findpeaks(autocorrelation(:,2));
            [peaks.blue,locs.blue] = findpeaks(autocorrelation(:,3));
                
            locsStoredCropped.red = locs.red(((((length(locs.red))+1)/2):((length(locs.red))+1)/2+3));
            locsStoredCropped.green = locs.green(((((length(locs.green))+1)/2):((length(locs.green))+1)/2+3));
            locsStoredCropped.blue = locs.blue(((((length(locs.blue))+1)/2):((length(locs.blue))+1)/2+3));
            
            diffPulse.red = diff(locsStoredCropped.red);
            diffPulse.green = diff(locsStoredCropped.green);
            diffPulse.blue = diff(locsStoredCropped.blue);
            
            filtDiffPulse.red = zeros(0);
            filtDiffPulse.green = zeros(0);         
            filtDiffPulse.blue = zeros(0);         

            for j = 1:length(diffPulse.red)
                if j == 1
                    if diffPulse.red(j) > sr_mean/200*60
                        filtDiffPulse.red(end+1)=diffPulse.red(j);
                    end
                elseif diffPulse.red(j) > mean(diffPulse.red)
                    filtDiffPulse.red(end+1)=diffPulse.red(j);
                end
            end
            for j = 1:length(diffPulse.green)
                if j == 1
                    if diffPulse.green(j) > sr_mean/200*60
                        filtDiffPulse.green(end+1)=diffPulse.green(j);
                    end
                elseif diffPulse.green(j) > mean(diffPulse.green)
                    filtDiffPulse.green(end+1)=diffPulse.green(j);
                end
            end
            for j = 1:length(diffPulse.red)
                if j == 1
                    if diffPulse.blue(j) > sr_mean/200*60
                        filtDiffPulse.blue(end+1)=diffPulse.blue(j);
                    end
                elseif diffPulse.blue(j) > mean(diffPulse.blue)
                    filtDiffPulse.blue(end+1)=diffPulse.blue(j);
                end
            end
            pulse.red = (sr_mean./filtDiffPulse.red)*60;
            pulse.green = (sr_mean./filtDiffPulse.green)*60;
            pulse.blue = (sr_mean./filtDiffPulse.blue)*60;
            stdPulse.red = std(pulse.red);
            stdPulse.green = std(pulse.green);
            stdPulse.blue = std(pulse.blue);
            x_label=sprintf('Red Pulse: %.1f STD: %.1f\t Green Pulse: %.1f STD: %.1f\t Blue Pulse: %.1f STD: %.1f\n',mean(pulse.red),stdPulse.red,mean(pulse.green),stdPulse.green,mean(pulse.blue),stdPulse.blue);        end
    end
end