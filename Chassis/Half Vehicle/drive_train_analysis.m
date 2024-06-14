% world constants
g = 9.8;

% vehicle parameters
m = 100 + 12 * 0.2;
v = 2;
t_acc = 5;
a = v/t_acc;

eff_chain = 0.96;
eff_treads = 0.7;

r_wheel = 0.5 * 80/1000;
alpha_incline = 10;
c_rr = 0.1;

F_N_incl = m * g * cos(alpha_incline * pi()/180);
F_g_incl = m * g * sin(alpha_incline * pi()/180);
F_rr = c_rr * F_N_incl;
F_acc = m * a;

F_tot = F_rr + F_g_incl + F_acc;

omega = v/r_wheel;
omega_rpm = omega * 60/(2 * pi());


    
T = F_tot * r_wheel;

P = F_tot * v;

P, T, omega_rpm