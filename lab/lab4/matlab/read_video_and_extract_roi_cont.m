function output_channels = read_video_and_extract_roi_cont(video)
% Calculates the mean over each frame in the video input file.  User selects a
% smaller ROI over which to calculate the mean.  Returns each image channel as
% a column vector in the output_channels matrix.
%
% If you are running MATLAB on Linux, you will probably have problems with
% MATLAB requiring so old versions of ffmpeg-related libraries that you will be
% unable to install them. In that case, rather use the supplied Python script. :-)

v = video;

numFrames = size(v,4);

y_red = zeros(1, numFrames);
y_green = zeros(1, numFrames);
y_blue = zeros(1, numFrames);

% Read video frame by frame
for i=1:numFrames
    frame = v(:,:,:,i);

%     % Get user input
%     if i == 1
%         close all;
%         imshow(frame)
%         choice = questdlg('Choose region?','hasFrame(v)Choose region or whole image','Yes','No','No');
%         switch choice
%             case 'Yes'
%                 r = round(getrect);
%             case 'No'
%                 r = [0 0 size(frame,2) size(frame,1)];
%         end
%         close all;
%     end
%     frame = imcrop(frame, r);

    % Prepare mean over the ROI
    red_frame = squeeze(frame(:,:,1));
    green_frame = squeeze(frame(:,:,2));
    blue_frame = squeeze(frame(:,:,3));

    y_red(i) = mean(red_frame(:));
    y_green(i) = mean(green_frame(:));
    y_blue(i) = mean(blue_frame(:));
end

output_channels = [y_red', y_green', y_blue'];
end
