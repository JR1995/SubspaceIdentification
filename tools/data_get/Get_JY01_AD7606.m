function [beta, beta_filter] = Get_JY01_AD7606(VarName1, T)
%���ڵõ�����AD7606�ɼ���JY01���ݣ������г�������
%   VarName1�Ǵ�SD���е����AD7606ԭʼ���ݣ�Ϊ��������
%   T�ǲ���ʱ��
%   beta��AD����ֱ��ת���õ��ĽǼ��ٶ�����
%   beta_filter�Ƕ�beta�����˲���õ�������

addpath(genpath('../'));

%%%%������Ϣ����%%%%%
Fs = 1 / T;              % ����Ƶ��
L = length(VarName1);     % �źų���
time = T * (0:1:L-1);


%%%%%ADԭʼ���ݣ�JY01������%%%%%
beta = JY01_ADValue_Process(VarName1, 5);
figure;
plot(time, beta,'r');
title('�Ǽ��ٶ��ź�');

%%%%%AD���ð�����˹�˲���%%%%%
Rp = 1;As = 30;
fp = 10;fs = 20;
[beta_filter, H] = Butterworth_Filter(beta, Fs, fp, fs, Rp, As);

% figure
% plot(W, abs(H))
% title('�˲���Ƶ������');

figure
plot(time, beta_filter);
title('JY01�˲����');

%%%%%����JY01��fft%%%%%
Cal_FFT(beta, Fs);
