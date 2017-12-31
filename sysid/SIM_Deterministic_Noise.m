clc;
clear;
N = 100000;
0;
u = randn(N,2);  
e = randn(N,2);
noise_amp = 10;
u = u + noise_amp * e;
a = [0.67 0.67 0 0;-0.67 0.67 0 0;0 0 -0.67 -0.67;0 0 0.67 -0.67];
b = [0.6598 -0.5256;1.9698 0.4845;4.3171 -0.4879;-0.2644 -0.4316];
c = [-0.5749 1.0751 -0.5225 0.183;-0.2977 0.1543 0.1159 0.0982];
d = [0.7139 0.1174;-0.3131 0.2878];
sys_real = ss(a,b,c,d);
y = dlsim(a,b,c,d,u);
y = y + noise_amp * randn(N,2);
n = 4;
i = 10;

addpath(genpath('../'));


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
diag_s = diag(S);

%   �״α�ʶ
if(isempty(n))
    x = 1:1:l * i;
    figure(gcf);
    subplot;
    bar(x, diag_s);
    axis([0, length(diag_s) + 1, 10^(floor(log10(min(diag_s)))), 10^(ceil(log10(max(diag_s))))]);
    title('����ֵ');
    xlabel('�״�');
    n = input('ϵͳ�״�ӦΪ��');
end

U1 = U(:, 1:n);
gam  = U1 * diag(sqrt(diag_s(1:n)));
gamm = U1(1:l * (i - 1), :)*diag(sqrt(diag_s(1:n)));

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

test = pinv(U1(1:l * i, :)*diag(sqrt(diag_s(1:n)))) * Ob;
left=[test(:,2:60);y(:,11:69)];
right = [A B;C D]*[test(:,1:59);u(:,10:68)];
resid = left - right;
resid_w=resid(1:n/2,:);
resid_v=resid(n/2+1:4,:);
noise = [resid_w;resid_v]*[resid_w' resid_v'] / j;

y_iden = dlsim(A,B,C,D,u);
sys_iden = ss(A,B,C,D);
figure(1)
h = bodeplot(sys_real,'*-r',sys_iden,'o-g');
p = getoptions(h); 
p.PhaseMatching = 'on'; 
setoptions(h,p); % Update the Bode plot
legend('��ֵ', '����SIM');
