function [F2,F3,F4] = Plot_Offline(Load,L_Fig3,L01_5000,L01_10000,L01_15000,L01_20000,L11_5000,L11_10000,L11_15000,L11_20000)

% %% Fig 2
% L_Fig2 = 6*Load;
% 
% F2 = figure(2);
% F2.WindowState = 'maximized';
% F2.Position = [1,1,1366,400];
% B_Fig2 = bar(L_Fig2);
% B_Fig2.FaceColor = [0.25 0.25 0.25];
% set(findall(gcf,'-property','FontSize'),'FontSize',22);
% set(findall(gcf,'-property','FontWeight'),'FontWeight','Bold');
% set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');
% xlabel('Time of Day (hour)');
% xticks(2:2:24);
% xlim([0.5 24.5]);
% % ylim([0 105000]);
% ylabel('Load (kWh)');
% 

%% Fig 3

F3 = figure(3);
F3.WindowState = 'maximized';
F3.Position = [1,1,1366,400];
B_Fig3 = bar(L_Fig3);
B_Fig3(1).FaceColor = [0.88 0.88 0.88];
B_Fig3(2).FaceColor = [0.6 0.6 0.6];
B_Fig3(3).FaceColor = [0.3 0.3 0.3];
set(findall(gcf,'-property','FontSize'),'FontSize',18);
set(findall(gcf,'-property','FontSize'),'FontSize',22);
set(findall(gcf,'-property','FontWeight'),'FontWeight','Bold');
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');
xlabel('Time of Day (hour)');
xticks(2:2:24);
xlim([0.5 24.5]);
ylabel('Load (kWh)');
legend('Uncontrolled','Cost Reduction','Aggregative Game Approach','Location','northwest');

% %% Figure 4
% 
% V11_5000 = var(L11_5000);
% V11_10000 = var(L11_10000);
% V11_15000 = var(L11_15000);
% V11_20000 = var(L11_20000);
% 
% P11_5000 = PriceFinderVeh(L11_5000);
% P11_10000 = PriceFinderVeh(L11_10000);
% P11_15000 = PriceFinderVeh(L11_15000);
% P11_20000 = PriceFinderVeh(L11_20000);
% 
% C11_5000 = (P11_5000*L11_5000')/sum(L11_5000);
% C11_10000 = (P11_10000*L11_10000')/sum(L11_10000);
% C11_15000 = (P11_15000*L11_15000')/sum(L11_15000);
% C11_20000 = (P11_20000*L11_20000')/sum(L11_20000);
% 
% V01_5000 = var(L01_5000);
% V01_10000 = var(L01_10000);
% V01_15000 = var(L01_15000);
% V01_20000 = var(L01_20000);
% 
% P01_5000 = 13.2*ones(1,numel(P11_5000));
% P01_10000 = 13.2*ones(1,numel(P11_5000));
% P01_15000 = 13.2*ones(1,numel(P11_5000));
% P01_20000 = 13.2*ones(1,numel(P11_5000));
% 
% C01_5000 = (P01_5000*L01_5000')/sum(L01_5000);
% C01_10000 = (P01_10000*L01_10000')/sum(L01_10000);
% C01_15000 = (P01_15000*L01_15000')/sum(L01_15000);
% C01_20000 = (P01_20000*L01_20000')/sum(L01_20000);
% 
% 
% 
% C11 = [C11_5000 C11_10000 C11_15000 C11_20000];
% 
% C01 = [C01_5000 C01_10000 C01_15000 C01_20000];
% 
% V11 = [V11_5000 V11_10000 V11_15000 V11_20000];
% 
% V01 = [V01_5000 V01_10000 V01_15000 V01_20000];
% 
% F4 = figure(4);
% subplot(2,1,1)
% F4.WindowState = 'maximized';
% F4.Position = [1,1,1366,400];
% subplot(2,1,1)
% plot([25 50 75 100],C01,'--ko','LineWidth',1.5)
% hold on;
% plot([25 50 75 100],C11,'-kx','LineWidth',1.5,'MarkerSize',10)
% %xlim([24.5 100.5]);
% %ylim([11 14.8])
% ylabel('Mean Price (�)');
% hold off;
% legend('Load-Levelling','Proposed Approach (a=1)');
% % ylabel('Mean of Trading Price (�)')
% grid on;
% 
% subplot(2,1,2)
% plot([25 50 75 100],V01,'--ko','LineWidth',1.5)
% hold on;
% plot([25 50 75 100],V11,'-kx','LineWidth',1.5,'MarkerSize',10)
% %xlim([24.5 100.5]);
% %ylim([0 17.2e7]);
% ylabel('Load Variance');
% xlabel('% of Participating Agents');
% hold off;
% legend('Load-Levelling','Proposed Approach (a=1)');
% % ylabel('Mean of Trading Price (�)')
% grid on;
% 
% F4.WindowState = 'maximized';
% F4.Position = [1,1,1366,400];
% set(findall(gcf,'-property','FontSize'),'FontSize',22);
% set(findall(gcf,'-property','FontWeight'),'FontWeight','Bold');
% set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');

end