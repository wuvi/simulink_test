function RoadRollerSimulation()
% 压路机Simulink模型创建脚本
% 该脚本创建一个完整的压路机动力学仿真模型
%
% 使用方法:
%   运行此脚本将自动创建Simulink模型
%   RoadRollerSimulation()

    % 检查Simulink是否可用
    if ~license('test', 'Simulink')
        error('此脚本需要Simulink许可证');
    end
    
    % 显示MATLAB版本信息
    fprintf('正在创建Simulink模型...\n');
    fprintf('MATLAB版本: %s\n', version);
    
    % 模型名称
    modelName = 'RoadRollerModel';
    
    % 如果模型已存在，先关闭并删除
    if bdIsLoaded(modelName)
        fprintf('关闭已存在的模型...\n');
        close_system(modelName, 0);
    end
    
    % 如果模型文件已存在，删除它
    if exist([modelName '.slx'], 'file')
        delete([modelName '.slx']);
    end
    if exist([modelName '.mdl'], 'file')
        delete([modelName '.mdl']);
    end
    
    % 创建新的Simulink模型
    new_system(modelName);
    open_system(modelName);
    
    % 设置模型参数
    set_param(modelName, 'Solver', 'ode45');
    set_param(modelName, 'StopTime', '100');
    set_param(modelName, 'SaveOutput', 'on');
    set_param(modelName, 'SaveFormat', 'StructureWithTime');
    
    % ======== 子系统位置定义 ========
    % 使用更合理的布局
    xBase = 50;
    yBase = 50;
    blockWidth = 100;
    blockHeight = 60;
    xSpacing = 200;
    ySpacing = 150;
    
    % ======== 1. 输入模块 - 驾驶员控制 ========
    % 油门控制 (0-1)
    throttlePos = [xBase, yBase, xBase+blockWidth, yBase+blockHeight];
    add_block('simulink/Sources/Constant', [modelName '/Throttle'], ...
        'Value', '0.5', ...
        'Position', throttlePos);
    
    % 制动控制 (0-1)
    brakePos = [xBase, yBase+ySpacing, xBase+blockWidth, yBase+ySpacing+blockHeight];
    add_block('simulink/Sources/Constant', [modelName '/Brake'], ...
        'Value', '0', ...
        'Position', brakePos);
    
    % 振动开关 (0或1)
    vibrationPos = [xBase, yBase+2*ySpacing, xBase+blockWidth, yBase+2*ySpacing+blockHeight];
    add_block('simulink/Sources/Step', [modelName '/VibrationSwitch'], ...
        'Time', '10', ...
        'Before', '0', ...
        'After', '1', ...
        'Position', vibrationPos);
    
    % ======== 2. 发动机模型 ========
    enginePos = [xBase+xSpacing, yBase, xBase+xSpacing+blockWidth, yBase+blockHeight];
    add_block('built-in/SubSystem', [modelName '/Engine'], ...
        'Position', enginePos);
    
    % 创建发动机子系统内容
    add_block('simulink/Sources/In1', [modelName '/Engine/Throttle_In']);
    add_block('simulink/Math Operations/Gain', [modelName '/Engine/MaxPower'], ...
        'Gain', '150'); % 最大功率150kW
    add_block('simulink/Sinks/Out1', [modelName '/Engine/Power_Out']);
    
    add_line([modelName '/Engine'], 'Throttle_In/1', 'MaxPower/1');
    add_line([modelName '/Engine'], 'MaxPower/1', 'Power_Out/1');
    
    % ======== 3. 传动系统 ========
    drivetrainPos = [xBase+2*xSpacing, yBase, xBase+2*xSpacing+blockWidth, yBase+blockHeight];
    add_block('built-in/SubSystem', [modelName '/Drivetrain'], ...
        'Position', drivetrainPos);
    
    % 创建传动系统子系统
    add_block('simulink/Sources/In1', [modelName '/Drivetrain/Power_In']);
    add_block('simulink/Sources/In1', [modelName '/Drivetrain/Brake_In']);
    add_block('simulink/Math Operations/Gain', [modelName '/Drivetrain/Efficiency'], ...
        'Gain', '0.85'); % 传动效率85%
    add_block('simulink/Math Operations/Product', [modelName '/Drivetrain/BrakeEffect']);
    add_block('simulink/Math Operations/Gain', [modelName '/Drivetrain/BrakeFactor'], ...
        'Gain', '-1');
    add_block('simulink/Math Operations/Sum', [modelName '/Drivetrain/TorqueSum'], ...
        'Inputs', '++');
    add_block('simulink/Sinks/Out1', [modelName '/Drivetrain/Torque_Out']);
    
    add_line([modelName '/Drivetrain'], 'Power_In/1', 'Efficiency/1');
    add_line([modelName '/Drivetrain'], 'Brake_In/1', 'BrakeFactor/1');
    add_line([modelName '/Drivetrain'], 'BrakeFactor/1', 'BrakeEffect/1');
    add_line([modelName '/Drivetrain'], 'Efficiency/1', 'TorqueSum/1');
    add_line([modelName '/Drivetrain'], 'BrakeEffect/1', 'TorqueSum/2');
    add_line([modelName '/Drivetrain'], 'TorqueSum/1', 'Torque_Out/1');
    
    % ======== 4. 车辆动力学 ========
    dynamicsPos = [xBase+3*xSpacing, yBase, xBase+3*xSpacing+blockWidth, yBase+blockHeight];
    add_block('built-in/SubSystem', [modelName '/VehicleDynamics'], ...
        'Position', dynamicsPos);
    
    % 创建车辆动力学子系统
    add_block('simulink/Sources/In1', [modelName '/VehicleDynamics/Torque_In']);
    add_block('simulink/Math Operations/Gain', [modelName '/VehicleDynamics/Mass'], ...
        'Gain', '1/12000'); % 压路机质量12吨
    add_block('simulink/Continuous/Integrator', [modelName '/VehicleDynamics/Velocity']);
    add_block('simulink/Continuous/Integrator', [modelName '/VehicleDynamics/Position']);
    add_block('simulink/Math Operations/Gain', [modelName '/VehicleDynamics/Resistance'], ...
        'Gain', '-0.05'); % 滚动阻力
    add_block('simulink/Math Operations/Sum', [modelName '/VehicleDynamics/ForceSum'], ...
        'Inputs', '++');
    add_block('simulink/Sinks/Out1', [modelName '/VehicleDynamics/Velocity_Out']);
    add_block('simulink/Sinks/Out1', [modelName '/VehicleDynamics/Position_Out']);
    
    add_line([modelName '/VehicleDynamics'], 'Torque_In/1', 'ForceSum/1');
    add_line([modelName '/VehicleDynamics'], 'Velocity/1', 'Resistance/1');
    add_line([modelName '/VehicleDynamics'], 'Resistance/1', 'ForceSum/2');
    add_line([modelName '/VehicleDynamics'], 'ForceSum/1', 'Mass/1');
    add_line([modelName '/VehicleDynamics'], 'Mass/1', 'Velocity/1');
    add_line([modelName '/VehicleDynamics'], 'Velocity/1', 'Position/1');
    add_line([modelName '/VehicleDynamics'], 'Velocity/1', 'Velocity_Out/1');
    add_line([modelName '/VehicleDynamics'], 'Position/1', 'Position_Out/1');
    
    % ======== 5. 振动系统 ========
    vibrationPos = [xBase+2*xSpacing, yBase+ySpacing, xBase+2*xSpacing+blockWidth, yBase+ySpacing+blockHeight];
    add_block('built-in/SubSystem', [modelName '/VibrationSystem'], ...
        'Position', vibrationPos);
    
    % 创建振动系统子系统
    add_block('simulink/Sources/In1', [modelName '/VibrationSystem/Switch_In']);
    add_block('simulink/Sources/Sine Wave', [modelName '/VibrationSystem/VibGenerator'], ...
        'Frequency', '30', ...  % 30Hz振动频率
        'Amplitude', '50');     % 振幅50kN
    add_block('simulink/Math Operations/Product', [modelName '/VibrationSystem/VibControl']);
    add_block('simulink/Sinks/Out1', [modelName '/VibrationSystem/Force_Out']);
    
    add_line([modelName '/VibrationSystem'], 'Switch_In/1', 'VibControl/1');
    add_line([modelName '/VibrationSystem'], 'VibGenerator/1', 'VibControl/2');
    add_line([modelName '/VibrationSystem'], 'VibControl/1', 'Force_Out/1');
    
    % ======== 6. 压实度计算 ========
    compactionPos = [xBase+3*xSpacing, yBase+ySpacing, xBase+3*xSpacing+blockWidth, yBase+ySpacing+blockHeight];
    add_block('built-in/SubSystem', [modelName '/CompactionCalculator'], ...
        'Position', compactionPos);
    
    % 创建压实度计算子系统
    add_block('simulink/Sources/In1', [modelName '/CompactionCalculator/VibForce_In']);
    add_block('simulink/Sources/In1', [modelName '/CompactionCalculator/Velocity_In']);
    
    % 使用Abs模块代替Math Function，更兼容
    add_block('simulink/Math Operations/Abs', [modelName '/CompactionCalculator/AbsVibForce']);
    
    add_block('simulink/Math Operations/Product', [modelName '/CompactionCalculator/CompactionRate']);
    add_block('simulink/Continuous/Integrator', [modelName '/CompactionCalculator/TotalCompaction']);
    add_block('simulink/Math Operations/Gain', [modelName '/CompactionCalculator/ScaleFactor'], ...
        'Gain', '0.001');
    add_block('simulink/Sinks/Out1', [modelName '/CompactionCalculator/Compaction_Out']);
    
    add_line([modelName '/CompactionCalculator'], 'VibForce_In/1', 'AbsVibForce/1');
    add_line([modelName '/CompactionCalculator'], 'AbsVibForce/1', 'CompactionRate/1');
    add_line([modelName '/CompactionCalculator'], 'Velocity_In/1', 'CompactionRate/2');
    add_line([modelName '/CompactionCalculator'], 'CompactionRate/1', 'ScaleFactor/1');
    add_line([modelName '/CompactionCalculator'], 'ScaleFactor/1', 'TotalCompaction/1');
    add_line([modelName '/CompactionCalculator'], 'TotalCompaction/1', 'Compaction_Out/1');
    
    % ======== 7. 显示和输出模块 ========
    % 速度显示
    velocityDispPos = [xBase+4*xSpacing, yBase, xBase+4*xSpacing+blockWidth, yBase+blockHeight];
    add_block('simulink/Sinks/Display', [modelName '/VelocityDisplay'], ...
        'Position', velocityDispPos);
    
    % 位置显示
    positionDispPos = [xBase+4*xSpacing, yBase+70, xBase+4*xSpacing+blockWidth, yBase+70+blockHeight];
    add_block('simulink/Sinks/Display', [modelName '/PositionDisplay'], ...
        'Position', positionDispPos);
    
    % 压实度显示
    compactionDispPos = [xBase+4*xSpacing, yBase+ySpacing, xBase+4*xSpacing+blockWidth, yBase+ySpacing+blockHeight];
    add_block('simulink/Sinks/Display', [modelName '/CompactionDisplay'], ...
        'Position', compactionDispPos);
    
    % Scope - 综合显示
    scopePos = [xBase+4*xSpacing, yBase+2*ySpacing-50, xBase+4*xSpacing+blockWidth, yBase+2*ySpacing+blockHeight+50];
    add_block('simulink/Sinks/Scope', [modelName '/StateScope'], ...
        'Position', scopePos, ...
        'NumInputPorts', '4');
    
    % 配置Scope
    set_param([modelName '/StateScope'], 'NumInputPorts', '4');
    set_param([modelName '/StateScope'], 'LayoutDimensions', '[2, 2]');
    
    % ======== 连接所有模块 ========
    % 输入到发动机
    add_line(modelName, 'Throttle/1', 'Engine/1', 'autorouting', 'on');
    
    % 发动机到传动系统
    add_line(modelName, 'Engine/1', 'Drivetrain/1', 'autorouting', 'on');
    
    % 制动到传动系统
    add_line(modelName, 'Brake/1', 'Drivetrain/2', 'autorouting', 'on');
    
    % 传动系统到车辆动力学
    add_line(modelName, 'Drivetrain/1', 'VehicleDynamics/1', 'autorouting', 'on');
    
    % 振动开关到振动系统
    add_line(modelName, 'VibrationSwitch/1', 'VibrationSystem/1', 'autorouting', 'on');
    
    % 车辆动力学输出
    add_line(modelName, 'VehicleDynamics/1', 'VelocityDisplay/1', 'autorouting', 'on');
    add_line(modelName, 'VehicleDynamics/2', 'PositionDisplay/1', 'autorouting', 'on');
    
    % 振动力到压实度计算
    add_line(modelName, 'VibrationSystem/1', 'CompactionCalculator/1', 'autorouting', 'on');
    add_line(modelName, 'VehicleDynamics/1', 'CompactionCalculator/2', 'autorouting', 'on');
    
    % 压实度输出
    add_line(modelName, 'CompactionCalculator/1', 'CompactionDisplay/1', 'autorouting', 'on');
    
    % 连接到Scope
    add_line(modelName, 'VehicleDynamics/1', 'StateScope/1', 'autorouting', 'on');
    add_line(modelName, 'VehicleDynamics/2', 'StateScope/2', 'autorouting', 'on');
    add_line(modelName, 'VibrationSystem/1', 'StateScope/3', 'autorouting', 'on');
    add_line(modelName, 'CompactionCalculator/1', 'StateScope/4', 'autorouting', 'on');
    
    % 保存模型
    try
        save_system(modelName);
        fprintf('\n模型已成功保存!\n');
    catch ME
        warning('模型保存失败: %s', ME.message);
    end
    
    fprintf('\n====================================\n');
    fprintf('压路机Simulink模型创建完成！\n');
    fprintf('====================================\n\n');
    fprintf('模型信息:\n');
    fprintf('  模型名称: %s\n', modelName);
    fprintf('  保存位置: %s\n', pwd);
    fprintf('\n');
    fprintf('模型包含以下主要组件:\n');
    fprintf('  1. 驾驶员控制输入 (油门、制动、振动开关)\n');
    fprintf('  2. 发动机模型 (150kW最大功率)\n');
    fprintf('  3. 传动系统 (85%%效率)\n');
    fprintf('  4. 车辆动力学 (12吨质量)\n');
    fprintf('  5. 振动系统 (30Hz, 50kN)\n');
    fprintf('  6. 压实度计算\n');
    fprintf('  7. 实时显示和示波器\n\n');
    fprintf('使用说明:\n');
    fprintf('  - 在Simulink中打开模型: open_system(''%s'')\n', modelName);
    fprintf('  - 点击"运行"按钮开始仿真\n');
    fprintf('  - 仿真时间: 100秒\n');
    fprintf('  - 可以修改Throttle和Brake的值来控制压路机\n');
    fprintf('  - VibrationSwitch在10秒时自动开启振动\n');
    fprintf('\n或使用run_simulation()函数运行仿真\n');
    fprintf('====================================\n');
    
end
