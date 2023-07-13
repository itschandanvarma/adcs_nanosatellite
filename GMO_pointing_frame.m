function [R_cN,N_omega_R_cN] = GMO_pointing_frame(pos_NS,pos_MS,euler_angles_NS,euler_angles_MS,omega_dot_NS,omega_dot_MS,time)

[N_r_NS,~] = Inertial_pos_vel(pos_NS,euler_angles_NS,omega_dot_NS,time);
[N_r_MS,~] = Inertial_pos_vel(pos_MS,euler_angles_MS,omega_dot_MS,time);

r_1 = -(N_r_MS-N_r_NS)/norm((N_r_MS-N_r_NS));
r_2 = cross((N_r_MS-N_r_NS),[0;0;1])/norm(cross((N_r_MS-N_r_NS),[0;0;1]));
r_3 = cross(r_1,r_2);
R_cN = [r_1 r_2 r_3]';

%For timestep
time_step = 0.001;
[N_r_NS_h,~] = Inertial_pos_vel(pos_NS,euler_angles_NS,omega_dot_NS,time+time_step);
[N_r_MS_h,~] = Inertial_pos_vel(pos_MS,euler_angles_MS,omega_dot_MS,time+time_step);

r_1_h = -(N_r_MS_h-N_r_NS_h)/norm((N_r_MS_h-N_r_NS_h));
r_2_h = cross((N_r_MS_h-N_r_NS_h),[0;0;1])/norm(cross((N_r_MS_h-N_r_NS_h),[0;0;1]));
r_3_h = cross(r_1_h,r_2_h);
R_cN_h = [r_1_h r_2_h r_3_h]';

d_R_cN_dt = (R_cN_h-R_cN)/time_step;
N_omega_R_cN_tilde = -R_cN'*d_R_cN_dt;
N_omega_R_cN = inv_tilde(N_omega_R_cN_tilde);

end