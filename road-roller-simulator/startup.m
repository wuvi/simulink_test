% 压路机仿真系统启动脚本
% 
% 此脚本会自动设置路径并启动主程序
% 可以从任何目录运行此脚本
%
% 使用方法:
%   >> startup

fprintf('\n========================================\n');
fprintf('  压路机仿真系统启动中...\n');
fprintf('========================================\n\n');

%% 1. 定位到正确的目录
% 获取此脚本所在目录
script_dir = fileparts(mfilename('fullpath'));

fprintf('项目根目录: %s\n', script_dir);

% 切换到项目目录
cd(script_dir);
fprintf('工作目录已设置为: %s\n\n', pwd);

%% 2. 添加所有必要路径
fprintf('正在添加项目路径...\n');

subdirs = {'models', 'scripts', 'utils', 'data', 'examples', 'docs'};
for i = 1:length(subdirs)
    subdir_path = fullfile(script_dir, subdirs{i});
    if exist(subdir_path, 'dir')
        addpath(subdir_path);
        fprintf('  ✓ %s\n', subdirs{i});
    end
end

fprintf('\n路径配置完成!\n\n');

%% 3. 验证关键文件
fprintf('正在验证关键文件...\n');

key_files = {
    'scripts/init_simulation.m'
    'scripts/run_simulation.m'
    'scripts/visualize_results.m'
    'utils/analyze_performance.m'
    'models/RoadRollerSimulation.m'
};

all_found = true;
for i = 1:length(key_files)
    file_path = fullfile(script_dir, key_files{i});
    if exist(file_path, 'file')
        fprintf('  ✓ %s\n', key_files{i});
    else
        fprintf('  ✗ %s (未找到)\n', key_files{i});
        all_found = false;
    end
end

if ~all_found
    fprintf('\n警告: 部分文件未找到，系统可能无法正常运行\n');
end

fprintf('\n文件验证完成!\n\n');

%% 4. 测试核心函数
fprintf('正在测试核心函数...\n');

try
    % 测试 init_simulation 是否可以被找到
    which_init = which('init_simulation');
    if isempty(which_init)
        error('找不到 init_simulation 函数');
    end
    fprintf('  ✓ init_simulation: %s\n', which_init);
    
    % 测试 run_simulation
    which_run = which('run_simulation');
    if isempty(which_run)
        error('找不到 run_simulation 函数');
    end
    fprintf('  ✓ run_simulation: %s\n', which_run);
    
    % 测试 visualize_results
    which_vis = which('visualize_results');
    if isempty(which_vis)
        error('找不到 visualize_results 函数');
    end
    fprintf('  ✓ visualize_results: %s\n', which_vis);
    
    % 测试 analyze_performance
    which_perf = which('analyze_performance');
    if isempty(which_perf)
        error('找不到 analyze_performance 函数');
    end
    fprintf('  ✓ analyze_performance: %s\n', which_perf);
    
    fprintf('\n核心函数验证成功!\n\n');
    
catch ME
    fprintf('\n错误: %s\n', ME.message);
    fprintf('系统可能无法正常运行\n\n');
    return;
end

%% 5. 显示系统信息
fprintf('========================================\n');
fprintf('  系统准备就绪!\n');
fprintf('========================================\n\n');

fprintf('可用命令:\n');
fprintf('  main                  - 启动交互式主程序\n');
fprintf('  test_basic            - 运行基本功能测试\n');
fprintf('  init_simulation()     - 初始化仿真参数\n');
fprintf('  run_simulation()      - 运行仿真\n');
fprintf('  visualize_results()   - 可视化结果\n');
fprintf('  analyze_performance() - 分析性能\n');
fprintf('\n');

fprintf('示例脚本:\n');
fprintf('  cd examples\n');
fprintf('  example_basic         - 基本使用示例\n');
fprintf('  example_optimization  - 参数优化示例\n');
fprintf('\n');

%% 6. 询问是否启动主程序
fprintf('========================================\n\n');
response = input('是否启动主程序? (Y/n): ', 's');

if isempty(response) || lower(response) == 'y'
    fprintf('\n正在启动主程序...\n\n');
    pause(0.5);
    main;
else
    fprintf('\n准备完成! 您可以手动运行命令。\n');
    fprintf('提示: 输入 main 启动主程序\n\n');
end
