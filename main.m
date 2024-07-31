
clc;
clear all;
close all;

addpath('/data'); 


fac = 0.1;
Load = load('Load.mat');
Load = fac * Load.BL(24:48);
Load = Load + 0.1 * mean(Load)*rand(1, 25);

BL = Load;

a1 = 1;
a2 = 0.001;

% [Reulted Load Profile, Resulted Desicions] = Agg(a1,a2,#EVs,#Flexible Loads);
% Note that the best results, related to the simulations in the corresponding paper, %will be in hand in the case of having 10000 EVs and 10000 flexible loads.


% [L_0_1_250,X_0_1_250] = Agg1(a1,a2,10,10,fac);

% [L_0_1_500,X_0_1_500] = Agg1(a1,a2,20,20,fac);

% [L_0_1_750,X_0_1_750] = Agg1(a1,a2,30,30,fac);

% [L_0_1_1000,X_0_1_1000] = Agg1(a1,a2,40,40,fac);

% [L_1_1_250,X_1_1_250] = Agg1(a1,a2,10,10,fac);

[L_1_1_500,X_1_1_500] = Agg1(BL,a1,0,2,2,fac);

% [L_1_1_750,X_1_1_750] = Agg1(a1,a2,30,30,fac);

[L_1_1_1000,X_1_1_1000] = Agg1(BL,a1,a2,40,40,fac);

% [L_1_0_1000,X_1_0_1000] = Agg1(a1,a2,40,40,fac);

[L_uncont,X_uncont] = Agg2(BL,1,0,40,40,fac);

Fig3_L = [1.03*BL;L_uncont;L_1_1_1000]';

% [Fig2,Fig3,Fig4] = Plot_Offline(Load,Fig3_L,L_0_1_250,L_0_1_500,L_0_1_750,L_0_1_1000,L_1_1_250,L_1_1_500,L_1_1_750,L_1_1_1000);
Fig3 = Plot_Offline(Load,Fig3_L);
% savefig(Fig2,'Fig2.fig');
% savefig(Fig3,'Fig3.fig');
% savefig(Fig4,'Fig4.fig');

% figure(2);
% openfig('Fig2.fig');
% saveas(gcf, '../results/Fig2.png');

figure(3);
openfig('Fig3.fig');
saveas(gcf, '../results/Fig3.png')

% figure(4);
% openfig('Fig4.fig');
% saveas(gcf, '../results/Fig4.png');
% 
% save('/results/L_uncont','L_uncont');