% 优化示例：寻找最佳工作参数
%
% 本示例演示如何：
%   1. 测试不同的工作参数
%   2. 比较仿真结果
%   3. 找到最优配置
%
% 作者: AI Assistant
% 日期: 2025-10-24

clear all;
close all;
clc;

fprintf('========================================\n');
fprintf('  压路机参数优化示例\n');
fprintf('========================================\n\n');

%% 1. 初始化
fprintf('>> 初始化系统...\n');
cd ..
init_simulation();
cd examples
fprintf('   ✓ 完成\n\n');

%% 2. 定义测试参数范围
fprintf('>> 定义测试参数\n');

% 测试不同的油门值
throttle_values = 0.3:0.1:0.8;
n_tests = length(throttle_values);

fprintf('   测试油门范围: %.1f - %.1f\n', min(throttle_values), max(throttle_values));
fprintf('   测试数量: %d\n\n', n_tests);

%% 3. 批量运行仿真
fprintf('>> 开始批量仿真...\n');

% 存储结果
results_all = cell(n_tests, 1);
metrics = struct();

for i = 1:n_tests
    fprintf('   [%d/%d] 测试油门 %.1f%%...', i, n_tests, throttle_values(i)*100);
    
    % 运行仿真（关闭可视化以加快速度）
    [~, results_all{i}] = run_simulation(...
        'duration', 50, ...
        'throttle', throttle_values(i), ...
        'vibration', 8, ...
        'visualize', false, ...
        'save_data', false);
    
    % 提取关键指标
    metrics.max_velocity(i) = results_all{i}.metrics.max_velocity;
    metrics.avg_velocity(i) = results_all{i}.metrics.avg_velocity;
    metrics.total_distance(i) = results_all{i}.metrics.total_distance;
    metrics.final_compaction(i) = results_all{i}.metrics.final_compaction;
    
    % 计算综合效率（压实度/时间）
    metrics.efficiency(i) = metrics.final_compaction(i) / 50;
    
    fprintf(' 完成 (距离: %.1f m, 压实度: %.1f)\n', ...
            metrics.total_distance(i), metrics.final_compaction(i));
end

fprintf('   ✓ 批量仿真完成\n\n');

%% 4. 分析结果
fprintf('>> 结果分析\n');
fprintf('========================================\n');

% 找到最优配置
[max_efficiency, idx_best] = max(metrics.efficiency);
best_throttle = throttle_values(idx_best);

fprintf('最优配置:\n');
fprintf('  最佳油门:     %.1f%%\n', best_throttle * 100);
fprintf('  平均速度:     %.2f m/s\n', metrics.avg_velocity(idx_best));
fprintf('  总行驶距离:   %.2f m\n', metrics.total_distance(idx_best));
fprintf('  最终压实度:   %.2f\n', metrics.final_compaction(idx_best));
fprintf('  压实效率:     %.4f /s\n', max_efficiency);
fprintf('========================================\n\n');

% 性能比较表
fprintf('详细比较:\n');
fprintf('油门(%%)\t速度(m/s)\t距离(m)\t\t压实度\t\t效率(/s)\n');
fprintf('------------------------------------------------------------------------\n');
for i = 1:n_tests
    fprintf('%.0f\t\t%.2f\t\t%.2f\t\t%.2f\t\t%.4f', ...
            throttle_values(i)*100, ...
            metrics.avg_velocity(i), ...
            metrics.total_distance(i), ...
            metrics.final_compaction(i), ...
            metrics.efficiency(i));
    
    if i == idx_best
        fprintf(' <-- 最优');
    end
    fprintf('\n');
end
fprintf('------------------------------------------------------------------------\n\n');

%% 5. 可视化比较
fprintf('>> 生成对比图表\n\n');

figure('Name', '参数优化结果', 'Position', [100, 100, 1400, 800]);

% 子图1: 速度vs油门
subplot(2, 3, 1);
plot(throttle_values*100, metrics.avg_velocity, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(best_throttle*100, metrics.avg_velocity(idx_best), 'r*', 'MarkerSize', 15);
grid on;
xlabel('油门开度 (%)');
ylabel('平均速度 (m/s)');
title('速度 vs 油门');
legend('测试数据', '最优点', 'Location', 'northwest');

% 子图2: 距离vs油门
subplot(2, 3, 2);
plot(throttle_values*100, metrics.total_distance, 'g-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(best_throttle*100, metrics.total_distance(idx_best), 'r*', 'MarkerSize', 15);
grid on;
xlabel('油门开度 (%)');
ylabel('总行驶距离 (m)');
title('距离 vs 油门');
legend('测试数据', '最优点', 'Location', 'northwest');

% 子图3: 压实度vs油门
subplot(2, 3, 3);
plot(throttle_values*100, metrics.final_compaction, 'm-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(best_throttle*100, metrics.final_compaction(idx_best), 'r*', 'MarkerSize', 15);
grid on;
xlabel('油门开度 (%)');
ylabel('最终压实度');
title('压实度 vs 油门');
legend('测试数据', '最优点', 'Location', 'northwest');

% 子图4: 效率vs油门（重点）
subplot(2, 3, 4);
plot(throttle_values*100, metrics.efficiency, 'r-o', 'LineWidth', 2.5, 'MarkerSize', 8);
hold on;
plot(best_throttle*100, max_efficiency, 'g*', 'MarkerSize', 20, 'LineWidth', 2);
grid on;
xlabel('油门开度 (%)');
ylabel('压实效率 (/s)');
title('【压实效率 vs 油门】（关键指标）');
legend('测试数据', '最优点', 'Location', 'best');

% 子图5: 雷达图比较最优与平均
subplot(2, 3, 5);
% 归一化数据
norm_speed = metrics.avg_velocity(idx_best) / max(metrics.avg_velocity);
norm_distance = metrics.total_distance(idx_best) / max(metrics.total_distance);
norm_compaction = metrics.final_compaction(idx_best) / max(metrics.final_compaction);
norm_efficiency = metrics.efficiency(idx_best) / max(metrics.efficiency);

avg_norm_speed = mean(metrics.avg_velocity) / max(metrics.avg_velocity);
avg_norm_distance = mean(metrics.total_distance) / max(metrics.total_distance);
avg_norm_compaction = mean(metrics.final_compaction) / max(metrics.final_compaction);
avg_norm_efficiency = mean(metrics.efficiency) / max(metrics.efficiency);

categories = {'速度', '距离', '压实度', '效率'};
best_values = [norm_speed, norm_distance, norm_compaction, norm_efficiency];
avg_values = [avg_norm_speed, avg_norm_distance, avg_norm_compaction, avg_norm_efficiency];

x_pos = 1:length(categories);
bar_width = 0.35;

bar(x_pos - bar_width/2, best_values, bar_width, 'FaceColor', [0.2 0.7 0.2]);
hold on;
bar(x_pos + bar_width/2, avg_values, bar_width, 'FaceColor', [0.7 0.7 0.7]);
set(gca, 'XTick', x_pos, 'XTickLabel', categories);
ylabel('归一化值');
title('最优配置 vs 平均性能');
legend('最优配置', '平均性能', 'Location', 'northwest');
grid on;
ylim([0, 1.1]);

% 子图6: 性能总结
subplot(2, 3, 6);
axis off;
summary_text = {
    '╔════════════════════════════════╗'
    '║    优化结果总结                ║'
    '╠════════════════════════════════╣'
    sprintf('║ 最佳油门:   %.0f%%             ║', best_throttle*100)
    sprintf('║ 平均速度:   %.2f m/s         ║', metrics.avg_velocity(idx_best))
    sprintf('║ 行驶距离:   %.1f m          ║', metrics.total_distance(idx_best))
    sprintf('║ 压实度:     %.2f            ║', metrics.final_compaction(idx_best))
    sprintf('║ 效率:       %.4f /s        ║', max_efficiency)
    '╠════════════════════════════════╣'
    '║    性能提升                    ║'
    '╠════════════════════════════════╣'
    sprintf('║ vs 最低效率: +%.1f%%         ║', ...
            (max_efficiency/min(metrics.efficiency)-1)*100)
    sprintf('║ vs 平均效率: +%.1f%%         ║', ...
            (max_efficiency/mean(metrics.efficiency)-1)*100)
    '╠════════════════════════════════╣'
    '║    建议                        ║'
    '╠════════════════════════════════╣'
    '║ • 使用最佳油门配置             ║'
    '║ • 保持稳定工作速度             ║'
    '║ • 定期监测压实效果             ║'
    '╚════════════════════════════════╝'
};

text(0.1, 0.95, summary_text, 'FontSize', 9, 'FontName', 'Courier New', ...
     'VerticalAlignment', 'top', 'FontWeight', 'bold');

sgtitle('压路机工作参数优化分析', 'FontSize', 14, 'FontWeight', 'bold');

fprintf('   ✓ 图表生成完成\n\n');

%% 6. 保存优化结果
fprintf('>> 保存优化结果\n');

optimization_results = struct();
optimization_results.throttle_values = throttle_values;
optimization_results.metrics = metrics;
optimization_results.best_throttle = best_throttle;
optimization_results.best_index = idx_best;
optimization_results.max_efficiency = max_efficiency;

% 保存到数据文件
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
save_file = sprintf('../data/optimization_results_%s.mat', timestamp);
save(save_file, 'optimization_results', 'results_all');

fprintf('   ✓ 结果已保存: %s\n\n', save_file);

%% 完成
fprintf('========================================\n');
fprintf('  参数优化示例完成！\n');
fprintf('========================================\n');
fprintf('\n关键发现:\n');
fprintf('  • 最佳油门开度: %.0f%%\n', best_throttle*100);
fprintf('  • 可获得最高的压实效率\n');
fprintf('  • 在速度和压实质量间达到最佳平衡\n\n');
fprintf('您可以在实际工作中应用这些发现！\n\n');
