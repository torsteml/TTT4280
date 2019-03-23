meanS1 = [79 83 80 74 71; 75 80 80 76 71; 102 138 120 74 72];
meanS2 = [68 84 67 80 70; 75 84 67 104 69; 0 77 71 83 72];
meanRBT = [75 79 76 68 68; 84 84 94 68 68; 76 88 101 70 60];
stdS1 = [5 6 3 3 3; 10 4 2 5 3; 26 24 28 6 3];
stdS2 = [3 3 1 5 5; 14 4 2 20 6; 0 4 4 6 5];
stdRBT = [6 4 4 2 1; 15 6 24 1 1; 4 13 31 7 2];

subplot(3,1,1)
errorbar(meanS1(1,:),stdS1(1,:),'o r')
xlim([0.75 5.25]);
title('Puls for situasjon 1');
xlabel('Måletilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);
hold on
errorbar(meanS1(2,:),stdS1(2,:),'o g')
errorbar(meanS1(3,:),stdS1(3,:),'o b')

subplot(3,1,2)
errorbar(meanS2(1,:),stdS2(1,:),'- r')
xlim([0.75 5.25]);
title('Puls for situasjon 2');
xlabel('Måletilfelle');
ylabel('Puls [bpm]');
xticks([1 2 3 4 5]);
hold on
errorbar(meanS2(2,:),stdS2(2,:),'- g')
errorbar(meanS2(3,:),stdS2(3,:),'- b')

subplot(3,1,3)
errorbar(meanRBT(1,:),stdRBT(1,:),'- r')
xlim([0.75 5.25]);
title('Puls for robusttest');
xlabel('Måletilfelle');
xticks([1 2 3 4 5]);
ylabel('Puls [bpm]');
hold on
errorbar(meanRBT(2,:),stdRBT(2,:),'- g')
errorbar(meanRBT(3,:),stdRBT(3,:),'- b')