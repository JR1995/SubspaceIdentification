function [] = Id_Bode_Plot(sys)
%����Bodeͼʾ��
%   sys�Ǵ�����ϵͳ

figure(1)
h = bodeplot(sys, 'b');
p = getoptions(h); 
p.PhaseMatching = 'on';
p.FreqUnits = 'Hz';
setoptions(h,p);