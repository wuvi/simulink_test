# 快速入门指南

## 欢迎使用压路机虚拟仿真系统！

本指南将帮助您在5分钟内开始使用系统。

## 前提条件

确保您已安装：
- ✅ MATLAB R2019b 或更高版本
- ✅ Simulink工具箱（推荐但非必需）

## 三步快速开始

### 步骤 1: 打开MATLAB并导航到项目目录

```matlab
% 在MATLAB命令窗口中输入:
cd 'C:/path/to/road-roller-simulator'  % Windows
% 或
cd '/path/to/road-roller-simulator'    % macOS/Linux
```

### 步骤 2: 运行主程序

```matlab
main
```

### 步骤 3: 选择快速演示

在菜单中输入 `7` 并按回车键，系统将自动：
- 初始化参数
- 运行60秒仿真
- 显示动画和结果
- 生成性能报告

## 第一个仿真示例

如果您想手动控制，可以这样操作：

```matlab
% 1. 初始化系统
init_simulation;

% 2. 运行30秒仿真
[out, res] = run_simulation('duration', 30, 'visualize', true);

% 3. 查看结果
fprintf('最大速度: %.2f m/s\n', res.metrics.max_velocity);
fprintf('行驶距离: %.2f m\n', res.metrics.total_distance);
```

## 自定义仿真参数

```matlab
% 运行自定义仿真
[out, res] = run_simulation(...
    'duration', 60, ...       % 60秒
    'throttle', 0.7, ...      % 70%油门
    'vibration', 5, ...       % 5秒后开启振动
    'visualize', true);       % 显示动画
```

## 查看结果

```matlab
% 可视化所有结果
visualize_results(res);

% 生成性能报告
report = analyze_performance(res);
```

## 下一步

- 📖 阅读 [用户手册](user_guide.md) 了解详细功能
- 🔧 查看 [参数配置](technical_specs.md) 自定义压路机
- 💡 浏览 [示例代码](examples/) 学习高级用法

## 需要帮助？

- 在主菜单中选择选项 `8` 查看帮助
- 查看 [常见问题](../README.md#常见问题)
- 阅读 [API参考文档](api_reference.md)

---

现在您已经准备好开始探索压路机仿真系统了！🎉
