%% bev_torque_limit_test.m
% Torque-limit sensitivity test on the MathWorks System-Level BEV model (R2024b).
% Re-runs the same drive cycle with different motor torque limits and
% computes specific electrical energy consumption (kWh/100 km).
%
% NOTE: built from the MathWorks example workflow (BEV_systemLevel live script).
% The torque-limit parameter name comes from the Speed Controller saturation
% block (bevControl.MotorDriveUnit_trqMax_Nm). Check the name in your project
% workspace before running.

modelName = "BEV_system_model";
load_system(modelName)
BEV_useComponents_Basic
VehSpdRef_loadCase_SimpleDrivePattern( ...
    ModelName = modelName, ...
    TargetSubsystemPath = "/Controller & Environment/Vehicle speed reference")

torqueLimits_Nm = [420 500];            % baseline, then raised limit
results = table('Size',[numel(torqueLimits_Nm) 5], ...
    'VariableTypes',["double","double","double","double","double"], ...
    'VariableNames',["TorqueLimit_Nm","PeakTorque_Nm","Distance_km","Energy_kWh","kWh_per_100km"]);

for k = 1:numel(torqueLimits_Nm)
    bevControl.MotorDriveUnit_trqMax_Nm = torqueLimits_Nm(k); %#ok<STRNU>
    simOut  = sim(modelName);
    simData = extractTimetable(simOut.logsout);

    t   = seconds(simData.Time);
    dt  = diff(t);
    P_W = simData.("HV Battery Power");          % W (check VariableUnits)
    v   = simData.("Vehicle Speed (km/hr)");     % km/h

    energy_kWh = sum(P_W(2:end) .* dt) / 3.6e6;
    dist_km    = sum(v(2:end)/3.6 .* dt) / 1000;

    results(k,:) = {torqueLimits_Nm(k), NaN, dist_km, energy_kWh, 100*energy_kWh/dist_km};
end

disp(results)
% Specific energy consumption should be identical if peak demanded torque
% (~200 N*m) stays below both limits: a null-sensitivity result.
writetable(results, "torque_limit_results.csv")
