meanS1 = [
    79    75   102;
    83    80   138;
    80    80   120;
    74    76    74;
    71    71    72];
meanS2 = [
    68    75     NaN;
    84    84    77;
    67    67    71;
    80   104    83;
    70    69    72];
meanRBT = [
    75    84    76;
    79    84    88;
    76    94   101;
    68    68    70;
    68    68    60];
stdS1 = [
     5    10    26;
     6     4    24;
     3     2    28;
     3     5     6;
     3     3     3];
stdS2 = [     
     3    14     NaN;
     3     4     4;
     1     2     4;
     5    20     6;
     5     6     5];
stdRBT = [     
     6    15     4;
     4     6    13;
     4    24    31;
     2     1     7;
     1     1     2];

subplot(3,1,1)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanS1,stdS1)
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Puls for situasjon 1');
xlabel('Måletilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);
subplot(3,1,2)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanS2,stdS2)
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Puls for situasjon 2');
xlabel('Måletilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);
subplot(3,1,3)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanRBT,stdRBT)
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Puls for robusttest');
xlabel('Måletilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');