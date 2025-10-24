function report = analyze_performance(results)
% 分析压路机性能并生成报告
%
% 输入:
%   results - 仿真结果结构体
%
% 输出:
%   report - 性能分析报告结构体
%
% 示例:
%   [out, res] = run_simulation();
%   report = analyze_performance(res);

    if nargin < 1
        % 加载最新的仿真结果
        data_dir = '../data';
        files = dir(fullfile(data_dir, 'simulation_*.mat'));
        
        if isempty(files)
            error('未找到仿真结果数据，请先运行 run_simulation()');
        end
        
        [~, idx] = max([files.datenum]);
        load(fullfile(data_dir, files(idx).name));
        fprintf('已加载数据: %s\n', files(idx).name);
    end
    
    fprintf('====================================\n');
    fprintf('  压路机性能分析报告\n');
    fprintf('====================================\n\n');
    
    %% 1. 运动性能分析
    fprintf('[ 运动性能分析 ]\n');
    fprintf('----------------------------------\n');
    
    % 速度统计
    report.motion.max_velocity = max(abs(results.velocity));
    report.motion.min_velocity = min(abs(results.velocity));
    report.motion.avg_velocity = mean(abs(results.velocity));
    report.motion.std_velocity = std(results.velocity);
    
    % 加速度估算
    dt = mean(diff(results.time));
    acceleration = diff(results.velocity) / dt;
    report.motion.max_acceleration = max(abs(acceleration));
    report.motion.avg_acceleration = mean(abs(acceleration(acceleration~=0)));
    
    % 行驶距离
    report.motion.total_distance = max(results.position) - min(results.position);
    report.motion.effective_time = sum(abs(results.velocity) > 0.1) * dt;
    
    fprintf('最大速度:       %.2f m/s (%.2f km/h)\n', ...
            report.motion.max_velocity, report.motion.max_velocity*3.6);
    fprintf('平均速度:       %.2f m/s (%.2f km/h)\n', ...
            report.motion.avg_velocity, report.motion.avg_velocity*3.6);
    fprintf('速度标准差:     %.2f m/s\n', report.motion.std_velocity);
    fprintf('最大加速度:     %.2f m/s²\n', report.motion.max_acceleration);
    fprintf('平均加速度:     %.2f m/s²\n', report.motion.avg_acceleration);
    fprintf('总行驶距离:     %.2f m\n', report.motion.total_distance);
    fprintf('有效工作时间:   %.1f s\n', report.motion.effective_time);
    fprintf('\n');
    
    %% 2. 振动系统性能
    fprintf('[ 振动系统性能 ]\n');
    fprintf('----------------------------------\n');
    
    % 识别振动工作时段
    vib_working = abs(results.vibration_force) > 1000; % 振动力 > 1kN
    
    if any(vib_working)
        report.vibration.working_time = sum(vib_working) * dt;
        report.vibration.start_time = results.time(find(vib_working, 1, 'first'));
        report.vibration.max_force = max(abs(results.vibration_force));
        report.vibration.avg_force = mean(abs(results.vibration_force(vib_working)));
        report.vibration.rms_force = sqrt(mean(results.vibration_force(vib_working).^2));
        
        % 估算振动频率（通过峰值检测）
        [peaks, locs] = findpeaks(results.vibration_force(vib_working));
        if length(locs) > 1
            time_between_peaks = mean(diff(locs)) * dt;
            report.vibration.measured_frequency = 1 / time_between_peaks;
        else
            report.vibration.measured_frequency = 30; % 设计频率
        end
        
        fprintf('振动工作时长:   %.1f s\n', report.vibration.working_time);
        fprintf('振动开始时间:   %.1f s\n', report.vibration.start_time);
        fprintf('最大激振力:     %.1f kN\n', report.vibration.max_force/1000);
        fprintf('平均激振力:     %.1f kN\n', report.vibration.avg_force/1000);
        fprintf('RMS激振力:      %.1f kN\n', report.vibration.rms_force/1000);
        fprintf('实测振动频率:   %.1f Hz\n', report.vibration.measured_frequency);
    else
        report.vibration.working_time = 0;
        fprintf('振动系统未启动\n');
    end
    fprintf('\n');
    
    %% 3. 压实效果分析
    fprintf('[ 压实效果分析 ]\n');
    fprintf('----------------------------------\n');
    
    report.compaction.final_value = results.compaction(end);
    report.compaction.max_rate = max(diff(results.compaction) / dt);
    report.compaction.avg_rate = mean(diff(results.compaction(results.compaction>0)) / dt);
    
    % 压实效率（单位距离的压实度）
    report.compaction.efficiency = report.compaction.final_value / report.motion.total_distance;
    
    % 压实均匀性（通过压实速率的标准差评估）
    compaction_rate = diff(results.compaction) / dt;
    report.compaction.uniformity = 1 - (std(compaction_rate(compaction_rate>0)) / ...
                                        mean(compaction_rate(compaction_rate>0)));
    
    fprintf('最终压实度:     %.2f\n', report.compaction.final_value);
    fprintf('最大压实速率:   %.4f /s\n', report.compaction.max_rate);
    fprintf('平均压实速率:   %.4f /s\n', report.compaction.avg_rate);
    fprintf('压实效率:       %.4f /m\n', report.compaction.efficiency);
    fprintf('压实均匀性:     %.2f %%\n', report.compaction.uniformity * 100);
    fprintf('\n');
    
    %% 4. 能耗估算
    fprintf('[ 能耗估算 ]\n');
    fprintf('----------------------------------\n');
    
    % 假设发动机参数
    engine_power = 150; % kW
    avg_load = 0.5;     % 平均负荷
    
    % 总能耗
    report.energy.total_consumption = engine_power * avg_load * ...
                                      results.time(end) / 3600; % kWh
    
    % 单位距离能耗
    report.energy.specific_consumption = report.energy.total_consumption / ...
                                         (report.motion.total_distance / 1000); % kWh/km
    
    % 单位压实度能耗
    if report.compaction.final_value > 0
        report.energy.compaction_consumption = report.energy.total_consumption / ...
                                               report.compaction.final_value; % kWh/unit
    else
        report.energy.compaction_consumption = 0;
    end
    
    fprintf('总能耗:         %.2f kWh\n', report.energy.total_consumption);
    fprintf('百公里能耗:     %.2f kWh/100km\n', ...
            report.energy.specific_consumption * 100);
    fprintf('单位压实能耗:   %.3f kWh/unit\n', report.energy.compaction_consumption);
    fprintf('\n');
    
    %% 5. 工作效率分析
    fprintf('[ 工作效率分析 ]\n');
    fprintf('----------------------------------\n');
    
    % 工作效率指标
    report.efficiency.distance_per_hour = report.motion.total_distance / ...
                                          (results.time(end) / 3600) / 1000; % km/h
    
    % 假设每段需要6遍压实
    passes_required = 6;
    lane_width = 2.1; % m
    
    % 估算覆盖面积（单遍）
    report.efficiency.area_coverage = report.motion.total_distance * lane_width; % m²
    
    % 每小时作业面积（考虑多遍）
    report.efficiency.area_per_hour = report.efficiency.area_coverage / ...
                                      passes_required / (results.time(end) / 3600); % m²/h
    
    % 转换为常用单位
    report.efficiency.area_per_shift = report.efficiency.area_per_hour * 8; % m²/班（8小时）
    
    fprintf('平均行驶速度:   %.2f km/h\n', report.efficiency.distance_per_hour);
    fprintf('单遍覆盖面积:   %.1f m²\n', report.efficiency.area_coverage);
    fprintf('小时作业量:     %.1f m²/h\n', report.efficiency.area_per_hour);
    fprintf('班产量(8h):     %.1f m² (%.3f 亩)\n', ...
            report.efficiency.area_per_shift, ...
            report.efficiency.area_per_shift / 666.67);
    fprintf('\n');
    
    %% 6. 综合评价
    fprintf('[ 综合性能评价 ]\n');
    fprintf('----------------------------------\n');
    
    % 计算综合得分（0-100分）
    % 考虑多个因素：速度稳定性、压实效率、能耗、工作时间利用率
    
    % 速度稳定性得分（CV越小越好）
    cv_velocity = report.motion.std_velocity / report.motion.avg_velocity;
    score_stability = max(0, 100 * (1 - cv_velocity));
    
    % 压实效率得分（效率越高越好，归一化到0-100）
    score_compaction = min(100, report.compaction.efficiency * 1000);
    
    % 时间利用率得分
    time_utilization = report.motion.effective_time / results.time(end);
    score_time = time_utilization * 100;
    
    % 压实均匀性得分
    score_uniformity = report.compaction.uniformity * 100;
    
    % 综合得分（加权平均）
    weights = [0.25, 0.35, 0.20, 0.20]; % 稳定性、压实效率、时间利用、均匀性
    report.evaluation.stability_score = score_stability;
    report.evaluation.compaction_score = score_compaction;
    report.evaluation.time_score = score_time;
    report.evaluation.uniformity_score = score_uniformity;
    report.evaluation.overall_score = sum([score_stability, score_compaction, ...
                                           score_time, score_uniformity] .* weights);
    
    % 性能等级
    overall = report.evaluation.overall_score;
    if overall >= 90
        report.evaluation.grade = '优秀';
    elseif overall >= 80
        report.evaluation.grade = '良好';
    elseif overall >= 70
        report.evaluation.grade = '中等';
    elseif overall >= 60
        report.evaluation.grade = '及格';
    else
        report.evaluation.grade = '需改进';
    end
    
    fprintf('速度稳定性得分: %.1f/100\n', score_stability);
    fprintf('压实效率得分:   %.1f/100\n', score_compaction);
    fprintf('时间利用率得分: %.1f/100\n', score_time);
    fprintf('压实均匀性得分: %.1f/100\n', score_uniformity);
    fprintf('----------------------------------\n');
    fprintf('综合得分:       %.1f/100\n', report.evaluation.overall_score);
    fprintf('性能等级:       %s\n', report.evaluation.grade);
    fprintf('\n');
    
    %% 7. 建议和改进
    fprintf('[ 优化建议 ]\n');
    fprintf('----------------------------------\n');
    
    suggestions = {};
    
    if report.motion.avg_velocity < 1.5
        suggestions{end+1} = '• 建议提高平均行驶速度以提高作业效率';
    elseif report.motion.avg_velocity > 3.5
        suggestions{end+1} = '• 速度过快可能影响压实质量，建议适当降低';
    end
    
    if report.vibration.working_time < results.time(end) * 0.5
        suggestions{end+1} = '• 振动工作时间较短，建议增加振动作业时间';
    end
    
    if score_uniformity < 80
        suggestions{end+1} = '• 压实均匀性有待提高，建议保持稳定的工作速度';
    end
    
    if time_utilization < 0.8
        suggestions{end+1} = '• 时间利用率较低，建议减少停机和等待时间';
    end
    
    if report.compaction.efficiency < 0.05
        suggestions{end+1} = '• 压实效率偏低，建议优化振动参数和行驶速度';
    end
    
    if isempty(suggestions)
        suggestions{1} = '• 当前性能表现良好，继续保持！';
    end
    
    report.suggestions = suggestions;
    
    for i = 1:length(suggestions)
        fprintf('%s\n', suggestions{i});
    end
    
    fprintf('\n====================================\n');
    fprintf('性能分析报告生成完成!\n');
    fprintf('====================================\n');
    
    %% 8. 保存报告
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    report_file = sprintf('../data/performance_report_%s.mat', timestamp);
    save(report_file, 'report');
    
    % 同时保存文本报告
    txt_file = sprintf('../data/performance_report_%s.txt', timestamp);
    diary(txt_file);
    diary off;
    
    fprintf('报告已保存到: %s\n', report_file);
    
end
