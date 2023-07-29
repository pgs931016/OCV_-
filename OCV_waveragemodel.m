function [cost,OCV_sim] = OCV_waveragemodel(x, OCP_n, OCP_p, OCV,w)
    % OCV_hat 계산
    
    [~, OCV_sim] = OCV_stoichiometry_model_06(x, OCP_n, OCP_p, OCV);
    
    % 비용 계산
    cost_OCV = sum(OCV_sim - OCV(:,2)).^2./mean(OCV(:,2));
    
    % dV/dQ 값들 계산
    x_values = OCV(:,1);
    y_values = OCV(:,2);
    y_sim_values = OCV_sim(:,1);
    dvdq = diff(y_values) ./ diff(x_values);
    dvdq_sim = diff(y_sim_values) ./ diff(x_values);
    dvdq = [dvdq; dvdq(end)];
    dvdq_sim = [dvdq_sim; dvdq_sim(end)];

    % dv/dq를 이용한 비용 계산 (예: 평균 제곱 오차)
    cost_dvdq = sum((dvdq_sim - dvdq).^2./mean(dvdq));

    % 비용 합산 (예: 평균)
    
    cost =  sum((cost_OCV + cost_dvdq).*w);
end










% function [cost,OCV_sim] = OCV_waveragemodel(x, OCP_n, OCP_p, OCV, OCV_hat,w)
% 
% 
%   x_0 = x(1);
%   QN = x(2);
%   y_0 = x(3);
%   QP = x(4);
% 
% Cap = OCV(:,1);
%     if (OCV(end,2)<OCV (1,2)) % Discharge OCV
%         x_sto =-(Cap - Cap(1))/QN + x_0;
%         y_sto = (Cap - Cap(1))/QP + y_0;
%     else  % Charge OCV
%         x_sto = (Cap - Cap(1))/QN + x_0;
%         y_sto =-(Cap - Cap(1))/QP + y_0;
%     end
% 
% 
%     %model
%     OCP_n_sim = interp1(OCP_n(:,1), OCP_n(:,2), x_sto, 'linear','extrap');
%     OCP_p_sim = interp1(OCP_p(:,1), OCP_p(:,2), y_sto, 'linear','extrap');
%     
%     OCV_sim = OCP_p_sim - OCP_n_sim;
% 
% cost = sqrt(sum((OCV_sim - OCV(:,2)).^2)/mean(OCV_hat)+w/mean(w));
% %cost는 매개변수의 비용
% 
% 
% end
