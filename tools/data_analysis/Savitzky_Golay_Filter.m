function y = Savitzky_Golay_Filter(u, N, F)
%Savitzky-Golay Filter.
%   u��ԭʼ���ݣ�Ϊ���У����У�����
%   N���˲�������
%   F���˲������ڿ�ȣ�����Ϊ����
%   y���˲������ݣ�Ϊ���У����У����������ȱ�u��(F+1)/2

[~, g] = sgolay(N, F);   % ����S-G�˲�������

HalfWin  = ((F + 1) / 2) - 1; %�봰�ڿ��
y = zeros(1, length(u) - (F+1)/2);
for n = (F + 1) / 2 : length(u) - (F + 1) / 2
  y(n) = dot(g(:, 1), u(n - HalfWin : n + HalfWin));
end
%plot([u(1 : length(y)), y']);