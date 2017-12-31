function[f, ys] = Cal_FFT(u, Fs)
%����ʱ�����е�FFT����ͼ��
%   u��ԭʼ���ݣ�Ϊ���У����У�����
%   Fs�ǲ���Ƶ�ʣ���λHz

L = length(u);
NFFT = 2^nextpow2(L);   % ��L���ڵ���һ��2��ָ��
Y = fft(u, NFFT) / L;
f = Fs / 2 * linspace(0, 1, NFFT / 2 + 1);
ys = 2 * abs(Y(1 : NFFT / 2 + 1));
figure
plot(f, ys)
title('�����źŵĵ��������')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

end
  