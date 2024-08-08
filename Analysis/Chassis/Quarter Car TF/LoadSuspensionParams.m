% world constants
g = 9.8;

% vehicle and suspension parameters
v = 0.25;
m = 12.5;
C = 0;
K = 5000;

% road parameters
h_0 = 0;
h_bump = 0.015;
w_bump = 0.3;
T = 20;
t_bump = w_bump/v;
D = (w_bump/v)/T * 100;

