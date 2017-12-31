function [u_test, y_test] = Monte_Carlo_Simulation(a, b, c, d, N, err_u, err_y)
%�����������ݣ��Ա�ʶ�㷨���в���
%   a,b,c,d�ǲ���ϵͳ��ϵͳ����
%   N�ǲ������ݳ���
%   err_u�������źŵ�������׼��
%   err_y������źŵ�������׼��
%   u_test�ǲ����������ź�
%   y_test�ǲ���������ź�

%   �ж��������
if (nargin < 5);
    error('�����������');
end
if (isequal(nargin, 5))
    err_u = 0.1;
    err_y = 0.1;
elseif (isequal(nargin, 6))
    err_y = 0.1;
end

[n_u, size_u] = size(b);
[size_y, n_y] = size(c);
if(n_u ~= n_y)
    error('ϵͳ����ά����ƥ��');
end


u = randn(N, size_u);
u_test =u + err_u * randn(N, size_u);
y = dlsim(a, b, c, d, u_test);
y_test = y + err_y * randn(N, size_y);

