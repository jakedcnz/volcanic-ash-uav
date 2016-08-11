% Heat calculations
clear, clc

rho_0 = 1.2250; % air density at sea level
T_0 = 288.15; % temperature at sea level
g = 9.80665; % Acceleration due to gravity
M = 0.0289644; % Molar mass of air on earth (Kg/mol)
R = 8.31432; % Universal gas constant for air

h_max = 10e3;
h_step = 100;
j = 1;
for i = 1:h_step:h_max
    h(j) = h_max - i;
    j = j + 1;
end

rho = rho_0*exp(-g*M*h/R/T_0);

m = 2; %kg
height = 10000;

battery = 2200; % mA hr

OPC_I_testing = 175; %mA when testing
OPC_I_idle = 95; %mA when idle
OPC_weigt = 105; %grams
OPC_voltage = 5; %V
OPC_power = (175 * 5)/1000; %W

PIXHAWK_I = 280/1000; % mA (Pixhawk running APM:Plane 3.3.0, 
                    %GPS/Compass modules, safety switch, 
                    %buzzer, 433 MHz telemetry radio)
                    
RPi_temp_requirement = 0; % some peripherals aren't guaranteed below zero.
RPi_I = 750/1000; % mA

Motor_I = 20; %????? A

% Assume wind speed is at 20 kmph average
glide_distance = 30000; % m

Ep = m * g * height;
Vbatt = 12.8;
Echem = 3600 * Vbatt * 10;

%from last years project
CdAd = 0.0212;
ClAl = 0.0625;

% glide slope
theta = atan(CdAd/ClAl);

K = ClAl*cos(theta) + CdAd*sin(theta);
for i = 1:length(rho)
   a(i) = sqrt(2*m*g/rho(i)/K);
end

plot(h,a)
xlabel('altitude (m)');
ylabel('airspeed (m/s)');
%a = sqrt(2*m*g/rho/K) % airspeed

% P = E * s^-1
% Power consumed -> P = I*V
consumed_power = OPC_power + Motor_I * 12.8 + RPi_I * 5 + PIXHAWK_I * 5
consumed_energy = consumed_power * 3600