function [A, B, C, D] = SIM_Deterministic(y, u, i, n)
%�����ӿռ䷽��������������ݽ��б�ʶ
%�ο�Subspace identification for linear system 56ҳ��
%   y���������
%   u����������
%   i����ʷ���ݵ�������Ҳ���Ƿֿ�Hankel����������1/2
%   n��ϵͳ���������Բ�ָ��
%   A,B,C,D�Ǳ�ʶ�õ���״̬�ռ����

addpath(genpath('../'));

%   �ж�������������nδ�ƶ���׼�����н״α�ʶ
if (nargin < 4)
    n = [];
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
Wp = [Up; Yp];


%   ����бͶӰ
R = triu(qr([U; Y]'))'; %����QR�ֽ⣬�õ������Ǿ���
R = R(1:2 * i * (m + l), 1:2 * i * (m + l)); %��R������Ϊ����

mi2 = 2 * m * i;

%   бͶӰΪYf/Uf Wp����
Rp = [R(1:m * i,:);R(2 * m * i + 1:(2 * m + l) * i, :)]; % Wp��Ӧ��R��
Rf = R((2 * m + l) * i + 1:2 * (m + l) * i, :); 	% Yf��Ӧ��R��
Ru = R(m * i + 1:2 * m * i, :); 		% Uf��Ӧ��R��


%   Van Overschee�������м���бͶӰ�Ĳ��֣���ʹ�øò���ʱ����Ҫ������Ru�ĵڶ�ά�ȸ�Ϊ1;mi2
% % Perpendicular Future outputs 
% Rfp = [Rf(:,1:mi2) - (Rf(:,1:mi2)/Ru)*Ru,Rf(:,mi2+1:2*(m+l)*i)]; 
% % Perpendicular Past
% Rpp = [Rp(:,1:mi2) - (Rp(:,1:mi2)/Ru)*Ru,Rp(:,mi2+1:2*(m+l)*i)]; 
% 
% if (norm(Rpp(:,(2*m+l)*i-2*l:(2*m+l)*i),'fro')) < 1e-10
%     Ob  = (Rfp*pinv(Rpp')')*Rp;
% else
%     Ob = (Rfp/Rpp)*Rp;
% end

%   �ο�Subspace Identification For Linear Systems ��166ҳʽ��6.1�������ǽ����Van
%   Overschee�����̲�ͬ��ԭ��δ֪��
%   ���⣬���й�ʽ����бͶӰ�ĵ�������C������������Rc������˾���ά�Ȳ�ͬ��
Ob1 = Rf * (eye(2 * (m + l) * i) - Ru' * pinv(Ru * Ru') * Ru);
Ob2 = pinv(Rp * (eye(2 * (m + l) * i) - Ru' * pinv(Ru * Ru') * Ru));
Ob = Ob1 * Ob2 * Rp;


%   ����бͶӰ��SVD�ֽ�
[U,S,~] = svd(Ob);
ss = diag(S);

%   �״α�ʶ
if(isempty(n))
    x = 1:1:l * i;
    figure(gcf);
    subplot;
    bar(x, ss);
    set(gca,'XLim',[0,10.5]);
    %axis([0, length(ss) + 1, 10^(floor(log10(min(ss)))), 10^(ceil(log10(max(ss))))]);
    title('����ֵ');
    xlabel('�״�');
    n = input('ϵͳ�״�ӦΪ��');
end

U1 = U(:, 1:n);
gam  = U1 * diag(sqrt(ss(1:n)));
gamm = U1(1:l * (i - 1), :)*diag(sqrt(ss(1:n)));

gam_per  = U(:,n+1:l*i)'; 		% ��������
gamm_inv = pinv(gamm); 			% ��α��
A = gamm_inv * gam(l + 1:l * i, :);
C = gam(1:l, :);

%   ����M��L����Ϊ���B��D��׼��
M = gam_per * (R((2 * m + l) * i + 1:2 * (m + l) * i, :) / R(m * i + 1:2 * m * i, :));
L = gam_per;

%   �ο�Subspace Identification For Linear Systems ��54ҳ
Lhs = zeros(i * (l * i - n), m);
Rhs = zeros(i * (l * i - n), l * i);
for k = 1:i
  Lhs((k - 1) * (l * i - n) + 1:k * (l * i - n), :) = M(:, (k - 1) * m + 1:k * m);
  Rhs((k - 1) * (l * i - n) + 1:k * (l * i - n), 1:(i - k + 1) * l) = L(:, (k - 1) * l + 1:l * i);
end
Rhs = Rhs*[eye(l), zeros(l, n);zeros(l * (i - 1), l), gamm];

%   �����С����
sol = Rhs \ Lhs;

%   �õ�B��D����
B = sol(l + 1:l + n, :);
D = sol(1 : l, :);
