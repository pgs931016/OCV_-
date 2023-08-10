clc;clear;close all

%input 지정(ocp,ocv데이터),function model,function cost,cost function
%minimization
%load the data
data1 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_Data/Hyundai_dataset/OCV/FCC_(5)_OCV_C100');
data2 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_Data/Hyundai_dataset/OCV/AHC_(5)_OCV_C100');
data3 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_Data/Hyundai_dataset/OCV/CHC_(5)_OCV_C100');
data4 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/NE_cell/dataNE');   
data5 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV2/HNE_(6)_FCC_OCV2');
data6 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV/FCC_(5)_OCV_C20');
data7 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV/AHC_(5)_OCV_C20');
data8 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV/CHC_(5)_OCV_C20');
data9 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV2/HNE_(5)_AHC_OCV2');
data10 = load('/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/Battery Software Lab/Processed_data/Hyundai_dataset/OCV2/HNE_(4)_CHC_OCV2');
%셀종류
id_cfa = 1;


    
    %half_cell_ocp(averaging the three) = golden ocp
 OCV   = data1.OCV_golden.OCVchg;
 OCP_n = data2.OCV_golden.OCVchg;
 OCP_p = data3.OCV_golden.OCVchg;
 OCV_NE.OCVchg01 = data4.OCV_NE.OCVchg1;
 OCV_NE.OCVchg005 = data4.OCV_NE.OCVchg2;
 OCV2  = data5.OCV_golden.OCVchg; %0cv2
 OCV3 = data6.OCV_golden.OCVchg; %ocv1
 OCP_n1 = data7.OCV_golden.OCVchg;
 OCP_p1 = data8.OCV_golden.OCVchg;
 OCP_n2 = data9.OCV_golden.OCVchg;
 OCP_p2 = data10.OCV_golden.OCVchg;
 %OCV_NE.OCVdis = data4.dataNE.

% %Variable name(dataList)
% %datalist = dataList;
 
%plot actual OCP data (parameter)
%for i=1:size(OCP_n,2) %MATLAB에서 배열의 열을 반복하는 데 사용
     figure(1); hold on; box on
     plot(OCP_n2(:,1),OCP_n2(:,2))
     figure(2); hold on; box on
     plot(OCP_p2(:,1),OCP_p2(:,2)) 
%end
figure(1)
title('Anode OCP')
xlabel('x in LixC6')
ylabel('OCP [V]')
figure(2)
title('Cathode OCP')
xlabel('y in LixMO2')
ylabel('OCP [V]')


    Cap = data5.OCV_golden.OCVchg(:,1)*data5.Q_cell; % [Ah] Discharged capacity
    OCV_SOC = data5.OCV_golden.OCVchg(:,1); 
    OCV_chg = data5.OCV_golden.OCVchg(:,2); % [V] Cell Voltage 
    %measurement = [Cap,OCV]; % OCV measurement matrix [q [Ah], v[V]]
    OCV_chg3 = OCV_NE.OCVchg01;
    OCV_chg4 =  OCV_NE.OCVchg005(~isnan( OCV_NE.OCVchg005(:,1)),:);
    
   
    figure(3); hold on; box on
    plot(OCV_SOC,OCV_chg)  
%end
figure(3)
title('Full Cell OCV')
xlabel('Cap[mAh]')
ylabel('OCV [V]')

save('OCV_fit.mat','OCP_n','OCP_p','OCV','OCV2','OCV3','Cap','OCV_NE',"OCV_chg3","OCV_chg4",'OCP_n1','OCP_p1','OCP_n2','OCP_p2','id_cfa','data1','data2','data3','data4','data5','data6','data7','data8','data9','data10');

% % parameter 정의
% x0 = 0;
% y0 = 1;
% Qn = 0.0052;
% Qp = 0.0057;







