%�ű��ļ������ڲ���PCA

load hald;
[coeff,score,latent,tsquared,explained]= pca(ingredients);
AMean = mean(ingredients);%�����ݾ�ֵ
AStd = std(ingredients);%�����ݱ�׼��
B = (ingredients - repmat(AMean,[13 1]))./ repmat(AStd,[13 1]);%��ȥ��ֵ���ԭʼ����
C = (score(:,1:2))*coeff(:,1:2)' + (score(:,3:4))*coeff(:,3:4)';%����pca�ֽ�:X=PT^{T}+P'T'^{T}