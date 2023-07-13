function [HN] = DCM_Hill2Inertial(euler_angles,omega_dot,time)

HN = Euler3132C(euler_angles+omega_dot*time);

%Alternate Way
%[N_r,N_r_dot] = N_pos_vel(pos,euler_angles,omega_dot,time);
%i_r = N_r/norm(N_r);
%i_h = cross(N_r,N_r_dot)/norm(cross(N_r,N_r_dot));
%i_theta = cross(i_h,i_r);
%HN = [i_r i_theta i_h]';

end