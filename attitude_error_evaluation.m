function [sigma_BR,B_omega_BR] = attitude_error_evaluation(sigma_BN_0,B_omega_BN_0,Ref_DCM,Ref_omega)

%Ref_DCM and Ref_omegas should be at time t = 0secs
%Time = 0

B_omega_BN = B_omega_BN_0;
N_omega_RN = Ref_omega;
B_omega_RN = MRP2C(sigma_BN_0)*N_omega_RN;
B_omega_BR = B_omega_BN - B_omega_RN;

sigma_BN = sigma_BN_0;
sigma_BR = C2MRP(MRP2C(sigma_BN)*Ref_DCM');
sigma_BR = switch_mrp(sigma_BR);

end