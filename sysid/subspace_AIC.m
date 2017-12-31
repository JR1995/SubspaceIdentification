function [AIC] = subspace_AIC(A, B, C, D, y, u, i, n)
%�����ӿռ��ʶ��AIC�״α�ʶ
%   A,B,C,D�ǽ״�Ϊn�ı�ʶϵͳ��ϵͳ����
%   y����ʵ�������
%   u����������
%   i�Ƿֿ�Hankel��������
%   n��ϵͳ�״�

%   TODO��������ò��������
%   TODO����Ӷ�ά֧��

[l,num_y] = size(y);
if (num_y < l)
    y = y';
    [l, num_y] = size(y);
end

[m, num_u] = size(u);
if (num_u < m)
    u = u';
    [m, num_u] = size(u);
end

j = num_u - 2 * i + 1;
  
%   ����Hankel����
Y = blkhank(y, 2 * i, j);
U = blkhank(u, 2 * i, j);
Yf = Y(i * l + 1:2 * i * l, :);
Uf = U(i * m + 1:2 * i * m, :);
Zf = [Uf;Yf];

%   �������A����������ʽ
polyA = poly(A);
alpha = zeros(l, l*i);
polyB = fliplr(polyA);
polyB((polyB==0))=[];
for temp = 1 : length(polyB)
    alpha(:,(temp-1)*l+1:temp*l) = polyB(temp) * eye(l);
end
%alpha(1:length(polyA)) = fliplr(polyA);

%   ����toeplitz����Hf
% c = zeros(l, i);
% c(1:l, 1:l) = D;
% for temp = 2 : i
%     c(1:l, (temp-1)*l+1:temp*l) = C * A^(temp - 2) * B;
% end
% 
% r = zeros(l, i);
% r(1:l,1:l) = c(1:l,1:l);
% Hf = toeplitz(c, r);

Hf = zeros(l*i,l*i);
for temp = 1 : i
    for temp1 = 1 :temp
        if(temp1 == temp)
            Hf((temp-1)*l+1:temp*l,(temp-1)*l+1:temp*l)=D;
        else
            Hf((temp-1)*l+1:temp*l,(temp1-1)*l+1:temp1*l)=C * A^(temp - temp1 - 1) * B;
        end
    end
end



%   �����������
%e = zeros(1, j);
e = alpha * [-Hf eye(i*l)] * Zf;
% for temp = 1:j
%     e(1, temp) = alpha * [-Hf eye(i)] * Zf(:, temp);
% end

%   ����AICֵ
AIC = num_u * (1 + log(2 * pi)) + log(abs(sum(sum(e' * e)) / num_u)) + 2 * num_u * (n ^ 2 + 2 * n) / (num_u - (n ^ 2 + 2 * n + 1));
