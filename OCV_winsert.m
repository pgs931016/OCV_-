clc;clear;close all;
load ('OCV_fit.mat')
load('ocv1w.mat')
% 두 번째 최적화를 위한 초기 추정값 (이전에 구한 x_id 값을 사용)

x0_2nd_opt = x_id;

% 두 번째 최적화 수행

%% Initial Guess
[~,OCV_guess] =  OCV_waveragemodel(x0_2nd_opt,OCP_n,OCP_p,OCV,w);


% fmincon을 사용하여 최적화 수행
  
options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);
   
problem = createOptimProblem('fmincon', 'objective', @(x) OCV_waveragemodel(x,OCP_n,OCP_p,OCV,w), ...
            'x0', x0_2nd_opt, 'lb', [0,1*0.5,0,1*0.5], 'ub', [1,1*2,1,1*2] , 'options', options);
        ms = MultiStart('Display', 'iter');
    
        [x_id, fval, exitflag, output] = run(ms, problem, 20); 
 

[cost_hat,OCV_hat] = OCV_waveragemodel(x_id,OCP_n,OCP_p,OCV,w);
 

figure('Name','w적용후')
width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize
 
plot(OCV(:,1),OCV(:,2),'b-','LineWidth',lw,'MarkerSize',msz); hold on
plot(OCV(:,1),OCV_hat,'r-','LineWidth',lw,'MarkerSize',msz);














% plot

width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize
 



plot(OCV(:,1),OCV(:,2),'b-','LineWidth',lw,'MarkerSize',msz); hold on;
plot(OCV(:,1),OCV_hat,'r-','LineWidth',lw,'MarkerSize',msz);



pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
% 
% legend('FCC data','FCC fit')
xlabel('SOC');
ylabel('OCV (V)');
title('SOC vs. OCV (0.01C)');




yyaxis right;
ax = gca;  % 현재 축 객체 가져오기
ax.YColor = 'k';  % 검정색으로 설정
ylabel('Weight')
plot(OCV(1:end,1),w(1:end),'-g','LineWidth',lw,'MarkerSize',msz);
ylim([0 20])

legend('FCC data','FCC fit','Weight');


figure% OCV1 fit dv/dq

start_value = 0;
end_value = 1;

window_size = 30;



x = OCV (:,1);
y = OCV (:,2);



x_values = [];
for i = 1:(length(x)-1)
    dvdq77(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
    x_values = [x_values; x(i)];
end
dvdq77(end+1) = dvdq77(end);
x_values(end+1) = x_values(end);   



x = OCV (:,1);
y = OCV_hat (:,1);

x_values2 = [];
for i = 1:(length(x) - 1)
    dvdq88(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
    x_values2 = [x_values2; x(i)];   
end
dvdq88(end+1) = dvdq88(end);
x_values2(end+1) =  x_values2(end);
% 
% plot(x(1:end),dvdq77(1:end),'b-','LineWidth',lw,'MarkerSize',msz); hold on
% plot(x(1:end),dvdq88(1:end),'r-','LineWidth',lw,'MarkerSize',msz);

dvdq77_moving_avg = movmean(dvdq77(1:end), window_size);
x_values_moving_avg = movmean(x_values, window_size);

% dvdq6에 이동 평균 적용
dvdq88_moving_avg = movmean(dvdq88(1:end), window_size);
x_values2_moving_avg = movmean(x_values2, window_size);

% 플롯 그리기
% yyaxis right;
% ax = gca;  % 현재 축 객체 가져오기
% ax.YColor = 'k';  % 검정색으로 설정
% ylabel('Weight')
% ylim([0 2.5]);

plot(x_values_moving_avg, dvdq77_moving_avg, 'b-', 'LineWidth', lw, 'MarkerSize', msz); hold on
plot(x_values2_moving_avg, dvdq88_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);


figure('Name','w생성')
w = ones(size(dvdq77_moving_avg(1,:)));
greater_than_1_indices = find(dvdq77_moving_avg <5);
% greater_than_2_indices = find(OCV(:,1) > 0.65 & OCV(:,1) < 0.8);

greater_than_1_values = dvdq77_moving_avg(1,greater_than_1_indices);
% greater_than_2_values = OCV(greater_than_2_indices ,1);


start_index = greater_than_1_indices(1); 
end_index = greater_than_1_indices(end);
% start_index2 = greater_than_2_indices(1,1);
% end_index2 = greater_than_2_indices(end,1);

w(start_index:end_index) = dvdq77_moving_avg(start_index:end_index)+1; 
plot(w,'b-','LineWidth',lw,'MarkerSize',msz);









width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize


pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties


% legend('FCC data','FCC fit')
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
title('SOC vs. dV/dQ');
ylim([-1 3]);


print('OCV fig4','-dpng','-r300');



% plot
figure('position', [0 0 500 400] );

width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 20;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize


pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties



% 첫 번째 그래프
subplot(2, 1, 1);

plot(OCV(:,1),OCV(:,2),'b-','LineWidth',lw,'MarkerSize',msz);
hold on;
plot(OCV(:,1),OCV_hat,'r-','LineWidth',lw,'MarkerSize',msz);
% xlabel('SOC');
ylabel('OCV (V)');
title('OCV1 (0.01C)');
yyaxis right;
ax = gca;  % 현재 축 객체 가져오기
ax.YColor = 'k';  % 검정색으로 설정
ylabel('Weight')
plot(OCV(1:end,1),w(1:end),'-g','LineWidth',lw,'MarkerSize',msz);
ylim([0 20])

legend('FCC data','FCC fit','Weight','Location', 'none', 'Position', [0.2 0.85 0.1 0.05],'FontSize', 6);

% 두 번째 그래프
subplot(2, 1, 2);

% subtightplot(2, 1, 2, [0.1 0.05], [0.05 0.1], [0.1 0.05]);
plot(x_values_moving_avg, dvdq77_moving_avg, 'b-', 'LineWidth', lw, 'MarkerSize', msz);
hold on;
plot(x_values2_moving_avg, dvdq88_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
% title('SOC vs. dV/dQ');
ylim([0 2]);
print('OCV fig9','-dpng','-r300');




