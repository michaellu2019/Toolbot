% https://youtu.be/259KmgQ40Q8
% https://www.mathworks.com/help/simulink/slref/automotive-suspension.html
% https://youtu.be/w5o8Q0VIYuA

% world constants
g = 9.8;

% vehicle parameters
m = 100;
L = 0.8;
v = 0.5;
l1 = L * (3/8);
l2 = L * (1/8);
l3 = -l2;
l4 = -l1;

% road parameters
t_offset = 2;
h_0 = 0;
h_bump = 0.03;
w_bump = 0.03;
t_bump = w_bump/v;
t_delay = (l1 - l2)/v;
T = 20;
D = (w_bump/v)/T * 100;

