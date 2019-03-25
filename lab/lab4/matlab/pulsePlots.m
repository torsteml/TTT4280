meanTBT = [
    75    74	67;
    72    71    106;
    86    81    106;
    69	  72    69;
    70    70	71];
meanTBG = [
    91    77    116;
    67    74	95;
    89    70    NaN;
    78    72	98;
    84    78	104];
meanRT = [
    76    85	98;
    65	  58	78;
    80	  57	97;
    81    53	80;
    98	  59    91];
meanRG = [
    86    68	87;
    93    57	114;
    39    41	52;
    67    66	86;
    67    50	96];
meanTDT = [
    76    78	77;
    76	  80	79;
    76    78	77;
    68    68	68;
    69    69	40];
meanHP = [
    78    82	46;
    111   95	152;
    90   102	NaN;
    90    98	NaN;
    112  111	127];
meanKF = [
    55    64	NaN;
    71    80	96;
    50    77	55;
    73    77	109;
    64 	  50	NaN];
stdTBT = [
     8     8	16;
     9    11	22;
    18     6	30;
    5	   4	4;
    4	   4	3];
stdTBG = [
    22    17	28;
    4      9	22;
    20    15	NaN;
    8     11	23;
    21    15	18];
stdRT = [
    14    20	20;
    18    12	15;
    16     9    24;
    23     8	30;
    25    12	22];
 stdRG = [
    18    13	22;
    27     9	22;
     2     2	14;
    15     9	16;
    18     6	26];
 stdTDT = [
    21   21    20;
    10    9    11;
     7    6    11;
     2    4		4;
     1    1		1];
 stdHP = [
    19   22	   28;
    17   25	   22;
    12    6	  NaN;
    11   18	  NaN;
    6     8	   19];
 stdKF = [
     7    9	  NaN;
    16   18	   23;
     9   19	   34;
    11   13    21;
    12   11	  NaN];

subplot(7,1,1)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanTBT,stdTBT,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Transmittans boks Torstein');
xlabel('M�letilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);

subplot(7,1,2)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanTBG,stdTBG,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Transmittans boks Gaute');
xlabel('M�letilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);

subplot(7,1,3)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanRT,stdRT,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Reflektans Torstein');
xlabel('M�letilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');

subplot(7,1,4)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanRG,stdRG,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Reflektans Gaute');
xlabel('M�letilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');

subplot(7,1,5)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanTDT,stdTDT,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Transmittans direkte Torstein');
xlabel('M�letilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');

subplot(7,1,6)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanHP,stdHP,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Høy puls Torstein');
xlabel('M�letilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');

subplot(7,1,7)
set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
errorbar(meanKF,stdKF,'--')
ax=gca;
ax.YGrid = 'on';
xlim([0.75 5.25]);
title('Kalde fingre Gaute');
xlabel('M�letilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');
