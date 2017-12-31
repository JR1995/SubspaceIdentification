%SISO�������ݣ����Ը����͵��ӿռ��㷨�������Ʋ���ͼ
%   SIM_Deterministic��Subspace identification for linear system�еĻ����ӿռ��㷨
%   SIM_MOESP��Subspace identification for System Identification�е�Multivariable Output Error State Space�㷨
%   SIM_PCA��A new subspace identification approach based on principal component analysis�еĻ���PCA���ӿռ��㷨

clear;
addpath(genpath('../'));

N = 10000;
u = randn(N, 1);
u_test =u + 0.01 * randn(N, 1);
a = [0.6 0.4;-0.4 0.6];
b = [0;1];
c = [1 0.5];
d = [0];
y = dlsim(a, b, c, d, u_test);
y_test = y + 0.01 * randn(N, 1);
k = 10;

[A_SIM_D, B_SIM_D, C_SIM_D, D_SIM_D] = SIM_Deterministic(y_test, u_test, 100);
[A_SIM_MOESP, B_SIM_MOESP, C_SIM_MOESP, D_SIM_MOESP] = SIM_MOESP(y_test, u_test, 200, 2);
[A_SIM_PCA, B_SIM_PCA, C_SIM_PCA, D_SIM_PCA] = SIM_PCA(y_test, u_test, 100, 2);
sys_real = ss(a,b,c,d);
sys_sim_d = ss(A_SIM_D, B_SIM_D, C_SIM_D, D_SIM_D);
% sys_sim_mosep = ss(A_SIM_MOESP, B_SIM_MOESP, C_SIM_MOESP, D_SIM_MOESP);
% sys_sim_pca = ss(A_SIM_PCA, B_SIM_PCA, C_SIM_PCA, D_SIM_PCA);


figure(1)
h = bodeplot(sys_real,'r',sys_sim_d,'*-g');%,sys_sim_mosep,'b',sys_sim_pca,'y');
p = getoptions(h); 
p.PhaseMatching = 'on'; 
setoptions(h,p); % Update the Bode plot
legend('��ֵ', '�ӿռ��ʶģ��');%, 'MOESP', 'SIM-PCA');

% figure(2)
% pzmap(sys_real,'r');
% hold on
% pzmap(sys_sim_d,'b');
% legend('��ֵ', '�ӿռ��ʶģ��');

 y_SIM_D = dlsim(A_SIM_D, B_SIM_D, C_SIM_D, D_SIM_D, u_test);
 figure(3)
 plot(y_test, '+-r');
 hold on
 plot(y_SIM_D, '*-g');
 legend('��ֵ', '�ӿռ��ʶģ��');
