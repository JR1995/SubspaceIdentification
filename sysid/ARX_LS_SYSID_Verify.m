function YP = ARX_LS_SYSID_Verify(InputData, OutputData, Fs, M)
%����С���˷��õ���ϵͳģ�ͽ�����֤��
%   InputData����������
%   OutputData���������
%   Fs�ǲ���Ƶ�ʣ���λHz
%   M����С���˷��õ���ϵͳģ��
%   YP��InputData��M�����µõ������

testdata2=iddata(InputData, OutputData, 1 / Fs);
testdata2.inputname = 'MEMS���ݽ���ĽǼ��ٶ�';
testdata2.outputname = '�Ǽ��ٶȼ�����ĵ�ѹ';
ze2 = testdata2(1 : length(InputData));
ze2 = dtrend(ze2);
%ze2=idfilt(ze2, 2, 0.1);

figure,plot(ze2);
figure,compare(ze2,M);
figure,resid(M,ze2);

%ϵͳ����
YP = idsim(InputData, M);
