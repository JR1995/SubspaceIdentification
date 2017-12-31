function [AIC] = Another_subspace_AIC(u, y, ss, n)
%��һ��AIC���壬�ο���Subspace identification using the integration of MOSEP and N4SID methods applied to the Shell benchmark of a distillation column��������С���˷�������ARXģ�ͣ���ϵͳ���б�ʶ��
%   u����������
%   y��ʵ���������
%   ss�ǽ״�n�µõ��ı�ʶϵͳ
%   n��ϵͳ�״�

nu = length(u);
y_hat = dlsim(ss.A, ss.B, ss.C, ss.D, u);
e = y - y_hat;

AIC = nu * log(var(e)) + 4 * nu * (n^2 + 2 * n) / (nu - (n^2 + 2 * n + 1));

end