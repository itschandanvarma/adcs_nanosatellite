function [R_sN,N_omega_R_sN] = sun_pointing_frame()

%This orientation is independent on time. This is only dependent on 
% body and inertial frame and will be the same for all conditions
R_sN = [-1 0 0;0 0 1;0 1 0];
N_omega_R_sN = [0;0;0];

end