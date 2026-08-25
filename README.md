# Lap-Joint-FEA-Substructuring
Computational dynamic analysis of a riveted lap joint using Craig-Bampton substructuring. This project extracts finite element matrices from Abaqus and mathematically couples the interface degrees of freedom in MATLAB using the penalty method to efficiently solve for true 3D mode shapes.

# Dynamic Analysis of a Riveted Lap Joint via Craig-Bampton Substructuring

* **MODE-20(Coupled)**
<img width="471" height="186" alt="Screenshot 2026-08-25 at 1 53 59 AM" src="https://github.com/user-attachments/assets/a793647a-0ed6-4a4c-9f3a-be66373fdc82" />




## 📌 Project Overview
This repository demonstrates a computationally efficient workflow for analyzing the structural dynamics of a riveted lap joint. Instead of relying purely on expensive commercial FEA solvers to handle interface interactions, this project extracts uncoupled matrices from **Abaqus**, applies **Craig-Bampton (CB) reduction**, and enforces interface coupling mathematically using **MATLAB**. 

**Key Engineering Skills Demonstrated:**
* **Finite Element Analysis (FEA):** Substructuring, global matrix extraction, and relative coordinate frames.
* **Computational Dynamics:** Eigenvalue problem formulation, rigid body mode verification, and modal coordinate recovery.
* **Algorithm Implementation:** Utilizing the penalty method to enforce physical constraints on reduced mass and stiffness matrices.

## 🚀 Engineering Motivation
Solving large-scale assemblies with complex interfaces (like rivets or bolts) in standard FEA software is computationally expensive, especially when running dynamic or nonlinear iterations. By transforming the physical mesh into reduced modal coordinates and separating the interface DOFs (the joint gap), we can mathematically couple the structure and solve for natural frequencies in seconds rather than hours, drastically optimizing the design cycle.

## 🛠️ Workflow & Methodology
1. **Matrix Extraction:** Uncoupled Mass and Stiffness matrices are extracted from an Abaqus model using Craig-Bampton reduction.
2. **Relative Coordinate Frame:** The matrices are organized so that the interface DOFs explicitly represent the physical gap between the top and bottom plates.
3. **Baseline Sanity Check:** The uncoupled model is verified by solving for exactly 12 zero eigenvalues (6 rigid body modes per free-floating plate).
4. **Penalty Coupling:** A high-stiffness penalty ($10^7$ N/m) is applied directly to the relative gap DOFs, mathematically simulating the riveted connection. The coupled system correctly drops to exactly 6 rigid body modes.
5. **Physical Recovery:** The abstract modal coordinates are expanded back into physical 3D space using kinematic relations to visualize the true coupled mode shapes.

## 💻 How to Run
1. Clone this repository to your local machine.
2. Ensure you have MATLAB installed.
3. Open `Plot_Coupled.m` and hit **Run**.
4. The script will output the rigid body mode validation to the command window and generate a 3D visualization of the first elastic bending mode.

## 📁 Repository Structure
* `Plot_Coupled.m`: Main solver script for coupling the matrices and plotting the recovered mode shapes.
* `Modelmats.mat`: Reduced Mass and Stiffness matrices exported from Abaqus.**[Download from Google Drive here](https://drive.google.com/file/d/17thj_iQYG1lKYA8i_c0Pf7vQpuQbFaMx/view?usp=drive_link)** (File too large for GitHub).
* `Nodes.dat` / `Elements.dat`: Abaqus mesh connectivity files used for visual recovery.
* `Bottom_Nodes.dat` / `Bottom_Elements.dat`: Secondary mesh data.
