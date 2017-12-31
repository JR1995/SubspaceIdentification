function y = MTi_Process(u, method)
%��MTi��ȡ������������ת��Ϊ�Ǽ��ٶ�
%   u��MTi���ݣ�Ϊ��������
%   method�ǲ�ַ�������ѡֵ������'center'�����Ĳ��,'back'��������
%   y�ǽǼ��ٶ����ݣ�Ϊ����������'center'ʱ�����ȱ�u��2��'back'ʱ�����ȱ�u��1

L = length(u);
switch(method)
    case 'center'
        y = zeros(L-2, 1);
        for i = 2:L-1
            y(i-1) = (u(i + 1) - u(i - 1)) / 2;
        end
    case 'back'
        y = diff(u);
end