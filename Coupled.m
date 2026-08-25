% =========================================================================
% Script: Connect Plates in the Relative Coordinate Frame
% =========================================================================
clear; clc;
Num=20;
% 1. Load the matrices
load('Modelmats.mat');
Nodes = load('Nodes.dat');
N = size(Nodes, 1);

% 2. Define the Guessed Spring Stiffness
K_coupled = K;
k_spring = 1e7; 

% 3. The first N*3 DOFs are the Relative Displacements (X, Y, Z gaps)
num_relative_dofs = N * 3;

% Add the spring stiffness directly to the gap DOFs to close them!
for i = 1:num_relative_dofs
    K_coupled(i, i) = K_coupled(i, i) + k_spring;
end

% 4. Redo the exact Eigenanalysis
fprintf('Calculating eigenvalues...\n');
[~, D] = eig(full(K_coupled), full(M)); 
eigenvalues = sort(diag(D));

% 5. Count the Zeros
tolerance = 1.0; 
num_zeros = sum(abs(eigenvalues) < tolerance);

% Print the results!
fprintf('\n========================================\n');
fprintf('Number of zero (rigid body) eigenvalues: %d\n', num_zeros);
fprintf('========================================\n\n');

disp('Here are the eigenvalues:');
disp(eigenvalues(1:Num));

