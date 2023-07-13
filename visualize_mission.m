clc; clear; close all;

% Load the MRPs, angular velocities, and time data
load('sigmas_BN.mat');
load('B_omegas_BN.mat');
load('time.mat');

% Set the default font to Helvetica
set(groot, 'DefaultAxesFontName', 'Calibri');
set(groot, 'DefaultTextFontName', 'Calibri');

% Define the dimensions of the CubeSat components
cubeSize = 100;       % Size of the main cube (CubeSat body)
panelWidth = 100;     % Width of each solar panel
panelHeight = 300;    % Height of each solar panel
panelDepth = 20;      % Depth of each solar panel

%Planet Params
r_mars = 3396.19; %kilometers
gravity_const_mars = 42828.3; %km3/s2
h_NS = 400; %kilometers
r_NS = r_mars+h_NS; %kilometers
theta_dot_NS = sqrt(gravity_const_mars/(r_NS^3)); %rad/s

% Set the planet's properties
planetRadius = r_mars;           % Radius of the planet (km)
planetOrbitRate = rad2deg(theta_dot_NS);        % Orbit rate of the planet (degrees per second)
planetDistance = r_NS;         % Distance between the center of the planet and the CubeSat (km)

% Create the main cube (CubeSat body)
[X, Y, Z] = meshgrid([-cubeSize/2 cubeSize/2]);
cube = [X(:), Y(:), Z(:)];
cubeFaces = [1 2 4 3; 1 2 6 5; 1 3 7 5; 2 4 8 6; 3 4 8 7; 5 6 8 7];

% Create the solar panels (cuboids)
[X, Y, Z] = meshgrid([-panelWidth/2 panelWidth/2], [-panelHeight/2 panelHeight/2], [-panelDepth/2 panelDepth/2]);
panel1 = [X(:), Y(:), Z(:)] + repmat([0, -(cubeSize+panelHeight)/2, 0], 8, 1);
panel2 = [X(:), Y(:), Z(:)] + repmat([0, (cubeSize+panelHeight)/2, 0], 8, 1);

% Create a figure with three rows
figure('Position', [50, 50, 1200, 1000], 'NumberTitle', 'off');
set(gcf, 'CloseRequestFcn', 'closereq'); % Stop execution on figure close

% Set the figure window name
set(gcf, 'Name', 'Attitude Dynamics and Control Simulation Window');

% Set the title of the figure
sgtitle('Attitude Dynamics and Control Simulation', 'Color', 'white', 'FontSize', 30, 'FontWeight', 'bold');
set(gcf, 'Color', 'black');

% Row 1: PoV: Planet
subplot(3, 2, [1, 2]);
hold on;
axis on;
grid off;
set(gca, 'Position', [0.05, 0.67, 0.9, 0.25]); % Adjust the position of the subplot

% Initialize the CubeSat plot objects
cubeObj = patch('Faces', cubeFaces, 'Vertices', cube, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'k', 'FaceAlpha', 1);
panel1Obj = patch('Faces', [1 2 4 3], 'Vertices', panel1, 'FaceColor', [0.9290 0.6940 0.1250], 'EdgeColor', 'k', 'FaceAlpha', 0.8);
panel2Obj = patch('Faces', [1 2 4 3], 'Vertices', panel2, 'FaceColor', [0.9290 0.6940 0.1250], 'EdgeColor', 'k', 'FaceAlpha', 0.8);

% Create the planet sphere
[xSphere, ySphere, zSphere] = sphere(100);
planetObj = surf(planetRadius * xSphere, planetRadius * ySphere, planetRadius * zSphere, 'FaceColor', [0.3010 0.7450 0.9330], 'EdgeColor', 'none');

% Set axis labels and limits for subplot 1
%xlabel('X');
%ylabel('Y');
%zlabel('Z');
axis equal;
box on;
view(0,0);

xlim([-planetRadius*4.5, planetRadius*4.5]);
ylim([-planetRadius*1, planetRadius*1]);
zlim([-planetRadius*0.75, planetRadius*0.75]);

% Turn off the numbers on the axis labels for the first subplot row
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'ZTickLabel', []);
set(gca, 'Color', 'black'); % Set subplot background color to black

% Set axes color to white
set(gca, 'XColor', 'white');
set(gca, 'YColor', 'white');
set(gca, 'ZColor', 'white');
set(gca, 'XTick', [], 'YTick', [], 'ZTick', []);

% Row 2: PoV: CUBSAT
subplot(3, 2, [3, 4]);
hold on;
axis on;
grid off;
set(gca, 'Position', [0.05, 0.4, 0.9, 0.2]); % Adjust the position of the subplot

% Duplicate the CubeSat plot objects
cubeObj2 = copyobj(cubeObj, gca);
panel1Obj2 = copyobj(panel1Obj, gca);
panel2Obj2 = copyobj(panel2Obj, gca);

% Set axis labels and limits for subplot 2
%xlabel('X');
%ylabel('Y');
%zlabel('Z');
axis equal;
box on;
view(0,0);

scale_factor = 4;
xlim([-cubeSize*(scale_factor+1)*6, cubeSize*(scale_factor+1)*6]);
ylim([-cubeSize*scale_factor, cubeSize*scale_factor]);
zlim([-cubeSize*scale_factor, cubeSize*scale_factor]);

% Turn off the numbers on the axis labels for the second subplot row
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'ZTickLabel', []);
set(gca, 'Color', 'black'); % Set subplot background color to black

% Set axes color to white
set(gca, 'XColor', 'white');
set(gca, 'YColor', 'white');
set(gca, 'ZColor', 'white');
set(gca, 'XTick', [], 'YTick', [], 'ZTick', []);

% Row 3: Split into two columns for sigmas and omegas
% Subplot 1: MRPs (sigmas)
subplot(3, 2, 5);
hold on;
grid off;
xlabel('time (seconds)');
ylabel('\sigma_{BN}');
title('Modified Rodrigues Parameters')
set(gca, 'Position', [0.07, 0.1, 0.38, 0.2]); % Adjust the position of the subplot
set(gca, 'Color', 'black'); % Set subplot background color to black
set(gca, 'XColor', 'white'); % Set x-axis color to white
set(gca, 'YColor', 'white'); % Set y-axis color to white

sigma1Plot = plot(time, sigmas_BN(1, :), 'Color', [0 0.4470 0.7410], 'LineWidth', 1);
sigma2Plot = plot(time, sigmas_BN(2, :), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
sigma3Plot = plot(time, sigmas_BN(3, :), 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1);

legend('\sigma_1', '\sigma_2', '\sigma_3', 'TextColor', 'white');

% Subplot 2: Angular Velocities (omegas)
subplot(3, 2, 6);
hold on;
grid off;
xlabel('time (seconds)');
ylabel('\omega_{BN}');
title('Angular Velocities')
set(gca, 'Position', [0.54, 0.1, 0.38, 0.2]); % Adjust the position of the subplot
set(gca, 'Color', 'black'); % Set subplot background color to black
set(gca, 'XColor', 'white'); % Set x-axis color to white
set(gca, 'YColor', 'white'); % Set y-axis color to white

omega1Plot = plot(time, B_omegas_BN(1, :), 'Color', [0 0.4470 0.7410], 'LineWidth', 1);
omega2Plot = plot(time, B_omegas_BN(2, :), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
omega3Plot = plot(time, B_omegas_BN(3, :), 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1);

legend('\omega_1', '\omega_2', '\omega_3', 'TextColor', 'white');

% Animate the CubeSat models, planet orbit, and update the MRPs and Angular Velocities plots
for i = 1:length(time)
    
    % Convert MRPs to DCM using MRP2C
    C_BN = MRP2C(sigmas_BN(:, i));
    
    % Update CubeSat model orientation
    cubeRot = cube * C_BN';
    set(cubeObj, 'Vertices', cubeRot);
    set(panel1Obj, 'Vertices', panel1 * C_BN');
    set(panel2Obj, 'Vertices', panel2 * C_BN');
    set(cubeObj2, 'Vertices', cubeRot);
    set(panel1Obj2, 'Vertices', panel1 * C_BN');
    set(panel2Obj2, 'Vertices', panel2 * C_BN');
    
    % Update planet orbit
    planetTheta = planetOrbitRate * time(i);
    planetX = planetDistance * cosd(planetTheta);
    planetY = planetDistance * sind(planetTheta);
    set(planetObj, 'XData', planetRadius * xSphere + planetX, 'YData', planetRadius * ySphere + planetY);
    
    % Update MRPs and Angular Velocities plots
    set(sigma1Plot, 'XData', time(1:i), 'YData', sigmas_BN(1, 1:i));
    set(sigma2Plot, 'XData', time(1:i), 'YData', sigmas_BN(2, 1:i));
    set(sigma3Plot, 'XData', time(1:i), 'YData', sigmas_BN(3, 1:i));
    set(omega1Plot, 'XData', time(1:i), 'YData', B_omegas_BN(1, 1:i));
    set(omega2Plot, 'XData', time(1:i), 'YData', B_omegas_BN(2, 1:i));
    set(omega3Plot, 'XData', time(1:i), 'YData', B_omegas_BN(3, 1:i));
    
    % Update the figure window
    drawnow;
    pause(0.0001);

end