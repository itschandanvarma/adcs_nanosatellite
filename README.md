# Spacecraft Dynamics Capstone Project

This repository contains the MATLAB code and visualization files for the Spacecraft Dynamics Capstone Project.

## Files

- `main.m`: This file contains the main script that implements the simulation and control algorithms for the spacecraft dynamics. It calculates the attitude states and angular velocities of the spacecraft over time, based on the given initial conditions and control parameters.

- `visualize_mission.m`: This file is responsible for visualizing the simulation results. It loads the data files generated from the main script and creates plots to visualize the attitude states and angular velocities of the spacecraft. It also generates the window screenshot, "ADCS Simulation Window.png", which provides an overview of the simulation environment.

## Functions

- `attitude_error_evaluation`: This function calculates the attitude error between the current attitude states (`sigma_BN_0`) and angular velocities (`B_omega_BN_0`) and the reference direction cosine matrix (`Ref_DCM`) and reference angular velocity (`Ref_omega`). It returns the attitude error in terms of the Modified Rodrigues Parameters (`sigma_BR`) and angular velocity error (`B_omega_BR`).

- `C2EP`: This function converts a 3x3 direction cosine matrix (`C`) into the corresponding 4x1 Euler parameter vector (`Q`), representing the non-dimensional Euler parameters.

- `Euler3132C`: This function returns the direction cosine matrix (`C`) in terms of the 3-1-3 Euler angles (`Q`).

- `C2MRP`: This function converts a direction cosine matrix (`C`) into the corresponding 3x1 Modified Rodrigues Parameters (MRP) vector (`Q`). The MRP vector is chosen such that its magnitude is less than or equal to 1.

- `MRP2C`: This function converts a 3x1 Modified Rodrigues Parameters (MRP) vector (`Q`) into the corresponding direction cosine matrix (`C`).

- `inv_tilde`: This function extracts the column elements from a skew-symmetric matrix.

- `MRTswitch`: This function checks if the norm of a Modified Rodrigues Parameters (MRP) vector (`Q`) is larger than a threshold (`s2`). If it is larger, the MRP vector is mapped to its shadow set.

- `tilde`: This function returns the skew-symmetric matrix obtained by tilde operator, which is used for cross multiplication.

## Visualization

The visualization files, "ADCS Simulation Window.png", "MRP Plot.png", and "Omega Plot.png", provide visual representations of the spacecraft's attitude states and angular velocities during the simulation. These plots and screenshots aid in understanding the dynamics and control behavior of the spacecraft throughout the mission.

Please refer to the respective files for a detailed view of the simulation results and visualizations.

![ADCS Simulation Window](ADCS%20Simulation%20Window.png)
