%% True Physical Coupled Plot (Relative Coordinates)
clear; clc;
N=20;
Mode_ID = N; % First Bending Mode after the 6 Zeros

% 1. Load Data
load('Modelmats.mat');
TopNodes = load('Nodes.dat');
BotNodes = load('Bottom_Nodes.dat');
TopElems = load('Elements.dat');
BotElems = load('Bottom_Elements.dat');

N = size(TopNodes, 1);
DOFs_per_node = 3; % X, Y, Z DOFs per node
num_gap_dofs = N * DOFs_per_node; % The first block of the matrix

% 2. Apply Springs to the Gap DOFs
K_coupled = K;
k_spring = 1e7; 
for i = 1:num_gap_dofs
    K_coupled(i, i) = K_coupled(i, i) + k_spring;
end

% 3. Calculate Exact Eigenvectors
fprintf('Calculating coupled mode shapes...\n');
[ModeShapes, D] = eig(full(K_coupled), full(M)); 
[~, sort_idx] = sort(diag(D));
ModeShapes = ModeShapes(:, sort_idx);

% 4. Extract Displacements Using Relative Math
Top_Disp = zeros(N, 3);
Bot_Disp = zeros(N, 3);

for i = 1:N
    % Gap DOFs are the first N*3 block
    gap_start = (i - 1) * DOFs_per_node + 1;
    % Bottom Plate DOFs are the second N*3 block
    bot_start = num_gap_dofs + (i - 1) * DOFs_per_node + 1;
    
    gap_xyz = ModeShapes(gap_start : gap_start + 2, Mode_ID)';
    bot_xyz = ModeShapes(bot_start : bot_start + 2, Mode_ID)';
    
    % The core physics of Relative Coordinates:
    Bot_Disp(i, :) = bot_xyz;
    Top_Disp(i, :) = bot_xyz + gap_xyz; 
end

% 5. Auto-Scale the Plot
plate_length = max(TopNodes(:,1)) - min(TopNodes(:,1));
max_movement = max(max(abs(Top_Disp(:))), max(abs(Bot_Disp(:))));
visual_scale = (0.15 * plate_length) / max_movement; 

Deformed_Top = TopNodes + (visual_scale * Top_Disp);
Deformed_Bot = BotNodes + (visual_scale * Bot_Disp);

% 6. Clean Elements
TopConn = TopElems(:, 2:end); TopConn(TopConn == 0) = NaN; 
BotConn = BotElems(:, 2:end); BotConn(BotConn == 0) = NaN; 

% 7. Draw the Masterpiece
figure('Name', sprintf('True Coupled Joint - Mode %d', Mode_ID), 'Color', 'w');
hold on; grid on; axis equal; view(3);

patch('Faces', TopConn, 'Vertices', Deformed_Top, 'FaceColor', 'b', 'FaceAlpha', 0.8);
patch('Faces', BotConn, 'Vertices', Deformed_Bot, 'FaceColor', 'r', 'FaceAlpha', 0.8);

title(sprintf('COUPLED Mode Shape %d', Mode_ID), 'FontSize', 14);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');