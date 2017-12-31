function [A, B, C, D] = SIM_MOESP(y, u, i, n)
%�����ӿռ䷽��(Multivariable Output Error State Space)������������ݽ��б�ʶ
%�ο�Subspace identification for System Identification 159ҳ��
%   y���������
%   u����������
%   i�Ƿֿ�Hankel��������
%   n��ϵͳ���������Բ�ָ��
%   A,B,C,D�Ǳ�ʶ�õ���״̬�ռ����

addpath(genpath('../'));

%   �ж�������������nδ�ƶ���׼�����н״α�ʶ
if (nargin < 4);
    n = [];
end

[num_u, m]=size(u);
if(m > num_u)
    u = u';
    [num_u, m]=size(u);
end

[num_y, l]=size(y);
if(l > num_y)
    y = y';
    [num_y, l]=size(y);
end

if num_u~=num_y
    error('��������������ȱ������')
end

%   ����Hankel����
Y = blkhank(y, i, num_y - i + 1);
U = blkhank(u, i, num_y - i + 1);

%   LQ�ֽ�
L = triu(qr([U;Y]'))';
L = L(1:i * (m + l), 1:i * (m + l));

%   SVD
L22 = L(i*l+1:end,i*l+1:end);
[U1,S1]=svd(L22);
ss = diag(S1);

%   �״α�ʶ
if(isempty(n))
    x = 1:1:l * i;
    figure();
    subplot;
    bar(x, ss);
    axis([0, length(ss) + 1, 10^(floor(log10(min(ss)))), 10^(ceil(log10(max(ss))))]);
    title('����ֵ');
    xlabel('�״�');
    n = input('ϵͳ�״�ӦΪ��');
end


% C and A
Ok = U1(:, 1:n) * diag(sqrt(ss(1:n)));
C = Ok(1:l, :);
A = Ok(1:l * (i - 1), :) \ Ok(l + 1:i * l, :);

% B and D ʽ(6.43)��(6.44)
U2 = U1(:, n + 1:end)';
L11 = L(1:i * m, 1:i * m);
L21 = L(i * m + 1:end,1:i * m);
M1 = U2 * L21 / L11;
M = zeros((l * i - n) * i, m);
L = zeros((l * i - n) * i, l + n);
for k = 1:i
    M((k - 1) * (l * i - n) + 1:k * (l * i - n), :) = M1(:, (k - 1) * m + 1:k * m);
    L((k - 1) * (l * i - n) + 1:k * (l * i - n), :) = [U2(:, (k - 1) * l + 1:k * l) U2(:, k * l + 1:end) * Ok(1:end - k * l, :)];
end

DB = L \ M;
D = DB(1 : l, :);
B = DB(l + 1:end, :);
end
