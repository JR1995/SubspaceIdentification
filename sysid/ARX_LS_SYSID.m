function M = ARX_LS_SYSID(InputData, OutputData, Fs, TrainLength)
%������С���˷�������ARXģ�ͣ���ϵͳ���б�ʶ��
%   InputData����������
%   OutputData���������
%   Fs�ǲ���Ƶ�ʣ���λHz
%   TrainLength������AIC׼��õ�ϵͳ�״���������ݳ���

testdata=iddata(InputData, OutputData, 1 / Fs);
testdata.inputname = 'MEMS���ݽ���ĽǼ��ٶ�';
testdata.outputname = '�Ǽ��ٶȼ�����ĵ�ѹ';
ze1 = testdata(1 : length(InputData));
ze1 = dtrend(ze1);
%ze1 = idfilt(ze1, 2, 0.1);

%������ʵĽṹ
NN = struc(1:10, 1:10, 1:10);
V = arxstruc(testdata(1 : TrainLength),testdata(TrainLength + 1 : length(InputData)), NN);
nn = selstruc(V, 'aic');
M = arx(ze1, nn);

figure,plot(ze1);
figure,compare(ze1,M);
figure,resid(M,ze1);