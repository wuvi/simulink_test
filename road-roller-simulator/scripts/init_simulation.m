% 压路机仿真系统初始化脚本
% 该脚本设置所有仿真参数和初始条件
%
% 作者: AI Assistant
% 日期: 2025-10-24
% 版本: 1.0

clear all;
close all;
clc;

fprintf('====================================\n');
fprintf('  压路机虚拟仿真系统初始化\n');
fprintf('====================================\n\n');

%% 1. 压路机物理参数
fprintf('正在加载压路机物理参数...\n');

% 基本参数
params.roller.mass = 12000;              % 总质量 (kg)
params.roller.length = 4.5;              % 车身长度 (m)
params.roller.width = 2.1;               % 车身宽度 (m)
params.roller.height = 2.8;              % 车身高度 (m)
params.roller.wheelbase = 3.0;           % 轴距 (m)
params.roller.front_drum_radius = 0.75;  % 前钢轮半径 (m)
params.roller.rear_drum_radius = 0.75;   % 后钢轮半径 (m)
params.roller.drum_width = 2.1;          % 钢轮宽度 (m)

% 质量分配
params.roller.front_mass_ratio = 0.55;   % 前轴质量比例
params.roller.rear_mass_ratio = 0.45;    % 后轴质量比例

% 转动惯量
params.roller.inertia_z = 15000;         % 绕垂直轴转动惯量 (kg*m^2)

%% 2. 发动机参数
fprintf('正在加载发动机参数...\n');

params.engine.max_power = 150;           % 最大功率 (kW)
params.engine.rated_rpm = 2200;          % 额定转速 (rpm)
params.engine.idle_rpm = 800;            % 怠速转速 (rpm)
params.engine.max_rpm = 2400;            % 最高转速 (rpm)
params.engine.max_torque = 800;          % 最大扭矩 (N*m)
params.engine.response_time = 0.5;       % 响应时间常数 (s)

% 发动机效率曲线（油门开度 vs 功率输出比例）
params.engine.throttle_map = [0, 0.2, 0.4, 0.6, 0.8, 1.0];
params.engine.power_map = [0, 0.15, 0.35, 0.60, 0.85, 1.0];

%% 3. 传动系统参数
fprintf('正在加载传动系统参数...\n');

params.drivetrain.efficiency = 0.85;      % 传动效率
params.drivetrain.gear_ratio_1 = 3.5;     % 一档速比
params.drivetrain.gear_ratio_2 = 2.0;     % 二档速比
params.drivetrain.gear_ratio_3 = 1.2;     % 三档速比
params.drivetrain.final_drive_ratio = 4.2; % 主减速比

% 换挡速度阈值 (m/s)
params.drivetrain.shift_speed_1_2 = 1.5;  % 1档换2档
params.drivetrain.shift_speed_2_3 = 3.0;  % 2档换3档

%% 4. 制动系统参数
fprintf('正在加载制动系统参数...\n');

params.brake.max_force = 80000;           % 最大制动力 (N)
params.brake.response_time = 0.2;         % 制动响应时间 (s)
params.brake.front_brake_ratio = 0.6;     % 前轮制动力分配比例
params.brake.rear_brake_ratio = 0.4;      % 后轮制动力分配比例

%% 5. 振动系统参数
fprintf('正在加载振动系统参数...\n');

params.vibration.frequency = 30;          % 振动频率 (Hz)
params.vibration.amplitude_low = 30;      % 低振幅模式激振力 (kN)
params.vibration.amplitude_high = 50;     % 高振幅模式激振力 (kN)
params.vibration.exciter_mass = 200;      % 激振块质量 (kg)
params.vibration.eccentric_moment = 15;   % 偏心力矩 (kg*m)

% 振动模式
params.vibration.modes = {'OFF', 'LOW', 'HIGH'};
params.vibration.current_mode = 'OFF';

%% 6. 路面交互参数
fprintf('正在加载路面交互参数...\n');

params.road.rolling_resistance_coef = 0.05;  % 滚动阻力系数
params.road.air_resistance_coef = 0.4;       % 空气阻力系数
params.road.frontal_area = 5.0;              % 迎风面积 (m^2)
params.road.air_density = 1.225;             % 空气密度 (kg/m^3)

% 路面类型及其特性
params.road.types = {'asphalt', 'gravel', 'soil', 'sand'};
params.road.stiffness = [50000, 30000, 15000, 8000];  % 路面刚度 (N/m)
params.road.damping = [2000, 1500, 1000, 500];        % 路面阻尼 (N*s/m)
params.road.current_type = 'asphalt';
params.road.current_stiffness = 50000;
params.road.current_damping = 2000;

%% 7. 压实度模型参数
fprintf('正在加载压实度模型参数...\n');

params.compaction.initial_density = 1600;      % 初始密度 (kg/m^3)
params.compaction.max_density = 2400;          % 最大密度 (kg/m^3)
params.compaction.compaction_rate = 0.001;     % 压实速率系数
params.compaction.passes_required = 6;         % 标准压实遍数

% 压实度与振动力、速度的关系
params.compaction.optimal_speed = 2.0;         % 最佳压实速度 (m/s)
params.compaction.speed_efficiency = @(v) exp(-((v-2.0)/1.5)^2); % 速度效率函数

%% 8. 仿真参数
fprintf('正在设置仿真参数...\n');

params.sim.time_step = 0.01;              % 仿真时间步长 (s)
params.sim.duration = 100;                % 仿真总时长 (s)
params.sim.solver = 'ode45';              % 求解器类型
params.sim.relative_tolerance = 1e-3;     % 相对误差容限
params.sim.absolute_tolerance = 1e-6;     % 绝对误差容限

%% 9. 初始条件
fprintf('正在设置初始条件...\n');

initial.position = 0;                     % 初始位置 (m)
initial.velocity = 0;                     % 初始速度 (m/s)
initial.acceleration = 0;                 % 初始加速度 (m/s^2)
initial.throttle = 0;                     % 初始油门 (0-1)
initial.brake = 0;                        % 初始制动 (0-1)
initial.vibration_on = false;             % 振动系统初始状态
initial.gear = 1;                         % 初始档位

%% 10. 控制器参数
fprintf('正在加载控制器参数...\n');

params.controller.cruise_speed = 2.0;     % 巡航速度 (m/s)
params.controller.speed_kp = 5.0;         % 速度控制比例增益
params.controller.speed_ki = 0.5;         % 速度控制积分增益
params.controller.speed_kd = 0.2;         % 速度控制微分增益

% 自动压实模式参数
params.controller.auto_compaction_enabled = false;
params.controller.compaction_length = 50;  % 每段压实长度 (m)
params.controller.turn_around_time = 10;   % 掉头时间 (s)

%% 11. 传感器参数
fprintf('正在配置传感器参数...\n');

params.sensors.gps_accuracy = 0.01;        % GPS精度 (m)
params.sensors.speed_accuracy = 0.05;      % 速度传感器精度 (m/s)
params.sensors.vibration_accuracy = 1.0;   % 振动传感器精度 (kN)
params.sensors.compaction_accuracy = 0.5;  % 压实度传感器精度 (%)
params.sensors.sample_rate = 100;          % 传感器采样率 (Hz)

%% 12. 数据记录参数
fprintf('正在配置数据记录参数...\n');

params.logging.enabled = true;
params.logging.sample_rate = 10;           % 数据记录采样率 (Hz)
params.logging.variables = {
    'time', 'position', 'velocity', 'acceleration', ...
    'throttle', 'brake', 'gear', ...
    'engine_rpm', 'engine_power', 'engine_torque', ...
    'vibration_force', 'vibration_frequency', ...
    'compaction_density', 'compaction_degree', ...
    'rolling_resistance', 'air_resistance'
};

%% 13. 可视化参数
fprintf('正在配置可视化参数...\n');

params.visualization.enabled = true;
params.visualization.update_rate = 20;     % 可视化更新率 (Hz)
params.visualization.trail_length = 50;    % 轨迹长度 (m)
params.visualization.show_forces = true;   % 显示力矢量
params.visualization.show_compaction = true; % 显示压实度色图
params.visualization.camera_mode = 'follow'; % 摄像机模式: 'follow', 'fixed', 'top'

%% 14. 保存参数到工作空间
fprintf('正在保存参数到工作空间...\n');

assignin('base', 'params', params);
assignin('base', 'initial', initial);

%% 15. 创建数据目录
data_dir = '../data';
if ~exist(data_dir, 'dir')
    mkdir(data_dir);
end

%% 16. 打印参数摘要
fprintf('\n====================================\n');
fprintf('  参数加载完成!\n');
fprintf('====================================\n\n');
fprintf('压路机配置:\n');
fprintf('  质量: %.1f 吨\n', params.roller.mass/1000);
fprintf('  尺寸: %.1f × %.1f × %.1f m\n', params.roller.length, params.roller.width, params.roller.height);
fprintf('\n');
fprintf('发动机配置:\n');
fprintf('  最大功率: %d kW\n', params.engine.max_power);
fprintf('  最大扭矩: %d N·m\n', params.engine.max_torque);
fprintf('  额定转速: %d rpm\n', params.engine.rated_rpm);
fprintf('\n');
fprintf('振动系统配置:\n');
fprintf('  振动频率: %d Hz\n', params.vibration.frequency);
fprintf('  高振幅激振力: %d kN\n', params.vibration.amplitude_high);
fprintf('  低振幅激振力: %d kN\n', params.vibration.amplitude_low);
fprintf('\n');
fprintf('仿真配置:\n');
fprintf('  仿真时长: %d 秒\n', params.sim.duration);
fprintf('  时间步长: %.3f 秒\n', params.sim.time_step);
fprintf('  求解器: %s\n', params.sim.solver);
fprintf('\n');
fprintf('初始化完成! 您可以运行以下命令:\n');
fprintf('  - run_simulation()     : 运行标准仿真\n');
fprintf('  - visualize_results()  : 可视化结果\n');
fprintf('  - analyze_performance(): 分析压路机性能\n');
fprintf('====================================\n');

%% 17. 返回参数结构
if nargout > 0
    varargout{1} = params;
end
if nargout > 1
    varargout{2} = initial;
end
