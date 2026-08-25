clc; clear; close all;
% 1. Load the mass (M) and stiffness (K) matrices
load('Modelmats.mat');

% 2. Perform Eigenanalysis
% We ask for the first 20 modes. 
% We use a slight shift (-0.1) so the solver doesn't panic on the free-floating plates.
num_modes = 20;
shift_value = -0.1; 
[~, EigenvaluesSq] = eigs(K, M, num_modes, shift_value);

% Extract the numbers from the diagonal and sort them from smallest to largest
eigenvalues = sort(diag(EigenvaluesSq));

% 3. Count the "Zero" Eigenvalues
% Because of FEA numerical noise, "zero" might look like 0.004 or -0.002.
% We set a tolerance so MATLAB knows anything less than 0.5 is practically zero.
tolerance = 0.5; 
num_zeros = sum(abs(eigenvalues) < tolerance);

% 4. Print the final answer to the command window
fprintf('\n========================================\n');
fprintf('Number of zero (rigid body) eigenvalues: %d\n', num_zeros);
fprintf('========================================\n\n');

disp('Here are the eigenvalues:');
disp(eigenvalues(1:20));