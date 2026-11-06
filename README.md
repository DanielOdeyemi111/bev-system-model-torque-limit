# Battery Electric Vehicle (BEV) System Model: Torque-Limit Sensitivity Test

MATLAB/Simulink (R2024b) work for a Master's thesis (AESE programme, Université de Bourgogne), based on the MathWorks *System-Level Battery Electric Vehicle (BEV) Model* (Simscape Battery Electric Vehicle Model, R2024b branch).

## What was done
1. **Baseline run** on the Simple Drive Pattern cycle (battery, motor drive unit, reduction gear, longitudinal vehicle).
2. **Torque-limit test:** motor torque limit raised from 420 to 500 N·m.

## Results (from the model runs)
| Quantity | Value |
|---|---|
| Specific electrical energy consumption | 14.9539 kWh/100 km |
| Average / max speed | 37.4195 / 70.0078 km/h |
| Distance | 0.9626 km |
| Peak commanded torque | about 200 N·m |

Raising the limit from 420 to 500 N·m gave identical results (null sensitivity): the drive cycle never demands more than about 200 N·m, so neither limit is reached.

## Files
- `scripts/bev_torque_limit_test.m`: reruns the cycle for each torque limit and computes kWh/100 km. It follows the MathWorks example workflow; verify the parameter name `bevControl.MotorDriveUnit_trqMax_Nm` in your project workspace.

**Requirements:** MATLAB R2024b, Simulink, Simscape Electrical, and the MathWorks BEV model project (not redistributed here).

Reference model by MathWorks. Academic use.
