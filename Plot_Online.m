function [F5,F6] = Plot_Online(L_uncont,L_MPC1,L_MPC_20000)


hold off;
%% Fig 5
F5 = figure(5);

L_Fig5 = [L_uncont;L_MPC1]';

L_F5 = bar(L_Fig5);

F5.WindowState = 'maximized';
F5.Position = [1,1,1366,400];
L_F5(1).FaceColor = [0.70 0.70 0.70];
L_F5(2).FaceColor = [0.30 0.30 0.30];
set(findall(gcf,'-property','FontSize'),'FontSize',22);
set(findall(gcf,'-property','FontWeight'),'FontWeight','Bold');
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');
xlabel('Time of Day (hour)');
xticks(2:2:24);
% xlim([0.5 24.5]);
% ylim([7e4,9.8e4]);
ylabel('Load (kWh)');
legend('Offline Approach','Online Approach','Location','northwest');

%% Fig 6
F6 = figure(6);

L_MPC = L_MPC_20000;

LL_MPC = zeros(10,25);

for i = 1:10

LL_MPC(i,:) = L_MPC{i};

end

L_Mean = mean(LL_MPC);
L_Std = std(LL_MPC);

F6.WindowState = 'maximized';
F6.Position = [1,1,1366,400];
M_Fig6 = bar(L_Mean);
hold on;
M_Fig6(1).FaceColor = [0.70 0.70 0.70];
S_Fig6 = errorbar(L_Mean,L_Std,'LineStyle','none','Color','k','LineWidth',1.5);
set(findall(gcf,'-property','FontSize'),'FontSize',22);
set(findall(gcf,'-property','FontWeight'),'FontWeight','Bold');
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');
xlabel('Time of Day (hour)');
xticks(2:2:24);
%xlim([0.5 24.5]);
%ylim([7e4,9.8e4]);
ylabel('Load (kWh)');
legend('Mean','Standard Deviation','Location','northwest');

hold off;

end