% 压路机虚拟仿真系统 - 主程序
% 
% 这是压路机Simulink仿真系统的主入口程序
% 
% 功能:
%   1. 创建Simulink压路机动力学模型
%   2. 运行仿真并收集数据
%   3. 可视化仿真结果
%   4. 分析压路机性能
%
% 使用方法:
%   直接运行此脚本，或使用以下命令:
%   >> main
%
% 项目结构:
%   /models   - Simulink模型文件
%   /scripts  - 仿真脚本
%   /utils    - 工具函数
%   /data     - 仿真数据存储
%   /docs     - 文档
%   /images   - 图像资源
%
% 作者: AI Assistant
% 日期: 2025-10-24
% 版本: 1.0

clear all;
close all;
clc;

%% 显示欢迎信息
fprintf('\n');
fprintf('╔════════════════════════════════════════════════════════════╗\n');
fprintf('║                                                            ║\n');
fprintf('║        压路机虚拟仿真系统 v1.0                             ║\n');
fprintf('║        Road Roller Virtual Simulation System               ║\n');
fprintf('║                                                            ║\n');
fprintf('║        基于MATLAB/Simulink开发                             ║\n');
fprintf('║                                                            ║\n');
fprintf('╚════════════════════════════════════════════════════════════╝\n');
fprintf('\n');

%% 添加路径
fprintf('正在配置系统环境...\n');
addpath('models');
addpath('scripts');
addpath('utils');
addpath('data');

fprintf('✓ 路径配置完成\n\n');

%% 显示菜单
while true
    fprintf('════════════════════════════════════════\n');
    fprintf('  主菜单\n');
    fprintf('════════════════════════════════════════\n');
    fprintf('  1. 初始化仿真参数\n');
    fprintf('  2. 创建Simulink模型\n');
    fprintf('  3. 运行标准仿真\n');
    fprintf('  4. 运行自定义仿真\n');
    fprintf('  5. 可视化仿真结果\n');
    fprintf('  6. 性能分析报告\n');
    fprintf('  7. 快速演示（完整流程）\n');
    fprintf('  8. 帮助文档\n');
    fprintf('  0. 退出系统\n');
    fprintf('════════════════════════════════════════\n');
    
    choice = input('请选择操作 (0-8): ', 's');
    fprintf('\n');
    
    switch choice
        case '1'
            % 初始化仿真参数
            fprintf('[ 初始化仿真参数 ]\n');
            fprintf('----------------------------------\n');
            try
                init_simulation;
                fprintf('✓ 参数初始化成功!\n');
            catch ME
                fprintf('✗ 初始化失败: %s\n', ME.message);
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '2'
            % 创建Simulink模型
            fprintf('[ 创建Simulink模型 ]\n');
            fprintf('----------------------------------\n');
            try
                cd models;
                RoadRollerSimulation;
                cd ..;
                fprintf('✓ Simulink模型创建成功!\n');
            catch ME
                fprintf('✗ 模型创建失败: %s\n', ME.message);
                if contains(ME.message, 'Simulink')
                    fprintf('\n提示: 此功能需要MATLAB Simulink工具箱\n');
                    fprintf('如果未安装Simulink，请使用菜单选项3运行数学仿真\n');
                end
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '3'
            % 运行标准仿真
            fprintf('[ 运行标准仿真 ]\n');
            fprintf('----------------------------------\n');
            fprintf('使用默认参数运行仿真...\n');
            fprintf('  • 仿真时长: 100秒\n');
            fprintf('  • 油门: 0.5\n');
            fprintf('  • 振动开启时间: 10秒\n');
            fprintf('  • 启用可视化\n\n');
            
            try
                [simOut, results] = run_simulation('visualize', true);
                fprintf('✓ 仿真运行成功!\n');
            catch ME
                fprintf('✗ 仿真失败: %s\n', ME.message);
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '4'
            % 运行自定义仿真
            fprintf('[ 自定义仿真参数 ]\n');
            fprintf('----------------------------------\n');
            
            duration = input('仿真时长 (秒, 默认100): ');
            if isempty(duration), duration = 100; end
            
            throttle = input('油门开度 (0-1, 默认0.5): ');
            if isempty(throttle), throttle = 0.5; end
            
            brake = input('制动力 (0-1, 默认0): ');
            if isempty(brake), brake = 0; end
            
            vibration_time = input('振动开启时间 (秒, 默认10): ');
            if isempty(vibration_time), vibration_time = 10; end
            
            visualize = input('是否可视化? (1=是, 0=否, 默认1): ');
            if isempty(visualize), visualize = 1; end
            visualize = logical(visualize);
            
            fprintf('\n正在运行自定义仿真...\n');
            try
                [simOut, results] = run_simulation(...
                    'duration', duration, ...
                    'throttle', throttle, ...
                    'brake', brake, ...
                    'vibration', vibration_time, ...
                    'visualize', visualize);
                fprintf('✓ 自定义仿真运行成功!\n');
            catch ME
                fprintf('✗ 仿真失败: %s\n', ME.message);
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '5'
            % 可视化仿真结果
            fprintf('[ 可视化仿真结果 ]\n');
            fprintf('----------------------------------\n');
            try
                visualize_results();
                fprintf('✓ 可视化生成成功!\n');
            catch ME
                fprintf('✗ 可视化失败: %s\n', ME.message);
                if contains(ME.message, '未找到')
                    fprintf('\n提示: 请先运行仿真 (选项3或4)\n');
                end
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '6'
            % 性能分析报告
            fprintf('[ 生成性能分析报告 ]\n');
            fprintf('----------------------------------\n');
            try
                report = analyze_performance();
                fprintf('✓ 性能分析报告生成成功!\n');
            catch ME
                fprintf('✗ 报告生成失败: %s\n', ME.message);
                if contains(ME.message, '未找到')
                    fprintf('\n提示: 请先运行仿真 (选项3或4)\n');
                end
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '7'
            % 快速演示
            fprintf('[ 快速演示模式 ]\n');
            fprintf('----------------------------------\n');
            fprintf('将自动执行完整的仿真流程:\n');
            fprintf('  1. 初始化参数\n');
            fprintf('  2. 运行仿真\n');
            fprintf('  3. 可视化结果\n');
            fprintf('  4. 性能分析\n\n');
            
            confirm = input('是否继续? (Y/n): ', 's');
            if isempty(confirm) || lower(confirm) == 'y'
                try
                    % 步骤1: 初始化
                    fprintf('\n>>> 步骤1: 初始化参数\n');
                    init_simulation;
                    pause(1);
                    
                    % 步骤2: 运行仿真
                    fprintf('\n>>> 步骤2: 运行仿真\n');
                    [simOut, results] = run_simulation(...
                        'duration', 60, ...
                        'throttle', 0.6, ...
                        'visualize', false);
                    pause(1);
                    
                    % 步骤3: 可视化
                    fprintf('\n>>> 步骤3: 可视化结果\n');
                    visualize_results(results);
                    pause(2);
                    
                    % 步骤4: 性能分析
                    fprintf('\n>>> 步骤4: 性能分析\n');
                    report = analyze_performance(results);
                    
                    fprintf('\n✓ 快速演示完成!\n');
                catch ME
                    fprintf('✗ 演示过程出错: %s\n', ME.message);
                end
            end
            fprintf('\n');
            input('按回车键继续...');
            
        case '8'
            % 帮助文档
            fprintf('[ 帮助文档 ]\n');
            fprintf('════════════════════════════════════════\n');
            fprintf('\n系统简介:\n');
            fprintf('  本系统是基于MATLAB/Simulink开发的压路机虚拟仿真平台，\n');
            fprintf('  用于模拟压路机的动力学行为、振动系统和压实过程。\n\n');
            
            fprintf('主要功能:\n');
            fprintf('  • 完整的压路机动力学模型 (12吨，150kW)\n');
            fprintf('  • 振动系统仿真 (30Hz，50kN)\n');
            fprintf('  • 路面压实效果计算\n');
            fprintf('  • 实时可视化和动画演示\n');
            fprintf('  • 性能分析和优化建议\n\n');
            
            fprintf('使用流程:\n');
            fprintf('  1. 首次使用请先初始化参数 (选项1)\n');
            fprintf('  2. 创建或加载Simulink模型 (选项2)\n');
            fprintf('  3. 运行仿真 (选项3或4)\n');
            fprintf('  4. 查看结果 (选项5和6)\n\n');
            
            fprintf('技术参数:\n');
            fprintf('  • 压路机质量: 12000 kg\n');
            fprintf('  • 发动机功率: 150 kW\n');
            fprintf('  • 振动频率: 30 Hz\n');
            fprintf('  • 激振力: 50 kN\n');
            fprintf('  • 钢轮宽度: 2.1 m\n');
            fprintf('  • 轴距: 3.0 m\n\n');
            
            fprintf('文件说明:\n');
            fprintf('  • init_simulation.m      - 参数初始化脚本\n');
            fprintf('  • run_simulation.m       - 仿真运行脚本\n');
            fprintf('  • visualize_results.m    - 结果可视化脚本\n');
            fprintf('  • analyze_performance.m  - 性能分析工具\n');
            fprintf('  • RoadRollerSimulation.m - Simulink模型创建\n\n');
            
            fprintf('常见问题:\n');
            fprintf('  Q: 提示未找到Simulink?\n');
            fprintf('  A: 本系统需要MATLAB Simulink工具箱。如果未安装，\n');
            fprintf('     仍可使用数学仿真功能 (选项3)。\n\n');
            
            fprintf('  Q: 如何修改压路机参数?\n');
            fprintf('  A: 运行 init_simulation.m 后，在工作空间中修改\n');
            fprintf('     params 结构体的相应字段。\n\n');
            
            fprintf('  Q: 如何保存仿真结果?\n');
            fprintf('  A: 仿真数据自动保存在 data/ 目录下，文件名包含时间戳。\n\n');
            
            fprintf('联系方式:\n');
            fprintf('  如有问题或建议，请联系开发团队。\n');
            fprintf('\n════════════════════════════════════════\n');
            input('按回车键继续...');
            
        case '0'
            % 退出系统
            fprintf('感谢使用压路机虚拟仿真系统!\n');
            fprintf('再见!\n\n');
            break;
            
        otherwise
            fprintf('无效的选择，请输入 0-8 之间的数字。\n\n');
            pause(1);
    end
    
    clc;
end
