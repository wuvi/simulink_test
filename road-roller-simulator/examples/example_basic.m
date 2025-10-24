% 基本示例：运行简单的压路机仿真
%
% 本示例演示如何：
%   1. 初始化系统
%   2. 运行基本仿真
%   3. 查看结果
%
% 作者: AI Assistant
% 日期: 2025-10-24

clear all;
close all;
clc;

fprintf('========================================\n');
fprintf('  压路机仿真 - 基本示例\n');
fprintf('========================================\n\n');

%% 1. 初始化系统
fprintf('>> 步骤 1: 初始化仿真参数\n');
cd ..
init_simulation;
cd examples

fprintf('   ✓ 参数加载完成\n\n');

%% 2. 运行仿真
fprintf('>> 步骤 2: 运行30秒仿真\n');
fprintf('   参数设置:\n');
fprintf('   - 仿真时长: 30秒\n');
fprintf('   - 油门开度: 50%%\n');
fprintf('   - 振动开启: 10秒后\n\n');

[simOut, results] = run_simulation(...
    'duration', 30, ...
    'throttle', 0.5, ...
    'vibration', 10, ...
    'visualize', false, ...
    'save_data', false);

fprintf('   ✓ 仿真完成\n\n');

%% 3. 显示结果摘要
fprintf('>> 步骤 3: 结果摘要\n');
fprintf('========================================\n');
fprintf('运动性能:\n');
fprintf('  最大速度:     %.2f m/s (%.1f km/h)\n', ...
        results.metrics.max_velocity, ...
        results.metrics.max_velocity * 3.6);
fprintf('  平均速度:     %.2f m/s (%.1f km/h)\n', ...
        results.metrics.avg_velocity, ...
        results.metrics.avg_velocity * 3.6);
fprintf('  总行驶距离:   %.2f m\n', results.metrics.total_distance);
fprintf('\n');
fprintf('压实效果:\n');
fprintf('  最终压实度:   %.2f\n', results.metrics.final_compaction);
fprintf('  平均振动力:   %.1f kN\n', results.metrics.avg_vibration);
fprintf('========================================\n\n');

%% 4. 绘制简单图表
fprintf('>> 步骤 4: 生成结果图表\n\n');

figure('Name', '基本仿真结果', 'Position', [100, 100, 1200, 400]);

% 子图1: 速度
subplot(1, 3, 1);
plot(results.time, results.velocity, 'b-', 'LineWidth', 2);
grid on;
xlabel('时间 (s)');
ylabel('速度 (m/s)');
title('压路机速度');

% 子图2: 位置
subplot(1, 3, 2);
plot(results.time, results.position, 'r-', 'LineWidth', 2);
grid on;
xlabel('时间 (s)');
ylabel('位置 (m)');
title('压路机位置');

% 子图3: 压实度
subplot(1, 3, 3);
plot(results.time, results.compaction, 'm-', 'LineWidth', 2);
grid on;
xlabel('时间 (s)');
ylabel('累计压实度');
title('压实效果');

sgtitle('压路机仿真基本结果', 'FontSize', 14, 'FontWeight', 'bold');

fprintf('   ✓ 图表生成完成\n\n');

%% 完成
fprintf('========================================\n');
fprintf('  示例运行完成！\n');
fprintf('========================================\n');
fprintf('\n提示: 您可以尝试修改参数重新运行:\n');
fprintf('  - 更改油门值 (0-1)\n');
fprintf('  - 调整仿真时长\n');
fprintf('  - 改变振动开启时间\n\n');
