%% Mode Shape Plotter
clear; clc;

% --- CHANGE THIS NUMBER TO SEE DIFFERENT SHAPES ---
% Modes 1 to 12 are "Rigid Body" (Floating/Spinning)
% Mode 13 is our First Real Bending Mode!
Mode_ID = 20; 
% --------------------------------------------------

% 1. Load all pristine data
load('Modelmats.mat');
TopNodes = load('Nodes.dat');
BotNodes = load('Bottom_Nodes.dat');
TopElems = load('Elements.dat');
BotElems = load('Bottom_Elements.dat');

% 2. Calculate Eigenvalues (using a shift so it doesn't crash)
warning('off', 'all'); 
[ModeShapes, ~] = eigs(K, M, 20, -0.01); 
warning('on', 'all');

% 3. Extract Displacements for the selected mode
N = size(TopNodes, 1);
DOFs_per_node = round(size(K, 1) / (2 * N));

Top_Disp = zeros(N, 3);
Bot_Disp = zeros(N, 3);

% Safely pull X, Y, Z for each plate
for i = 1:N
    top_start = (i - 1) * DOFs_per_node + 1;
    bot_start = (N + i - 1) * DOFs_per_node + 1;
    
    Top_Disp(i, 1:3) = ModeShapes(top_start : top_start + 2, Mode_ID)';
    Bot_Disp(i, 1:3) = ModeShapes(bot_start : bot_start + 2, Mode_ID)';
end

% 4. Auto-Scale the Bending 
plate_length = max(TopNodes(:,1)) - min(TopNodes(:,1));
max_movement = max(max(abs(Top_Disp(:))), max(abs(Bot_Disp(:))));
visual_scale = (0.15 * plate_length) / max_movement; 

Deformed_Top = TopNodes + (visual_scale * Top_Disp);
Deformed_Bot = BotNodes + (visual_scale * Bot_Disp);

% 5. Fix Triangular Elements 
TopConn = TopElems(:, 2:end); TopConn(TopConn == 0) = NaN; 
BotConn = BotElems(:, 2:end); BotConn(BotConn == 0) = NaN; 

% 6. Draw the 3D Plot!
figure('Name', sprintf('Lap Joint - Mode %d', Mode_ID), 'Color', 'w');
hold on; grid on; axis equal; view(3);

% Draw Top (Blue) and Bottom (Red)
patch('Faces', TopConn, 'Vertices', Deformed_Top, 'FaceColor', 'b', 'FaceAlpha', 0.8);
patch('Faces', BotConn, 'Vertices', Deformed_Bot, 'FaceColor', 'r', 'FaceAlpha', 0.8);

title(sprintf('Mode Shape %d', Mode_ID), 'FontSize', 14);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');