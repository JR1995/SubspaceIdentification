NaNlocation = find(isnan(VarName2));
VarName1(NaNlocation)=[];
VarName2(NaNlocation)=[];
VarName3(NaNlocation)=[];
VarName4(NaNlocation)=[];
VarName5(NaNlocation)=[];

%%%%������Ϣ����%%%%%
Fs = 250; % ����Ƶ��
T = 1 / Fs;              % ����ʱ��
L = length(VarName1);     % �źų���
time = T * (0:1:L-1);

a0_x=2*9.8*VarName1/32768;
a0_y=2*9.8*VarName2/32768;
a1_x=2*9.8*VarName3/32768;
a2_y=2*9.8*VarName4/32768;

aa=((a2_y-a0_y)-(a1_x-a0_x))*360/2/pi/0.4;
plot(time, aa);