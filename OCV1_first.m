clc;clear;close all

  
load ('OCV_fit.mat')

x_guess = [0.01,1*1.2,0.9,1];
x_lb = [0,1*0.5,0,1*0.5];
x_ub = [1,1*2,1,1*2]; 




%% Initial Guess
[~,OCV_guess] = OCV_stoichiometry_model_06(x_guess,OCP_n,OCP_p,OCV);


% fmincon을 사용하여 최적화 수행
  
options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);
   
problem = createOptimProblem('fmincon', 'objective', @(x) OCV_stoichiometry_model_06(x,OCP_n,OCP_p,OCV), ...
            'x0', x_guess, 'lb', [0,1*0.5,0,1*0.5], 'ub', [1,1*2,1,1*2] , 'options', options);
        ms = MultiStart('Display', 'iter');
    
        [x_id, fval, exitflag, output] = run(ms, problem, 20); 
 



[cost_hat, OCV_hat] = OCV_stoichiometry_model_06(x_id,OCP_n,OCP_p,OCV);

% plot

width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 20;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize





figure('Name','movingavg생성') %data dv/dq

window_size = 30;

x = OCV (:,1);
y = OCV (:,2);


x_values = [];
for i = 1:(length(x)-1)
    dvdq1(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
    x_values = [x_values; x(i)];
end


x = OCV (:,1);
y = OCV_hat (:,1);


x_values2 = [];
for i = 1:(length(x) - 1)
    dvdq2(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i)); 
    x_values2 = [x_values2; x(i)];
end


dvdq1_moving_avg = movmean(dvdq1(1:end), window_size);
x_values_moving_avg = movmean(x_values, window_size);

% dvdq6에 이동 평균 적용
dvdq2_moving_avg = movmean(dvdq2(1:end), window_size);
x_values2_moving_avg = movmean(x_values2, window_size);

% 플롯 그리기
plot(x_values_moving_avg, dvdq1_moving_avg, 'b-', 'LineWidth', lw, 'MarkerSize', msz); hold on
plot(x_values2_moving_avg, dvdq2_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);
title('Moving avg');



figure('Name','w생성')
w = ones(size(dvdq1_moving_avg(1,:)));
greater_than_1_indices = find(dvdq1_moving_avg <1);
% greater_than_2_indices = find(OCV(:,1) > 0.65 & OCV(:,1) < 0.8);

greater_than_1_values = dvdq1_moving_avg(1,greater_than_1_indices);
% greater_than_2_values = OCV(greater_than_2_indices ,1);


start_index = greater_than_1_indices(1); 
end_index = greater_than_1_indices(end);
% start_index2 = greater_than_2_indices(1,1);
% end_index2 = greater_than_2_indices(end,1);

w(start_index:end_index) = dvdq1_moving_avg(start_index:end_index)+1; 
% w(start_index2:end_index2) = dvdq1_moving_avg(start_index2:end_index2);


% greater_than_1_indices = find(OCV(:,1) > 0.1 & OCV(:,1) < 0.9);
% greater_than_1_values = OCV(greater_than_1_indices ,1);
% w = ones(size(OCV(:,1)));
% start_index = greater_than_1_indices(1,1); 
% end_index = greater_than_1_indices(end,1);
% w(start_index:end_index) = dvdq1_moving_avg(start_index:end_index); 



plot(w,'b-','LineWidth',lw,'MarkerSize',msz); hold on


save('ocv1w.mat','w');



% figure('position', [0 0 500 400] );
figure('Name','w적용전')




% 첫 번째 그래프
subplot(2, 1, 1);

plot(OCV(:,1),OCV(:,2),'b-','LineWidth',lw,'MarkerSize',msz);
hold on;
plot(OCV(:,1),OCV_hat,'r-','LineWidth',lw,'MarkerSize',msz);
% xlabel('SOC');
ylabel('OCV (V)');
title('OCV1 (0.01C)');
% yyaxis right;
% ax = gca;  % 현재 축 객체 가져오기
% ax.YColor = 'k';  % 검정색으로 설정
% ylabel('Weight')
% plot(OCV(1:end,1),w(1:end),'-g','LineWidth',lw,'MarkerSize',msz);
% ylim([0 7])
% 
legend('FCC data','FCC fit','Location', 'none', 'Position', [0.2 0.85 0.1 0.05],'FontSize', 6);

% 두 번째 그래프
subplot(2, 1, 2);

% subtightplot(2, 1, 2, [0.1 0.05], [0.05 0.1], [0.1 0.05]);
plot(x_values_moving_avg, dvdq1_moving_avg, 'b-', 'LineWidth', lw, 'MarkerSize', msz);
hold on;
plot(x_values2_moving_avg, dvdq2_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
% title('SOC vs. dV/dQ');
ylim([0 2]);
print('OCV fig66','-dpng','-r300');



% [~,OCV_guess] = OCV_waveragemodel(x_guess,OCP_n,OCP_p,OCV);
% options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);
%    
% problem = createOptimProblem('fmincon', 'objective', @(x) OCV_waveragemodel(x,OCP_n,OCP_p,OCV), ...
%             'x_id', x_guess, 'lb', [0,1*0.5,0,1*0.5], 'ub', [1,1*2,1,1*2] , 'options', options);
%         ms = MultiStart('Display', 'iter');
%     
%         [x_id2, fval, exitflag, output] = run(ms, problem, 20); 
%  
% 
% 
% 
% [cost_hat2, OCV_hat2] = OCV_waveragemodel(x_id2,OCP_n,OCP_p,OCV);





% 두 번째 최적화를 위한 초기 추정값 (이전에 구한 x_id 값을 사용)

% x0_2nd_opt = x_id;
% 
% % 두 번째 최적화 수행
% [x_id_2nd_opt, fval_2nd_opt, exitflag_2nd_opt, output_2nd_opt] = fmincon(@(x) OCV_waveragemodel(x, OCP_n, OCP_p, OCV,OCV_hat), ...
%     x0_2nd_opt, [], [], [], [], x_lb, x_ub, [], options);
% 
% % 두 번째 최적화 결과 출력
% disp('2nd Optimization - Optimized variables:');
% disp(x_id_2nd_opt);
% disp('2nd Optimization - Optimized cost:');
% disp(fval_2nd_opt);
% 
% % 두 번째 최적화 결과로 OCV 예측하기
% [~, OCV_hat_2nd_opt] = OCV_waveragemodel(x_id_2nd_opt, OCP_n, OCP_p, OCV,OCV_hat);



