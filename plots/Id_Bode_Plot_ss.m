function [] = Id_Bode_Plot_ss(A, B, C, D)
%����Bodeͼʾ��
%   sys�Ǵ�����ϵͳ

sys = ss(A, B, C, D);
hfigure = figure(1);
h = bodeplot(sys, 'b');
p = getoptions(h); 
p.PhaseMatching = 'on';
p.FreqUnits = 'Hz';
setoptions(h,p);
set(hfigure, 'MenuBar', 'none');
set(hfigure, 'ToolBar', 'figure');