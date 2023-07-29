function [cost, OCV_sim] = OCV_stoichiometry_model_06(x, OCP_n, OCP_p, OCV)
%함수의 c
%함수의 OCV_sim 값


  x_0 = x(1);
  QN = x(2);
  y_0 = x(3);
  QP = x(4);

Cap = OCV(:,1);
    if (OCV(end,2)<OCV(1,2)) % Discharge OCV
        x_sto =-(Cap - Cap(1))/QN + x_0;
        y_sto = (Cap - Cap(1))/QP + y_0;
    else  % Charge OCV
        x_sto = (Cap - Cap(1))/QN + x_0;
        y_sto =-(Cap - Cap(1))/QP + y_0;
    end


% Cap = OCV(:,1);
%     if (OCV_golden.OCVchg (end,2)<OCV_golden.OCVchg (1,2)) % Discharge OCV
%         x_sto = -(Cap - Cap(1))/QN + x_0;
%         y_sto = (Cap - Cap(1))/QP + y_0;
%     else  % Charge OCV
%         x_sto = (Cap - Cap(1))/QN + x_0;
%         y_sto = -(Cap - Cap(1))/QP + y_0;
%     end

    %model
    OCP_n_sim = interp1(OCP_n(:,1), OCP_n(:,2), x_sto, 'linear','extrap');
    OCP_p_sim = interp1(OCP_p(:,1), OCP_p(:,2), y_sto, 'linear','extrap');
    
    OCV_sim = OCP_p_sim - OCP_n_sim;

cost =  sum((OCV_sim - OCV(:, 2)).^2);
%cost는 매개변수의 비용)


end












