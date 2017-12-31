function H = blkhank(y,i,j)
%�����ֿ�Hankel����
%   y������������һ������Ϊ���ݵ�ά�ȣ�����Ϊ���ݼ��ĳ���
%   i��Hankel�������
%   j��Hankel�������
%   H�ǹ����õ���Hankel����

[l,nd] = size(y);
if nd < l
    y = y';
    [l,nd] = size(y);
end

% ���ά��
if i < 0
    error('blkHank: i should be positive');
end
if j < 0
    error('blkHank: j should be positive');
end
if j > nd-i+1
    error('blkHank: j too big');
end

% �����ֿ�Hankel����
H=zeros(l*i,j);
for k=1:i
	H((k-1)*l+1:k*l,:)=y(:,k:k+j-1);
end
