 %�Ǽ�ʵ�����ݣ����Ը����͵��ӿռ��㷨
%   VarName1�Ǵ�SD���е����MTiԭʼ���ݣ���ʶ�ã���Ϊfloat�͵�������
%   VarName2�Ǵ�SD���е����AD7606ԭʼ���ݣ���ʶ�ã���Ϊ��������
%   VarName3�Ǵ�SD���е����MTiԭʼ���ݣ���֤�ã���Ϊfloat�͵�������
%   VarName4�Ǵ�SD���е����AD7606ԭʼ���ݣ���֤�ã���Ϊ��������
%   M���ӿռ��㷨�õ���ϵͳģ��

addpath(genpath('../'));
clearvars -EXCEPT VarName1 VarName2 VarName3 VarName4

%%%%������Ϣ����%%%%%
T = 0.02;
Fs = 1 / T;              % ����Ƶ��

%%%%%ɾ��NAN����%%%%%
NaNlocation = find(isnan(VarName2));
VarName1(NaNlocation)=[];
VarName2(NaNlocation)=[];

%%%%%��ȡ�����������%%%%%
[beta, diff_MTi, beta_filter] = Get_JY01_AD7606_MTi(VarName1, VarName2, T);

%%%%%SIM��ʶ%%%%%
data_length = min(length(diff_MTi), length(beta_filter));
[A, B, C, D] = SIM_Deterministic(beta_filter(1:data_length), diff_MTi(1:data_length), 20, 4);
%[A_SIM_MOESP, B_SIM_MOESP, C_SIM_MOESP, D_SIM_MOESP] = SIM_MOESP(beta_filter(1:data_length), diff_MTi(1:data_length), 40, 2);
% [A_SIM_PCA, B_SIM_PCA, C_SIM_PCA, D_SIM_PCA] = SIM_PCA(beta_filter(1:data_length), diff_MTi(1:data_length), 60, 2);
M = ss(A, B, C, D);
% M_SIM_MOESP = ss(A_SIM_MOESP, B_SIM_MOESP, C_SIM_MOESP, D_SIM_MOESP);
% M_SIM_PCA = ss(A_SIM_PCA, B_SIM_PCA, C_SIM_PCA, D_SIM_PCA);

% %%%%%�����Ҫ�������ݼ�������֤��ȡ�������ע��%%%%%
% %%%%%ɾ��NAN����%%%%%
NaNlocation = find(isnan(VarName4));
VarName3(NaNlocation)=[];
VarName4(NaNlocation)=[];

%%%%%��ȡ�����������%%%%%
[beta_verify, diff_MTi_verify, beta_filter_verify] = Get_JY01_AD7606_MTi(VarName3, VarName4, T);

YP = dlsim(A, B, C, D, diff_MTi_verify);
% YP_SIM_MOESP = dlsim(A_SIM_MOESP, B_SIM_MOESP, C_SIM_MOESP, D_SIM_MOESP, diff_MTi_verify);
% YP_SIM_PCA = dlsim(A_SIM_PCA, B_SIM_PCA, C_SIM_PCA, D_SIM_PCA, diff_MTi_verify);
plot(YP,'r');
hold on
% plot(YP_SIM_MOESP,'o-g');
% plot(YP_SIM_PCA,'*-b');
plot(beta_filter_verify,'k');
legend('SIM��ʶ���','��ʵ���');
title('��ʶģ�͵����');