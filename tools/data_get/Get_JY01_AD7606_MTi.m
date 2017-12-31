function [beta, diff_MTi, beta_filter, VarName1] = Get_JY01_AD7606_MTi(VarName1, VarName2, T, filter_method)
%���ڵõ�����AD7606�ɼ���JY01���ݣ��Լ�����MTi���Ե���ģ��õ������������ݣ����г�������
%   VarName1�Ǵ�SD���е����MTiԭʼ���ݣ�Ϊfloat�͵�������
%   VarName2�Ǵ�SD���е����AD7606ԭʼ���ݣ�Ϊ��������
%   T�ǲ���ʱ��
%   ���filter_method�Ƕ�JY01�źŽ����˲��ķ�������ѡ���У�'butterworth','S-G','kalman','FIR'��Ĭ��ֵΪ'butterworth'
%   beta��AD����ֱ��ת���õ��ĽǼ��ٶ�����
%   beta_filter�Ƕ�beta�����˲���õ�������
%   diff_MTi��MTi����΢�ֵõ��ĽǼ��ٶ�����
%   VarName1��MTiԭʼ����

addpath(genpath('../'));

%   �ж�������������filter_methodδ�ƶ���Ĭ��Ϊ������˹��ͨ�˲���
if (nargin < 4);
    filter_method = 'butterworth';
end

%%%%������Ϣ����%%%%%
Fs = 1 / T;              % ����Ƶ��
L = length(VarName1);     % �źų���
time = T * (0:1:L-1);

%%%%%Mtiԭʼ����%%%%%
plot(time, VarName1)
title('Mtiԭʼ����');

% %%%%%MTi���ð�����˹�˲���%%%%%
% Rp = 1;As = 30;
% fp = 10;fs = 20;
% [MTi_filter, H_MTi] = Butterworth_Filter(VarName1, Fs, fp, fs, Rp, As);

%%%%%Mti���ݴ���%%%%%
diff_MTi = MTi_Process(VarName1, 'center')  * 180 / pi / T;
figure
plot(time(1:length(diff_MTi)), diff_MTi, 'b');


%%%%%ADԭʼ���ݣ�JY01������%%%%%
beta = JY01_ADValue_Process(VarName2, 5);
hold on;
plot(time, beta,'r');
legend('MTi�Ǽ��ٶ��ź�','JY01�Ǽ��ٶ��ź�');
title('���ֽǼ��ٶ��ź�');

%%%%%�˲�������%%%%%
switch(filter_method)
    case 'butterworth'
        Rp = 1;As = 30;
        fp = 5;fs = 20;
        [beta_filter, H] = Butterworth_Filter(beta, Fs, fp, fs, Rp, As);
        % figure
        % plot(W, abs(H))
        % title('�˲���Ƶ������');
    case 'S-G'
        beta_filter = Savitzky_Golay_Filter(beta, 3, 15);
    case 'kalman'
    case 'FIR'
        Rp = 1;As = 30;
        fp = 5;fs = 20;
        beta_filter = FIR_Filter(beta, Fs, fp, fs, As);
end

figure
plot(time(1:length(beta_filter)), beta_filter);
title('JY01�˲����');

%%%%%����JY01��fft%%%%%
Cal_FFT(beta, Fs);

%%%%%�������%%%%%
err = diff_MTi - beta(1:length(diff_MTi));
figure
plot(time(1:length(diff_MTi)), err);
title('���ֽǼ��ٶ��źŵ����');
