function [N_r,N_r_dot] = Inertial_pos_vel(pos,euler_angles,omega_dot,time)

N_r = Euler3132C(euler_angles+omega_dot*time)'*pos;
N_r_dot = Euler3132C(euler_angles+omega_dot*time)'*[0;pos(1)*omega_dot(3);0];

%Doubt: BinvEuler313(euler_angles+omega_dot*time)*[0;pos(1)*omega_dot(3);0]
%Gives the same but Row 1 and 2 are flipped??

end