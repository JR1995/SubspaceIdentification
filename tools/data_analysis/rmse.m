function [rmse_value] = rmse(y_test, y)
%������������
%   y_test�ǲ���ֵ����
%   y����ֵ����
%   rmse_value�ǲ���ֵ����ֵ֮��ľ���ֵ���

rmse_value = sqrt(mean((y_test - y).^2));

end

