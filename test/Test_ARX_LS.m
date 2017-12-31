%���Ի���ARXģ�͵���С���˱�ʶ�㷨
%   VarName1�Ǵ�SD���е����MTiԭʼ���ݣ���ʶ�ã���Ϊfloat�͵�������
%   VarName2�Ǵ�SD���е����AD7606ԭʼ���ݣ���ʶ�ã���Ϊ��������
%   VarName3�Ǵ�SD���е����MTiԭʼ���ݣ���֤�ã���Ϊfloat�͵�������
%   VarName4�Ǵ�SD���е����AD7606ԭʼ���ݣ���֤�ã���Ϊ��������
%   M����С���˷��õ���ϵͳģ��

addpath(genpath('../'));
clearvars -EXCEPT VarName1 VarName2 VarName3 VarName4

%%%%������Ϣ����%%%%%
T = 0.02;
Fs = 1 / T;              % ����Ƶ��

%%%%%ɾ��NAN����%%%%%
NaNlocation = find(isnan(VarName1));
VarName1(NaNlocation)=[];
VarName2(NaNlocation)=[];

%%%%%��ȡ�����������%%%%%
[beta, diff_MTi, beta_filter] = Get_JY01_AD7606_MTi(VarName1, VarName2, T);

%%%%%��С���˱�ʶ%%%%%
data_length = min(length(diff_MTi), length(beta_filter));
M = ARX_LS_SYSID(diff_MTi(1:data_length), beta_filter(1:data_length), Fs, round(0.8*length(diff_MTi)));

%%%%%�����Ҫ�������ݼ�������֤��ȡ�������ע��%%%%%
%%%%%ɾ��NAN����%%%%%
NaNlocation = find(isnan(VarName3));
VarName3(NaNlocation)=[];
VarName4(NaNlocation)=[];

%%%%%��ȡ�����������%%%%%
[beta_verify, diff_MTi_verify, beta_filter_verify] = Get_JY01_AD7606_MTi(VarName3, VarName4, T);

%%%%%�������%%%%%
YP = ARX_LS_SYSID_Verify(diff_MTi_verify, beta_filter_verify(1:length(diff_MTi_verify)), Fs, M);
plot(YP,'r');
hold on
plot(beta_filter_verify,'b');
legend('��ʶ���','��ʵ���');
title('��ʶģ�͵����');

