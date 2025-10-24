# 压路机虚拟仿真系统

<div align="center">

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![MATLAB](https://img.shields.io/badge/MATLAB-R2019b+-orange.svg)
![Simulink](https://img.shields.io/badge/Simulink-Required-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**基于MATLAB/Simulink的压路机工作虚拟仿真平台**

</div>

## 📋 目录

- [项目简介](#项目简介)
- [主要功能](#主要功能)
- [系统要求](#系统要求)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [使用说明](#使用说明)
- [技术参数](#技术参数)
- [仿真模型](#仿真模型)
- [示例结果](#示例结果)
- [常见问题](#常见问题)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 🎯 项目简介

压路机虚拟仿真系统是一个基于MATLAB/Simulink开发的综合性仿真平台，用于模拟和分析压路机的动力学行为、振动特性和路面压实过程。该系统可以帮助：

- 🎓 **教育培训**：为学生和工程师提供压路机工作原理的直观理解
- 🔬 **科研开发**：测试不同工作参数对压实效果的影响
- 🛠️ **设备优化**：评估压路机性能并提供优化建议
- 📊 **数据分析**：生成详细的性能报告和可视化结果

## ✨ 主要功能

### 1. 完整的动力学仿真
- ✅ 压路机质量和惯性特性建模
- ✅ 发动机功率和扭矩特性
- ✅ 传动系统效率模拟
- ✅ 制动系统动力学
- ✅ 滚动阻力和空气阻力

### 2. 振动系统仿真
- ✅ 30Hz振动频率模拟
- ✅ 可调激振力（30-50kN）
- ✅ 振动传递特性
- ✅ 动态载荷计算

### 3. 压实效果计算
- ✅ 路面压实度模型
- ✅ 多遍压实效果累积
- ✅ 压实均匀性分析
- ✅ 最优工作速度预测

### 4. 可视化和动画
- ✅ 实时数据图表
- ✅ 压路机工作动画
- ✅ 轨迹显示
- ✅ 多维度性能曲线

### 5. 性能分析
- ✅ 运动性能评估
- ✅ 能耗估算
- ✅ 工作效率计算
- ✅ 综合评分系统
- ✅ 优化建议生成

## 💻 系统要求

### 必需软件
- **MATLAB**: R2019b 或更高版本
- **Simulink**: 包含在MATLAB安装中
- **工具箱**（推荐）:
  - Simulink Control Design
  - Simscape (可选，用于更高级的物理建模)

### 硬件要求
- **处理器**: Intel Core i5 或更高
- **内存**: 8GB RAM (推荐 16GB)
- **存储**: 500MB 可用空间
- **显示器**: 1920×1080 或更高分辨率

### 操作系统
- Windows 10/11 (64位)
- macOS 10.14 或更高
- Linux (Ubuntu 18.04 或更高)

## 🚀 快速开始

### 方法一：使用主程序（推荐）

```matlab
% 1. 在MATLAB中导航到项目目录
cd road-roller-simulator

% 2. 运行主程序
main

% 3. 选择菜单选项7进行快速演示
```

### 方法二：手动执行

```matlab
% 1. 初始化参数
init_simulation

% 2. 创建Simulink模型
cd models
RoadRollerSimulation
cd ..

% 3. 运行仿真
[simOut, results] = run_simulation('duration', 100, 'visualize', true);

% 4. 分析性能
report = analyze_performance(results);
```

### 方法三：快速演示

```matlab
% 一行命令完成所有操作
cd road-roller-simulator && main
% 然后选择选项 7 (快速演示)
```

## 📁 项目结构

```
road-roller-simulator/
│
├── main.m                      # 主程序入口
├── README.md                   # 项目说明文档
│
├── models/                     # Simulink模型
│   └── RoadRollerSimulation.m  # 模型创建脚本
│
├── scripts/                    # 仿真脚本
│   ├── init_simulation.m       # 参数初始化
│   ├── run_simulation.m        # 仿真运行
│   └── visualize_results.m     # 结果可视化
│
├── utils/                      # 工具函数
│   └── analyze_performance.m   # 性能分析
│
├── data/                       # 数据存储
│   ├── simulation_*.mat        # 仿真结果数据
│   └── performance_report_*.mat # 性能报告
│
├── docs/                       # 文档目录
│   ├── user_guide.md           # 用户指南
│   ├── technical_specs.md      # 技术规格
│   └── api_reference.md        # API参考
│
└── images/                     # 图像资源
    └── screenshots/            # 截图
```

## 📖 使用说明

### 基本操作流程

#### 1. 参数初始化

```matlab
% 加载默认参数
init_simulation;

% 查看参数
params  % 显示所有参数

% 修改参数（可选）
params.engine.max_power = 180;  % 修改发动机功率为180kW
params.vibration.frequency = 35; % 修改振动频率为35Hz
```

#### 2. 运行仿真

```matlab
% 使用默认参数
[simOut, results] = run_simulation();

% 自定义参数
[simOut, results] = run_simulation(...
    'duration', 60, ...      % 仿真时长60秒
    'throttle', 0.7, ...     % 油门开度70%
    'vibration', 5, ...      % 5秒后开启振动
    'visualize', true);      % 启用可视化
```

#### 3. 结果可视化

```matlab
% 自动加载最新结果
visualize_results();

% 或指定结果数据
visualize_results(results);
```

#### 4. 性能分析

```matlab
% 生成性能报告
report = analyze_performance(results);

% 查看综合得分
report.evaluation.overall_score

% 查看优化建议
report.suggestions
```

### 高级功能

#### 批量仿真

```matlab
% 测试不同油门设置
throttle_values = 0.3:0.1:0.8;
results_batch = cell(length(throttle_values), 1);

for i = 1:length(throttle_values)
    [~, results_batch{i}] = run_simulation(...
        'throttle', throttle_values(i), ...
        'visualize', false, ...
        'save_data', true);
end

% 比较结果
for i = 1:length(throttle_values)
    fprintf('油门 %.1f: 距离 %.2f m, 压实度 %.2f\n', ...
        throttle_values(i), ...
        results_batch{i}.metrics.total_distance, ...
        results_batch{i}.metrics.final_compaction);
end
```

#### 参数优化

```matlab
% 寻找最优工作速度
target_compaction = 100;  % 目标压实度
speeds = 1.5:0.5:4.0;
efficiency = zeros(size(speeds));

for i = 1:length(speeds)
    throttle = speeds(i) / 5;  % 假设最大速度5 m/s
    [~, res] = run_simulation('throttle', throttle, 'visualize', false);
    efficiency(i) = res.metrics.final_compaction / res.metrics.simulation_time;
end

[max_eff, idx] = max(efficiency);
optimal_speed = speeds(idx);
fprintf('最优速度: %.2f m/s, 效率: %.4f\n', optimal_speed, max_eff);
```

## 🔧 技术参数

### 压路机基本参数

| 参数 | 数值 | 单位 |
|------|------|------|
| 总质量 | 12,000 | kg |
| 车身长度 | 4.5 | m |
| 车身宽度 | 2.1 | m |
| 车身高度 | 2.8 | m |
| 轴距 | 3.0 | m |
| 钢轮半径 | 0.75 | m |
| 钢轮宽度 | 2.1 | m |

### 发动机参数

| 参数 | 数值 | 单位 |
|------|------|------|
| 最大功率 | 150 | kW |
| 额定转速 | 2200 | rpm |
| 最大扭矩 | 800 | N·m |
| 怠速转速 | 800 | rpm |

### 振动系统参数

| 参数 | 数值 | 单位 |
|------|------|------|
| 振动频率 | 30 | Hz |
| 低振幅激振力 | 30 | kN |
| 高振幅激振力 | 50 | kN |
| 激振块质量 | 200 | kg |

### 性能参数

| 参数 | 数值 | 单位 |
|------|------|------|
| 最大行驶速度 | 12 | km/h |
| 工作速度范围 | 2-4 | km/h |
| 爬坡能力 | 30 | % |
| 压实宽度 | 2.1 | m |
| 标准压实遍数 | 6 | 遍 |

## 🏗️ 仿真模型

### 模型架构

系统采用模块化设计，主要包含以下子系统：

```
┌─────────────────────────────────────────┐
│         驾驶员控制输入                  │
│   (油门、制动、振动开关)                │
└───────────┬─────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────┐
│          发动机模型                     │
│   (功率特性、扭矩输出)                  │
└───────────┬─────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────┐
│         传动系统                        │
│   (效率损失、制动效果)                  │
└───────────┬─────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────┐
│        车辆动力学                       │
│   (质量、阻力、速度、位置)              │
└───────────┬─────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────┐
│         振动系统                        │
│   (激振力、频率控制)    ┐               │
└────────────┬────────────┘               │
             │                             │
             ▼                             ▼
┌─────────────────────────────────────────┐
│        压实度计算                       │
│   (密度变化、均匀性)                    │
└─────────────────────────────────────────┘
```

### 数学模型

#### 1. 运动方程

```
ma = F_drive - F_resistance - F_brake
```

其中：
- m: 压路机质量 (12000 kg)
- a: 加速度 (m/s²)
- F_drive: 驱动力 (N)
- F_resistance: 滚动阻力 (N)
- F_brake: 制动力 (N)

#### 2. 滚动阻力

```
F_resistance = μ_r × m × g + 0.5 × ρ × A × C_d × v²
```

其中：
- μ_r: 滚动阻力系数 (0.05)
- g: 重力加速度 (9.81 m/s²)
- ρ: 空气密度 (1.225 kg/m³)
- A: 迎风面积 (5.0 m²)
- C_d: 空气阻力系数 (0.4)
- v: 速度 (m/s)

#### 3. 振动力

```
F_vib = F_amplitude × sin(2πf × t)
```

其中：
- F_amplitude: 激振力幅值 (50000 N)
- f: 振动频率 (30 Hz)
- t: 时间 (s)

#### 4. 压实度增量

```
dρ/dt = k × |F_vib| × v × η(v)
```

其中：
- ρ: 路面密度 (kg/m³)
- k: 压实系数 (0.001)
- η(v): 速度效率函数

## 📊 示例结果

### 典型仿真输出

运行100秒标准仿真后的典型结果：

```
====================================
  仿真结果摘要
====================================
性能指标:
  最大速度: 2.45 m/s
  平均速度: 2.31 m/s
  总行驶距离: 231.5 m
  最终压实度: 95.2
  平均振动力: 31.5 kN
  计算用时: 3.2 秒
====================================

综合性能评价:
  速度稳定性得分: 92.5/100
  压实效率得分:   85.0/100
  时间利用率得分: 94.0/100
  压实均匀性得分: 88.5/100
  ----------------------------------
  综合得分:       89.5/100
  性能等级:       良好
```

### 可视化图表

仿真系统会自动生成以下图表：

1. **速度-时间曲线**: 显示压路机速度变化
2. **位置-时间曲线**: 显示行驶轨迹
3. **振动力曲线**: 显示激振力时间历程
4. **压实度曲线**: 显示累计压实效果
5. **工作动画**: 压路机侧视图动画演示

### 性能报告

系统会生成包含以下内容的详细报告：

- 运动性能分析
- 振动系统性能
- 压实效果评估
- 能耗估算
- 工作效率计算
- 综合评价
- 优化建议

## ❓ 常见问题

### Q1: 提示"未找到Simulink"错误？

**A**: 该系统需要MATLAB Simulink工具箱。解决方案：
- 检查Simulink是否已安装：`ver` 命令查看工具箱列表
- 如果未安装，可以使用基础仿真功能（选项3），该功能使用数学模型而非Simulink

### Q2: 如何修改压路机参数？

**A**: 
```matlab
% 1. 加载参数
init_simulation;

% 2. 修改所需参数
params.roller.mass = 15000;  % 改为15吨
params.engine.max_power = 180;  % 改为180kW

% 3. 更新到工作空间
assignin('base', 'params', params);

% 4. 运行仿真
run_simulation();
```

### Q3: 仿真运行很慢怎么办？

**A**: 可以采取以下措施：
- 减少仿真时长：`run_simulation('duration', 30)`
- 增大时间步长：修改 `params.sim.time_step`
- 关闭实时可视化：`run_simulation('visualize', false)`

### Q4: 如何导出仿真数据？

**A**: 
```matlab
% 数据自动保存在 data/ 目录
% 手动导出到Excel
[~, res] = run_simulation();
data_table = table(res.time, res.velocity, res.position, ...
    'VariableNames', {'Time', 'Velocity', 'Position'});
writetable(data_table, 'simulation_results.xlsx');
```

### Q5: 可以模拟不同路面类型吗？

**A**: 可以！修改路面参数：
```matlab
% 沥青路面
params.road.current_type = 'asphalt';
params.road.current_stiffness = 50000;

% 砂石路面
params.road.current_type = 'gravel';
params.road.current_stiffness = 30000;

% 土路
params.road.current_type = 'soil';
params.road.current_stiffness = 15000;
```

### Q6: 如何比较不同工作模式？

**A**: 
```matlab
% 定义测试场景
scenarios = struct(...
    'name', {'标准模式', '高速模式', '强力压实'}, ...
    'throttle', {0.5, 0.8, 0.4}, ...
    'vibration', {10, 5, 3});

% 批量运行
for i = 1:length(scenarios)
    [~, res{i}] = run_simulation(...
        'throttle', scenarios(i).throttle, ...
        'vibration', scenarios(i).vibration, ...
        'visualize', false);
    fprintf('%s: 距离 %.1f m, 压实度 %.1f\n', ...
        scenarios(i).name, ...
        res{i}.metrics.total_distance, ...
        res{i}.metrics.final_compaction);
end
```

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出改进建议！

### 如何贡献

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 代码规范

- 使用清晰的变量命名
- 添加适当的注释
- 遵循MATLAB编码风格指南
- 确保所有函数都有完整的帮助文档

### 报告问题

使用GitHub Issues报告问题时，请包含：
- MATLAB版本
- 操作系统
- 详细的错误信息
- 复现步骤

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 👥 作者

- **开发团队**: AI Assistant
- **版本**: 1.0
- **日期**: 2025-10-24

## 🙏 致谢

感谢以下资源和工具：

- MATLAB & Simulink - MathWorks
- 压路机动力学理论参考文献
- 开源社区的支持

## 📮 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 GitHub Issue
- 发送电子邮件
- 参与项目讨论

---

<div align="center">

**压路机虚拟仿真系统** © 2025

Made with ❤️ using MATLAB & Simulink

[返回顶部](#压路机虚拟仿真系统)

</div>


---

**注意**: 此仿真系统需要MATLAB环境才能运行。
