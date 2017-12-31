function [A, B, C, D]=SIM_PCA(y,u,i,n)
%�����ӿռ䷽����SIMPCA��������������ݽ��б�ʶ
%�ο����� A new subspace identification approach based on principal component analysis
%   y���������
%   u����������
%   i����ʷ���ݵ�������Ҳ���Ƿֿ�Hankel����������1/2
%   n��ϵͳ����
%   A,B,C,D�Ǳ�ʶ�õ���״̬�ռ����

%   TODO�����ӽ״α�ʶ����

addpath(genpath('../'));

%   �ж��������
if (nargin < 4);
    error('�����������');
end

[m, num_u] = size(u);
if(m > num_u)
    u = u';
    [m, num_u] = size(u);
end

[l, num_y] = size(y);
if(l > num_y)
    y = y';
    [l, num_y] = size(y);
end

if(num_u ~= num_y)
    error('��������������ȱ������');
end

num = num_u;
j = num - 2 * i + 1;

%   ����Hankel����
Y = blkhank(y, 2 * i, j);
U = blkhank(u, 2 * i, j);
Yp = Y(1:i * l, :);
Yf = Y(i * l + 1:2 * i * l, :);
Up = U(1:i * m, :);
Uf = U(i * m + 1:2 * i * m, :);
Zp = [Yp; Up];  %ע���������SIM��ͬ
Zf = [Yf; Uf];

%����SVD����PCA�ֽ⣨�ο�����An Extented Closed-loop Subspace Identification Method for Error-in-variables System ʽ��27����
[U, S, V] = svd((Zf * (Zp)') / j);


P_resid = U(:, (m * i) + n + 1:end); %��ȡ��������غɾ���
P_resid_y = P_resid(1:l * i, 1:l*i-n);
P_resid_u = P_resid(l * i + 1:(l + m) * i, 1:l*i-n);
gammaf_per = P_resid_y'; %ʽ��28���У�Mȡ��λ��
gammaf = orthcomp(gammaf_per'); %����������
%gammaf = null(gammaf_per); %��������������һ�ַ�������ֵ�����ͬ������A,B,C,D��Ҳ��ͬ����ϵͳ���Ի���һ��

%   ����A��C
C = gammaf(1:l, 1:n);
A = pinv(gammaf(1:l * (i - 1), 1:n)) * gammaf(l + 1:l * i, 1:n);

%   ׼������B��D���ο�ʽ��32��-��36��
phi = -P_resid_y';
Phi = P_resid_u';
Lhs = zeros((l * i - n) * i, l * i);
Rhs = zeros((l * i - n) * i, m);
for k = 1 : i
    Rhs((k - 1) * (l * i - n) + 1:k * (l * i - n), :) = Phi(:, (k - 1) * m + 1:k * m);
    Lhs((k - 1) * (l * i - n) + 1:k * (l * i - n), 1:(i - k + 1) * l) = phi(:,(k - 1) * l + 1:l * i);
end

%   �����С����
Hf = Lhs \ Rhs;
sol = pinv([eye(l) zeros(l, n); zeros(l * (i - 1), l) gammaf(1:l * (i - 1), 1:n)]) * Hf; %ʽ��40��

%   �õ�B��D����
D = sol(1:l, :);
B = sol(l + 1:l + n, :);
