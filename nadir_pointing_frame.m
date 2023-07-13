function [R_nN,N_omega_R_nN] = nadir_pointing_frame(euler_angles,omega_dot,time)

R_nH = [-1 0 0;0 1 0;0 0 -1];
R_nN = R_nH*DCM_Hill2Inertial(euler_angles,omega_dot,time);

time_step = 0.001;
d_R_nN_dt = ((R_nH*DCM_Hill2Inertial(euler_angles,omega_dot,time+time_step))-(R_nH*DCM_Hill2Inertial(euler_angles,omega_dot,time)))/time_step;
N_omega_R_nN_tilde = -R_nN'*d_R_nN_dt;
N_omega_R_nN = inv_tilde(N_omega_R_nN_tilde);

%Alternate way: omega_R_nN = DCM_Hill2Inertial(euler_angles,omega_dot,time)'*omega_dot;
%The omega_dot is on Hill Frame and we need to map it to Inertial Frame, so
%it should be multiplied by NH

end