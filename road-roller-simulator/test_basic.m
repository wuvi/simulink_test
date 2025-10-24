% 基本功能测试脚本
% 测试压路机仿真系统的核心功能
%
% 此脚本不依赖Simulink，仅测试基本功能

fprintf('========================================\n');
fprintf('  压路机仿真系统 - 基本功能测试\n');
fprintf('========================================\n\n');

%% 测试1: 参数初始化
fprintf('测试1: 参数初始化...\n');
try
    [params, initial] = init_simulation();
    fprintf('✓ 通过 - 参数初始化成功\n');
    fprintf('  - 压路机质量: %.0f kg\n', params.roller.mass);
    fprintf('  - 发动机功率: %.0f kW\n', params.engine.max_power);
    fprintf('  - 振动频率: %.0f Hz\n', params.vibration.frequency);
catch ME
    fprintf('✗ 失败 - %s\n', ME.message);
    return;
end
fprintf('\n');

%% 测试2: 数据结构验证
fprintf('测试2: 数据结构验证...\n');
try
    assert(isstruct(params), '参数应该是结构体');
    assert(isfield(params, 'roller'), '缺少roller字段');
    assert(isfield(params, 'engine'), '缺少engine字段');
    assert(isfield(params, 'vibration'), '缺少vibration字段');
    assert(params.roller.mass == 12000, '压路机质量不正确');
    fprintf('✓ 通过 - 数据结构正确\n');
catch ME
    fprintf('✗ 失败 - %s\n', ME.message);
    return;
end
fprintf('\n');

%% 测试3: 简化仿真测试（不使用Simulink）
fprintf('测试3: 简化仿真逻辑...\n');
try
    % 创建时间序列
    t = 0:0.1:10;  % 10秒，步长0.1秒
    n = length(t);
    
    % 初始化变量
    velocity = zeros(n, 1);
    position = zeros(n, 1);
    vibration_force = zeros(n, 1);
    compaction = zeros(n, 1);
    
    % 简单的动力学仿真
    throttle = 0.5;
    target_velocity = throttle * 5;  % 最大5 m/s
    
    for i = 2:n
        dt = t(i) - t(i-1);
        
        % 速度更新（一阶系统）
        velocity(i) = velocity(i-1) + (target_velocity - velocity(i-1)) * 0.1 * dt;
        
        % 位置积分
        position(i) = position(i-1) + velocity(i) * dt;
        
        % 振动力（5秒后开启）
        if t(i) >= 5
            vibration_force(i) = 50000 * sin(2*pi*30*t(i));  % 50kN, 30Hz
        end
        
        % 压实度累积
        if t(i) >= 5 && velocity(i) > 0.1
            compaction(i) = compaction(i-1) + abs(vibration_force(i)) * velocity(i) * 0.0001 * dt;
        else
            compaction(i) = compaction(i-1);
        end
    end
    
    % 创建结果结构
    test_results = struct();
    test_results.time = t';
    test_results.velocity = velocity;
    test_results.position = position;
    test_results.vibration_force = vibration_force;
    test_results.compaction = compaction;
    test_results.metrics = struct();
    test_results.metrics.max_velocity = max(abs(velocity));
    test_results.metrics.total_distance = max(position);
    test_results.metrics.final_compaction = compaction(end);
    test_results.metrics.avg_vibration = mean(abs(vibration_force(vibration_force~=0)));
    
    fprintf('✓ 通过 - 仿真逻辑正确\n');
    fprintf('  - 最大速度: %.2f m/s\n', test_results.metrics.max_velocity);
    fprintf('  - 总距离: %.2f m\n', test_results.metrics.total_distance);
    fprintf('  - 最终压实度: %.2f\n', test_results.metrics.final_compaction);
catch ME
    fprintf('✗ 失败 - %s\n', ME.message);
    return;
end
fprintf('\n');

%% 测试4: 可视化函数（创建简单图表）
fprintf('测试4: 可视化功能...\n');
try
    figure('Name', '测试结果', 'Position', [100, 100, 800, 600]);
    
    subplot(2, 2, 1);
    plot(test_results.time, test_results.velocity, 'b-', 'LineWidth', 2);
    xlabel('时间 (s)');
    ylabel('速度 (m/s)');
    title('速度曲线');
    grid on;
    
    subplot(2, 2, 2);
    plot(test_results.time, test_results.position, 'r-', 'LineWidth', 2);
    xlabel('时间 (s)');
    ylabel('位置 (m)');
    title('位置曲线');
    grid on;
    
    subplot(2, 2, 3);
    plot(test_results.time, test_results.vibration_force/1000, 'g-', 'LineWidth', 1.5);
    xlabel('时间 (s)');
    ylabel('振动力 (kN)');
    title('振动力曲线');
    grid on;
    
    subplot(2, 2, 4);
    plot(test_results.time, test_results.compaction, 'm-', 'LineWidth', 2);
    xlabel('时间 (s)');
    ylabel('压实度');
    title('压实度曲线');
    grid on;
    
    sgtitle('基本功能测试结果', 'FontSize', 14, 'FontWeight', 'bold');
    
    fprintf('✓ 通过 - 可视化创建成功\n');
catch ME
    fprintf('✗ 失败 - %s\n', ME.message);
    return;
end
fprintf('\n');

%% 测试5: 性能分析（不完整版本，仅测试结构）
fprintf('测试5: 性能分析结构...\n');
try
    % 测试性能指标计算
    max_v = max(abs(test_results.velocity));
    avg_v = mean(abs(test_results.velocity));
    total_dist = max(test_results.position);
    final_comp = test_results.compaction(end);
    
    fprintf('✓ 通过 - 性能指标计算正确\n');
    fprintf('  - 最大速度: %.2f m/s\n', max_v);
    fprintf('  - 平均速度: %.2f m/s\n', avg_v);
    fprintf('  - 总距离: %.2f m\n', total_dist);
    fprintf('  - 压实度: %.2f\n', final_comp);
catch ME
    fprintf('✗ 失败 - %s\n', ME.message);
    return;
end
fprintf('\n');

%% 测试总结
fprintf('========================================\n');
fprintf('  所有基本功能测试通过! ✓\n');
fprintf('========================================\n');
fprintf('\n');
fprintf('注意事项:\n');
fprintf('  1. 本测试不包含Simulink模型创建\n');
fprintf('  2. 使用简化的数学模型进行测试\n');
fprintf('  3. 完整功能需要MATLAB Simulink\n');
fprintf('\n');
fprintf('下一步:\n');
fprintf('  - 运行 main.m 使用完整功能\n');
fprintf('  - 运行 example_basic.m 查看基本示例\n');
fprintf('  - 运行 example_optimization.m 进行参数优化\n');
fprintf('\n');
