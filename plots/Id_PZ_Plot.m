function [] = Id_PZ_Plot(sys)
%�����㼫��ͼʾ��
%   sys�Ǵ�����ϵͳ

figure(1)
pzmap(sys,'b');
grid on