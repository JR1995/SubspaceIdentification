clearvars -EXCEPT VarName1 VarName2
%%%%%ɾ��NAN����%%%%%
NaNlocation = find(isnan(VarName1));
VarName1(NaNlocation)=[];
VarName2(NaNlocation)=[];


%%%%������Ϣ����%%%%%
T = 0.0005; % ����ʱ��
Fs = 1 / T;              % ����Ƶ��
L = length(VarName1);     % �źų���
time = T * (0:1:L-1);


%%%%%ADԭʼ���ݣ�JY01������%%%%%
for i = 1 : L
    if(VarName1(i) > 32768)
        VarName1(i) = VarName1(i)-65536;
    end
end
Vout = VarName1 * 5 / 32768 * 749 / 249;
beta = Vout * 1000 / 0.5;

hold on
plot(time, beta,'r');
title('�Ǽ��ٶ��ź�');

%%%%%AD���ð�����˹�˲���%%%%%
Rp = 1;As = 30;
fp = 20;fs = 30;
wp = fp / Fs;
ws = fs / Fs;
[N, wc] = buttord(wp,ws,Rp,As);%�����ʲ����Ľ�����3dB��ֹƵ��
[B, A] = butter(N, wc);%�����˲���ϵͳ�������ӷ�ĸ����ʽ
[H, W] = freqz(B, A);
%�˲�����������
figure
plot(W, abs(H))
title('�˲���Ƶ������');
beta_filter = filter(B, A, beta);
figure
plot(time, beta_filter);
title('JY01�˲����');


%%%%%����JY01��fft%%%%%
NFFT = 2^nextpow2(L);   % ��L���ڵ���һ��2��ָ��
Y = fft(beta, NFFT) / L;
f = Fs / 2 * linspace(0, 1, NFFT / 2 + 1) / 10;
figure
plot(f,2*abs(Y(1:NFFT/2+1)))
title('JY01��fft');

figure
A2Poutput = VarName2 / 32768 * 5;
P=((A2Poutput-0.5)*5-10)*249;
beta = Vout  * 1000 / 0.5;
A2P_beta=(A2Poutput-mean(A2Poutput)) * 1000 / 0.05;
plot(A2P_beta,'DisplayName','A2P_beta');hold all;plot(beta,'DisplayName','beta');hold off;