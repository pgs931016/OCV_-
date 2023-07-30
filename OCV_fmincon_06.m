clc; close all; clear

  
load ('OCV_fit.mat')

x_guess = [0.01,1*1.2,0.9,1];
x_lb = [0,1*0.5,0,1*0.5];
x_ub = [1,1*2,1,1*2]; 

w = ones(size(OCV(:,2)));
start_index = 4390;
end_index = 6065;
initial_weight =4;

w(start_index:end_index) = initial_weight; 





%% Initial Guess

[~,OCV_guess] = OCV_stoichiometry_model_06(x_guess,OCP_n,OCP_p,OCV,w);

% fmincon을 사용하여 최적화 수행
   
   options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);

    fhandle_cost = @(x)OCV_stoichiometry_model_06(x, OCP_n, OCP_p, OCV,w);
    [x_id, fval, exitflag, output] = fmincon(fhandle_cost, ...
        x_guess, [], [], [], [], x_lb, x_ub, [],options);



[cost_hat, OCV_hat] = OCV_stoichiometry_model_06(x_id,OCP_n,OCP_p,OCV,w);

% plot
figure(1)
width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize
 
% plot(OCV(:,1),OCV(:,2),'b-','LineWidth',lw,'MarkerSize',msz); hold on
% plot(OCV(:,1),OCV_hat,'r-','LineWidth',lw,'MarkerSize',msz);



pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

legend('FCC data','FCC fit')
xlabel('SOC');
ylabel('OCV (V)');
title('SOC vs. OCV (0.01C)');




% fmincon을 사용하여 최적화 수행
% 
% ms = MultiStart('UseParallel',true,'FunctionTolerance',1e-15,'XTolerance',1e-15);
w = ones(size(OCV2(:,2)));
start_index = 1280;
end_index = 1462;
initial_weight =4;

w(start_index:end_index) = initial_weight; 


[~,OCV_guess3] = OCV2_stoichiometry_model_06(x_guess,OCP_n,OCP_p,OCV2,w);

options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);


    fhandle_cost = @(x)OCV2_stoichiometry_model_06(x, OCP_n, OCP_p, OCV2,w);
    [x_id3, fval3, exitflag3, output3] = fmincon(fhandle_cost, ...
        x_guess, [], [], [], [], x_lb, x_ub, [],options);



[cost_hat3, OCV_hat3] = OCV2_stoichiometry_model_06(x_id3,OCP_n,OCP_p,OCV2,w);

% plot
figure(1)
width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize
 
plot(OCV2(:,1),OCV2(:,2),'g-','LineWidth',lw,'MarkerSize',msz); hold on
plot(OCV2(:,1),OCV_hat3,'m-','LineWidth',lw,'MarkerSize',msz);



pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

legend('FCC data','FCC fit','FCC(2) data','FCC(2) fit','Location','north')
xlabel('SOC');
ylabel('OCV (V)');
title('FCC & FCC(2) 비교');
print('OCV fig1','-dpng','-r300');

















%0.05C NE figure(2)


x_guess2 = [0.01,1*1.2,0.9,1];
x_lb = [0,1*0.5,0,1*0.5];
x_ub = [1,1*2,1,1*2]; 

w = ones(size(OCV_chg4(:,2)));
start_index = 1;
end_index = 7;
initial_weight =2;

w(start_index:end_index) = initial_weight; 

[~,OCV_guess2] = NE_OCV_stoichiometry_model_06(x_guess2,OCP_n,OCP_p,OCV_chg4,w);

 options = optimoptions(@fmincon,'MaxIterations',5000,'StepTolerance',1e-15,'ConstraintTolerance', 1e-15, 'OptimalityTolerance', 1e-15);




%    problem = createOptimProblem('fmincon', 'objective', @(x) NE_OCV_stoichiometry_model_06(x_guess2,OCP_n,OCP_p,OCV_chg4), ...
%             'x0', x_guess2, 'lb', [0,1*0.5,0,1*0.5], 'ub', [1,1*2,1,1*2] , 'options', options);
%         ms = MultiStart('Display', 'iter');
%     
%         [x_id2, fval2, exitflag2, output2] = run(ms, problem, 20); 
%     
           fhandle_cost2 = @(x)NE_OCV_stoichiometry_model_06(x, OCP_n, OCP_p,OCV_chg4,w);
    [x_id2, fval2, exitflag2, output2] = fmincon(fhandle_cost2, ...
        x_guess2, [], [], [], [], x_lb, x_ub, [],options);


[cost2_hat, OCV_chg4_hat] = NE_OCV_stoichiometry_model_06(x_id2,OCP_n,OCP_p,OCV_chg4,w);

% plot
figure(2)
width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize


plot(OCV_chg4(:,1),OCV_chg4(:,2),'b-','LineWidth',lw,'MarkerSize',msz); hold on;
plot(OCV_chg4(:,1),OCV_chg4_hat,'r-','LineWidth',lw,'MarkerSize',msz);


pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

legend('NE data','NE fit')
xlabel('SOC');
ylabel('OCV (V)');
title('SOC vs. OCV (0.05C)');
ylim([3 4.4])
yticks(0:1:4.2)
print('OCV fig2','-dpng','-r300');



figure(3) %data dv/dq
x = OCV (1:10:end,1);
y = OCV (1:10:end,2);

for i = 1:(length(x)-1)
    dvdq1(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
end
    dvdq1(end+1) = dvdq1(end);
    


x = OCV (1:10:end,1);
y = OCV_hat (1:10:end,1);

for i = 1:(length(x) - 1)
    dvdq2(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));   
end
 dvdq2(end+1) = dvdq2(end);

% 이동 평균 윈도우의 크기
window_size = 10;

% dvdq1에 이동 평균 적용
dvdq1_moving_avg = movmean(dvdq1, window_size);

% dvdq2에 이동 평균 적용
dvdq2_moving_avg = movmean(dvdq2, window_size);

% 플롯 그리기
plot(x, dvdq1_moving_avg, 'b-', 'LineWidth', lw, 'MarkerSize', msz); hold on
plot(x, dvdq2_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);


% plot(x,dvdq1,'b-','LineWidth',lw,'MarkerSize',msz); hold on
% plot(x,dvdq2,'r-','LineWidth',lw,'MarkerSize',msz);

width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

legend('FCC data','FCC fit')
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
title('SOC vs. dV/dQ');
ylim([0 3]);
yticks(0:1:5)

print('OCV fig3','-dpng','-r300');



figure(4)  %NE data dv/dq

x = OCV_chg4 (:,1);
y = OCV_chg4 (:,2);

for i = 1:(length(x) - 1)
    dvdq3(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
    

end
dvdq3(end+1) = dvdq3(end);


figure(4)
x = OCV_chg4 (:,1);
y = OCV_chg4_hat (:,1);

for i = 1:(length(x) - 1)
    dvdq4(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));   

end
dvdq4(end+1) = dvdq4(end);



plot(OCV_chg4(1:end,1),dvdq3,'b-','LineWidth',lw,'MarkerSize',msz); hold on
plot(OCV_chg4(1:end,1),dvdq4,'r-','LineWidth',lw,'MarkerSize',msz);




width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

legend('NE data','NE fit')
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
title('SOC vs. dV/dQ');
ylim([0 5]);

print('OCV fig4','-dpng','-r300');




% figure(5) %OCP_n,OCP_p dvdq
% k =  linspace(0,1,length(OCP_n(1:));
x_1 = x_id(1,1) + (1/x_id(1,2));
y_1 = x_id(1,3) - (1/x_id(1,4));

figure(5)

% n = transpose(linspace(0, 1, length(OCP_n)));
% p = transpose(linspace(0, 1, length(OCP_p)));
% soc_n = n (1:10:end);
% soc_p = p (1:10:end);

OCP_n(:,3) = ((OCP_n(:,1)-x_id(1,1))/(x_1-x_id(1,1)));
OCP_p(:,3) = ((OCP_p(:,1)-x_id(1,3))/(y_1-x_id(1,3))); 


% OCP_n(:,3) = (OCP_n(end,1)- OCP_n(1,1)) * OCP_n(:,1) + OCP_n(1,1);
% OCP_p(:,3) = (OCP_p(end,1)- OCP_p(1,1)) * OCP_p(:,1) + OCP_p(1,1);

x = OCP_n (1:end,3);
y = OCP_n (1:end,2);
% y1 = flipud(OCP_n (1:10:end,2));
% soc_a = OCP_n(1:end,1);
% soc_c = OCP_p(1:end,1);
start_value = 0;
end_value = 1;


window_size = 30;


x_values = [];
for i = 1:(length(x) - 1)
    if x(i) >= start_value && x(i)<=end_value
    dvdq5(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));   
     x_values = [x_values; x(i)];
    end
end
% dvdq5(end+1) = dvdq5(end);
% plot( x_values,dvdq5(4:end),'b-','LineWidth',lw,'MarkerSize',msz); hold on


x = OCP_p (1:end,3);
y = OCP_p (1:end,2);
% y1 = flipud(OCP_p(1:10:end,2));


x_values2 = [];
for i = 1:(length(x) - 1)
    if x(i) >= start_value && x(i)<=end_value
    dvdq6(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));   
    x_values2 = [x_values2; x(i)];
    end
end


%dvdq6(end+1) = dvdq6(end);
% plot( x_values2,dvdq6(191:end),'r-','LineWidth',lw,'MarkerSize',msz);
width = 6;     % Width in inches
height = 6;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 2;      % LineWidth
msz = 16;       % MarkerSize


% dvdq5에 이동 평균 적용
dvdq5_moving_avg = movmean(dvdq5(22:end), window_size);
x_values_moving_avg = movmean(x_values, window_size);


% dvdq6에 이동 평균 적용
dvdq6_moving_avg = movmean(dvdq6(1895:end), window_size);
x_values2_moving_avg = movmean(x_values2, window_size);


% 플롯 그리기
plot(x_values_moving_avg, abs(dvdq5_moving_avg), 'b-', 'LineWidth', lw, 'MarkerSize', msz); hold on
plot(x_values2_moving_avg, dvdq6_moving_avg, 'r-', 'LineWidth', lw, 'MarkerSize', msz);


pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties


legend('OCPn','OCPp','Location', 'none', 'Position', [0.7 0.85 0.1 0.05]);
xlabel('SOC');
ylabel('dV/dQ /  V (mAh)^-1');
title('SOC vs. dV/dQ');
xlim([0 1])
ylim([-1 2])
print('OCV fig5','-dpng','-r300');

