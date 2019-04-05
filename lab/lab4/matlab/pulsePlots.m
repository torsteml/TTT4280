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

actualPulse = [
    76   71    73    74    70   103   72;
    75   72    76    72    83   102   68;   
    77   69    68    72    73    97   70;
    75   73    72    74    73    90   73;  
    73   76    72    72    65   124   71];

prompt = 'Velg situasjon [1-7]:\n1) Transmittans boks Torstein\n2) Transmittans boks Gaute\n3) Reflektans Torstein\n4) Reflektans Gaute\n5) Transmittans direkte \n6) Hï¿½y puls\n7) Kaldre fingre\n0) Avslutt\n';
while true
    
    sit = input(prompt);
    if sit >= 0 && sit <= 7
        clf
        set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
        switch sit
            case 1
                errorbar(meanTBT,stdTBT,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Transmittans boks person 1');
               
            case 2
                errorbar(meanTBG,stdTBG,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Transmittans boks person 2');

            case 3
                errorbar(meanRT,stdRT,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Reflektans person 1');

            case 4
                errorbar(meanRG,stdRG,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Reflektans person 2');

            case 5
                errorbar(meanTDT,stdTDT,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Transmittans direkte person 1');

            case 6
                errorbar(meanHP,stdHP,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Høy puls person 1');
                
            case 7
                errorbar(meanKF,stdKF,'--')
                hold on
                plot(actualPulse(:,sit),'k');
                %title('Kalde fingre person 2');
                
            case 0
                close all
                break
        end
    end
    set(gca, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1],'NextPlot', 'replacechildren'); % RGB colors
    ax=gca;
    ax.YGrid = 'on';
    ax.FontSize = 10; 
    xlabel('Måletilfelle','FontSize',14);
    ylabel('Puls [bpm]','FontSize',14);
    xlim([0.75 5.25]);
    box on
    xticks([1 2 3 4 5]);
    legend('Rød kanal','Grønn kanal','Blå kanal','Referanse','Location','best','FontSize',14)
end