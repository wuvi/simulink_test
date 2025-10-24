function visualize_results(results)
% 可视化压路机仿真结果
% 
% 输入:
%   results - 包含仿真结果的结构体
%
% 该函数创建多个图表展示:
%   1. 速度时间历程
%   2. 位置轨迹
%   3. 振动力时间历程
%   4. 压实度变化
%   5. 压路机动画演示

    if nargin < 1
        % 如果没有输入，尝试从工作空间加载最新数据
        data_dir = '../data';
        files = dir(fullfile(data_dir, 'simulation_*.mat'));
        
        if isempty(files)
            error('未找到仿真结果数据，请先运行 run_simulation()');
        end
        
        % 加载最新的文件
        [~, idx] = max([files.datenum]);
        load(fullfile(data_dir, files(idx).name));
        fprintf('已加载数据: %s\n', files(idx).name);
    end
    
    %% 创建主图形窗口
    figure('Name', '压路机仿真结果', 'NumberTitle', 'off', ...
           'Position', [100, 100, 1400, 900], 'Color', 'white');
    
    %% 子图1: 速度-时间曲线
    subplot(2, 3, 1);
    plot(results.time, results.velocity, 'b-', 'LineWidth', 2);
    grid on;
    xlabel('时间 (s)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('速度 (m/s)', 'FontSize', 10, 'FontWeight', 'bold');
    title('压路机速度变化', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 添加统计信息
    max_v = max(abs(results.velocity));
    avg_v = mean(abs(results.velocity));
    text(0.6*max(results.time), 0.9*max_v, ...
         sprintf('最大: %.2f m/s\n平均: %.2f m/s', max_v, avg_v), ...
         'FontSize', 9, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    %% 子图2: 位置-时间曲线
    subplot(2, 3, 2);
    plot(results.time, results.position, 'r-', 'LineWidth', 2);
    grid on;
    xlabel('时间 (s)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('位置 (m)', 'FontSize', 10, 'FontWeight', 'bold');
    title('压路机位置变化', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 添加总距离信息
    total_dist = max(results.position) - min(results.position);
    text(0.6*max(results.time), 0.9*max(results.position), ...
         sprintf('总距离: %.2f m', total_dist), ...
         'FontSize', 9, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    %% 子图3: 振动力-时间曲线
    subplot(2, 3, 3);
    plot(results.time, results.vibration_force/1000, 'g-', 'LineWidth', 1.5);
    grid on;
    xlabel('时间 (s)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('振动力 (kN)', 'FontSize', 10, 'FontWeight', 'bold');
    title('振动系统激振力', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 标注振动开始时间
    vib_start = find(results.vibration_force ~= 0, 1);
    if ~isempty(vib_start)
        hold on;
        plot([results.time(vib_start), results.time(vib_start)], ...
             ylim, 'r--', 'LineWidth', 1.5);
        text(results.time(vib_start), max(results.vibration_force/1000)*0.5, ...
             '振动开启', 'FontSize', 9, 'BackgroundColor', 'yellow');
        hold off;
    end
    
    %% 子图4: 压实度-时间曲线
    subplot(2, 3, 4);
    plot(results.time, results.compaction, 'm-', 'LineWidth', 2);
    grid on;
    xlabel('时间 (s)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('累计压实度', 'FontSize', 10, 'FontWeight', 'bold');
    title('路面压实度累计', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 添加最终压实度
    final_comp = results.compaction(end);
    text(0.6*max(results.time), 0.9*final_comp, ...
         sprintf('最终: %.2f', final_comp), ...
         'FontSize', 9, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    %% 子图5: 速度-位置关系图
    subplot(2, 3, 5);
    scatter(results.position, results.velocity, 20, results.time, 'filled');
    colorbar;
    colormap(jet);
    grid on;
    xlabel('位置 (m)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('速度 (m/s)', 'FontSize', 10, 'FontWeight', 'bold');
    title('速度-位置关系 (颜色表示时间)', 'FontSize', 12, 'FontWeight', 'bold');
    
    %% 子图6: 综合性能指标
    subplot(2, 3, 6);
    axis off;
    
    % 创建性能指标表格
    metrics_text = {
        '=== 仿真性能指标 ==='
        ''
        sprintf('仿真时长: %.1f 秒', max(results.time))
        sprintf('最大速度: %.2f m/s', max(abs(results.velocity)))
        sprintf('平均速度: %.2f m/s', mean(abs(results.velocity)))
        sprintf('总行驶距离: %.2f m', total_dist)
        ''
        sprintf('最终压实度: %.2f', final_comp)
        sprintf('压实效率: %.2f %%', (final_comp/max(results.time))*100)
        ''
        sprintf('振动频率: 30 Hz')
        sprintf('平均振动力: %.2f kN', mean(abs(results.vibration_force(results.vibration_force~=0)))/1000)
        ''
        '=== 设备参数 ==='
        '质量: 12 吨'
        '发动机: 150 kW'
        '钢轮宽度: 2.1 m'
    };
    
    text(0.1, 0.95, metrics_text, ...
         'FontSize', 9, 'FontName', 'Courier New', ...
         'VerticalAlignment', 'top', 'FontWeight', 'bold');
    
    %% 调整整体布局
    sgtitle('压路机虚拟仿真系统 - 结果分析', ...
            'FontSize', 14, 'FontWeight', 'bold');
    
    %% 创建动画窗口
    animate_roller(results);
    
end

function animate_roller(results)
% 创建压路机工作动画
%
% 输入:
%   results - 仿真结果结构体

    % 创建新的图形窗口
    fig = figure('Name', '压路机工作动画', 'NumberTitle', 'off', ...
                 'Position', [150, 150, 1200, 600], 'Color', [0.9 0.9 0.9]);
    
    % 降采样以提高动画速度
    skip = max(1, floor(length(results.time) / 200));
    time_anim = results.time(1:skip:end);
    pos_anim = results.position(1:skip:end);
    vel_anim = results.velocity(1:skip:end);
    vib_anim = results.vibration_force(1:skip:end);
    comp_anim = results.compaction(1:skip:end);
    
    %% 主动画区域
    ax1 = subplot(1, 2, 1);
    hold on;
    axis equal;
    grid on;
    xlabel('位置 (m)', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('高度 (m)', 'FontSize', 10, 'FontWeight', 'bold');
    title('压路机工作动画 (侧视图)', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 设置坐标轴范围
    max_pos = max(pos_anim);
    xlim([min(pos_anim)-5, max_pos+5]);
    ylim([-1, 4]);
    
    % 绘制路面
    road_x = [min(pos_anim)-10, max_pos+10];
    road_y = [0, 0];
    plot(road_x, road_y, 'k-', 'LineWidth', 3);
    
    % 压路机参数
    roller_length = 4.5;
    roller_height = 2.8;
    drum_radius = 0.75;
    
    % 初始化压路机图形对象
    % 车身
    body_rect = rectangle('Position', [0, drum_radius, roller_length, roller_height-drum_radius], ...
                          'FaceColor', [1, 0.8, 0], 'EdgeColor', 'k', 'LineWidth', 2);
    
    % 前钢轮
    front_drum = rectangle('Position', [0, 0, drum_radius*2, drum_radius*2], ...
                           'Curvature', [1, 1], 'FaceColor', [0.3, 0.3, 0.3], ...
                           'EdgeColor', 'k', 'LineWidth', 2);
    
    % 后钢轮
    rear_drum = rectangle('Position', [roller_length-drum_radius*2, 0, drum_radius*2, drum_radius*2], ...
                          'Curvature', [1, 1], 'FaceColor', [0.3, 0.3, 0.3], ...
                          'EdgeColor', 'k', 'LineWidth', 2);
    
    % 驾驶室
    cabin_rect = rectangle('Position', [roller_length*0.4, roller_height+drum_radius*0.5, ...
                                        roller_length*0.3, roller_height*0.3], ...
                           'FaceColor', [0.5, 0.7, 1], 'EdgeColor', 'k', 'LineWidth', 1.5);
    
    % 轨迹线
    trail_line = plot(0, 0, 'b--', 'LineWidth', 1.5);
    trail_x = [];
    trail_y = [];
    
    % 振动指示器
    vib_text = text(0, 3.5, '', 'FontSize', 10, 'FontWeight', 'bold', ...
                    'HorizontalAlignment', 'center');
    
    %% 数据显示区域
    ax2 = subplot(1, 2, 2);
    axis off;
    
    % 创建数据显示文本
    info_text = text(0.1, 0.9, '', 'FontSize', 11, 'FontName', 'Courier New', ...
                     'VerticalAlignment', 'top', 'FontWeight', 'bold');
    
    % 创建小型实时图表
    axes('Position', [0.55, 0.55, 0.4, 0.35]);
    speed_plot = plot(0, 0, 'b-', 'LineWidth', 2);
    grid on;
    xlabel('时间 (s)', 'FontSize', 8);
    ylabel('速度 (m/s)', 'FontSize', 8);
    title('速度曲线', 'FontSize', 9, 'FontWeight', 'bold');
    xlim([0, max(time_anim)]);
    ylim([min(vel_anim)-0.5, max(vel_anim)+0.5]);
    
    axes('Position', [0.55, 0.1, 0.4, 0.35]);
    comp_plot = plot(0, 0, 'm-', 'LineWidth', 2);
    grid on;
    xlabel('时间 (s)', 'FontSize', 8);
    ylabel('压实度', 'FontSize', 8);
    title('压实度曲线', 'FontSize', 9, 'FontWeight', 'bold');
    xlim([0, max(time_anim)]);
    ylim([0, max(comp_anim)*1.1]);
    
    %% 运行动画
    fprintf('正在播放压路机工作动画...\n');
    fprintf('按 Ctrl+C 停止动画\n\n');
    
    for i = 1:length(time_anim)
        % 更新压路机位置
        current_pos = pos_anim(i);
        
        set(body_rect, 'Position', [current_pos, drum_radius, roller_length, roller_height-drum_radius]);
        set(front_drum, 'Position', [current_pos, 0, drum_radius*2, drum_radius*2]);
        set(rear_drum, 'Position', [current_pos+roller_length-drum_radius*2, 0, drum_radius*2, drum_radius*2]);
        set(cabin_rect, 'Position', [current_pos+roller_length*0.4, roller_height+drum_radius*0.5, ...
                                      roller_length*0.3, roller_height*0.3]);
        
        % 更新轨迹
        trail_x = [trail_x, current_pos + roller_length/2];
        trail_y = [trail_y, drum_radius + roller_height/2];
        if length(trail_x) > 50
            trail_x = trail_x(end-49:end);
            trail_y = trail_y(end-49:end);
        end
        set(trail_line, 'XData', trail_x, 'YData', trail_y);
        
        % 更新振动指示
        if vib_anim(i) ~= 0
            set(vib_text, 'Position', [current_pos + roller_length/2, 3.5], ...
                'String', '振动工作中', 'Color', 'red');
        else
            set(vib_text, 'Position', [current_pos + roller_length/2, 3.5], ...
                'String', '', 'Color', 'black');
        end
        
        % 更新数据显示
        info_str = {
            '╔═══════════════════════════╗'
            '║   压路机实时数据          ║'
            '╠═══════════════════════════╣'
            sprintf('║ 时间:     %6.1f 秒    ║', time_anim(i))
            sprintf('║ 位置:     %6.1f m     ║', pos_anim(i))
            sprintf('║ 速度:     %6.2f m/s   ║', vel_anim(i))
            sprintf('║ 振动力:   %6.1f kN    ║', vib_anim(i)/1000)
            sprintf('║ 压实度:   %6.2f       ║', comp_anim(i))
            '╠═══════════════════════════╣'
            sprintf('║ 进度:     %5.1f %%     ║', i/length(time_anim)*100)
            '╚═══════════════════════════╝'
        };
        set(info_text, 'String', info_str);
        
        % 更新速度曲线
        set(speed_plot, 'XData', time_anim(1:i), 'YData', vel_anim(1:i));
        
        % 更新压实度曲线
        set(comp_plot, 'XData', time_anim(1:i), 'YData', comp_anim(1:i));
        
        % 调整视图跟随压路机
        if current_pos > max_pos/2
            xlim(ax1, [current_pos-10, current_pos+15]);
        end
        
        % 刷新显示
        drawnow;
        
        % 控制动画速度
        pause(0.02);
    end
    
    fprintf('动画播放完成!\n');
end
