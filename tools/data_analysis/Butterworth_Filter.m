function [y, H] = Butterworth_Filter(u, Fs, fp, fs, Rp, As)
%Butterworth Filter.
%   u��ԭʼ���ݣ�Ϊ���У����У�����
%   Fs�ǲ���Ƶ�ʣ���λHz
%   fs�������ֹƵ�ʣ���λHz
%   fp��ͨ����ֹƵ�ʣ���λHz
%   Rp��ͨ�����˥��
%   As�������С˥��
%   y���˲������ݣ�Ϊ���У����У�������������u��ͬ
%   H���˲������������ڻ����˲���Ƶ������
%   ���õ�ͨ������Fs=5000��fp=1��fs=5��Rp=1dB��As=30dB

wp = fp / Fs;
ws = fs / Fs;
[N, wc] = buttord(wp, ws, Rp, As); %�����ʲ����Ľ�����3dB��ֹƵ��
[B, A] = butter(N, wc); %�����˲���ϵͳ�������ӷ�ĸ����ʽ
[H, W] = freqz(B, A);

y = filter(B, A, u);
