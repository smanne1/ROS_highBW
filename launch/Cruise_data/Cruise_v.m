clc 
close all;
clear all;

killerKb1 = csv2table('cruiseData_C_refv.csv',1,1602);
killerKb2 = csv2table('cruiseData_C_1_8.csv',1,1078);


x1 = table2array(killerKb1(:,2));
y1 = table2array(killerKb1(:,4));

x2 = table2array(killerKb2(:,2));
y2 = table2array(killerKb2(:,4));

load('waypoint.mat')
x3 = Cartesian(:,1)-500;
y3 = Cartesian(:,2)-501.5;


axis([-3 3 -3 3])
for k = 1:length(x2)
    plot(x2(1:k),y2(1:k),'b'); grid on;
    axis([-3 3 -3 3])
    pause(0.001);
   
    %addpoints(h,x1(k),y1(k));
    %addpoints(h,x2(k),y2(k));
    %drawnow
    
end


figure; hold on ;
plot(x3,y3,'b');
plot(x1,y1,'--g');
plot(x2,y2,'--r');
grid on;
h_axes = findobj(gcf, 'type', 'axes');
xlabel('x (m)','FontSize',12);
ylabel('y (m)','FontSize',12);
set(h_axes,'LineWidth',2,'FontSize',12,'GridAlpha',0.15); % size and brightness of grid and size of x & y axis numbers
title('Trajectory: Reference vs Actual','FontWeight','bold','FontSize',14, 'Interpreter','latex')

h_line = findobj(gcf, 'type', 'line');
set(h_line, 'LineWidth',2);         % Lines with thicker width for plots


%% ve and theta e plots 

v1 = table2array(killerKb1(:,8));
v2 = table2array(killerKb2(:,8));
vref1 = table2array(killerKb1(:,14));
vref2 = table2array(killerKb2(:,14));
vtime1 = table2array(killerKb1(:,12));
vtime2 = table2array(killerKb2(:,12));

theta1 = table2array(killerKb1(:,6));
theta2 = table2array(killerKb2(:,6));
tref1 = table2array(killerKb1(:,16));
tref2 = table2array(killerKb2(:,16));
ttime1 = table2array(killerKb1(:,12));
ttime2 = table2array(killerKb2(:,12));

ve1 = abs(vref1 - v1);
ve2 = abs(vref2 - v2);

thetae1 = abs(tref1 - theta1);
thetae2 = abs(tref2 - theta2);

figure;
plot(ttime1,ve1,ttime2,ve2);

figure;
plot(ttime1,thetae1,ttime2,thetae2);

