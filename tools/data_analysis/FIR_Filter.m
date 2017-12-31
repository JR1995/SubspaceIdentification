function y = FIR_Filter(u, Fs, fp, fs, As)
%Finite Impulse Response Filter�������޳���λ�弤��Ӧ�˲�����
%   u��ԭʼ���ݣ�Ϊ���У����У�����
%   Fs�ǲ���Ƶ�ʣ���λHz
%   fs�������ֹƵ�ʣ���λHz
%   fp��ͨ����ֹƵ�ʣ���λHz
%   Rp��ͨ�����˥��
%   As�������С˥��
%   y���˲������ݣ�Ϊ���У����У�������������u��ͬ
%   ���õ�ͨ������Fs=5000��fp=1��fs=5��Rp=1dB��As=30dB

wp = 2 * fp * pi / Fs; %���һ������ͨ����ֹƵ��,
ws = 2 * fs * pi / Fs; %���һ�����������ʼƵ�� 
Bt = ws - wp; %����ɴ���
alpha = 0.5842 * (As - 21)^0.4 + 0.07886 * (As - 21); %����kaiser���Ŀ��Ʋ���
M = ceil((As - 8) / 2.285 / Bt); %����˲����Ľ���
wc = (ws + wp) / 2 / pi; %���˲����Ľ�ֹƵ�ʲ�����pi��һ�� 
hk = fir1(M, wc, kaiser(M + 1, alpha)); %���� fir1 ��������˲�����ϵ��
[Hk, ~] = freqz(hk,1); %����Ƶ����Ӧ
mag = abs(Hk); %���Ƶ����
db = 20 * log10(mag / max(mag)); %��Ϊ�ֱ�ֵ
db1 = db';
% figure, plot(0 : pi / 511 : pi, db1), grid on
% axis([0, 4.0, -80, 5]), title('fir����')

y = filter(hk, 1, u);
% figure
% plot(y)
