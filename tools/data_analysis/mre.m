function [mre_value] = mre(y_test, y)
%����ƽ��������
%   y_test�ǲ���ֵ����
%   y����ֵ����
%   mre_value�ǲ���ֵ����ֵ֮���ƽ��������

e = y_test - y;
mre_value = sqrt(sum(e.^2) / sum(y.^2));

end

