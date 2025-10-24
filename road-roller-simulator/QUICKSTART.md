# 快速启动指南

## 🚀 最简单的启动方式

### 步骤 1: 在 MATLAB 中打开项目

```matlab
% 在 MATLAB 命令窗口中，切换到项目目录
cd '/path/to/road-roller-simulator'
```

### 步骤 2: 运行启动脚本

```matlab
startup
```

就这么简单！启动脚本会：
- ✅ 自动设置所有路径
- ✅ 验证文件完整性
- ✅ 检测核心函数
- ✅ 启动主程序

---

## 🔧 如果遇到 "无法识别函数" 错误

### 问题：`函数或变量 'init_simulation' 无法识别`

**原因**: MATLAB 找不到 `scripts` 文件夹中的函数

**解决方案 1 - 使用启动脚本（推荐）**:
```matlab
cd '/path/to/road-roller-simulator'
startup  % 自动配置一切
```

**解决方案 2 - 手动添加路径**:
```matlab
cd '/path/to/road-roller-simulator'

% 手动添加所有路径
addpath('models')
addpath('scripts')
addpath('utils')
addpath('data')
addpath('examples')

% 验证路径
which init_simulation  % 应该显示文件路径

% 现在可以运行
main
```

**解决方案 3 - 直接测试功能**:
```matlab
cd '/path/to/road-roller-simulator'

% 添加路径
addpath(genpath(pwd))  % 添加所有子文件夹

% 运行测试
test_basic  % 测试基本功能
```

---

## 📝 完整使用流程

### 1. 首次使用 - 路径设置

```matlab
% 方法 A: 使用启动脚本（最简单）
cd '/path/to/road-roller-simulator'
startup

% 方法 B: 手动设置
cd '/path/to/road-roller-simulator'
addpath('scripts')
addpath('utils')
addpath('models')
```

### 2. 验证安装

```matlab
% 测试核心函数是否可用
which init_simulation
which run_simulation

% 运行基本测试（不需要 Simulink）
test_basic
```

### 3. 运行仿真

```matlab
% 方法 A: 使用主程序菜单
main
% 选择 7 进行快速演示

% 方法 B: 直接调用函数
init_simulation();
[simOut, results] = run_simulation('duration', 30, 'visualize', true);
```

---

## 🐛 常见问题排查

### 问题 1: "无法识别函数"

```matlab
% 检查当前目录
pwd  % 确保在 road-roller-simulator 目录下

% 检查路径
path  % 查看 MATLAB 搜索路径

% 重新添加路径
cd '/path/to/road-roller-simulator'
startup  % 或者运行 addpath('scripts')
```

### 问题 2: "nargin/nargout" 错误

这个问题已经修复！如果仍然出现：
```matlab
% 确保使用最新版本
cd '/path/to/road-roller-simulator'
git pull origin feature/road-roller-simulator

% 或者下载最新代码
```

### 问题 3: Simulink 相关错误

如果没有 Simulink：
```matlab
% 运行不依赖 Simulink 的测试
test_basic  % 使用简化数学模型

% 或在 main 菜单中选择选项 3（数学仿真）
```

---

## ✅ 验证清单

在运行主程序前，确保：

- [ ] ✅ 已切换到正确目录 (`pwd` 显示 road-roller-simulator)
- [ ] ✅ 已运行 `startup` 或手动添加路径
- [ ] ✅ `which init_simulation` 显示文件路径
- [ ] ✅ `test_basic` 可以运行（可选）

---

## 🎯 推荐的启动顺序

```matlab
% 1. 切换目录
cd '/path/to/road-roller-simulator'

% 2. 运行启动脚本
startup

% 3. 启动主程序（startup 会询问）
% 选择 Y

% 4. 在主菜单中：
%    - 选择 1: 初始化参数
%    - 选择 3: 运行仿真
%    - 或选择 7: 快速演示
```

---

## 📞 还有问题？

如果上述方法都不行：

1. **检查 MATLAB 版本**:
   ```matlab
   version  % 应该是 R2019b 或更高
   ```

2. **检查文件是否完整**:
   ```matlab
   ls scripts     % 应该看到 init_simulation.m
   ls utils       % 应该看到 analyze_performance.m
   ```

3. **查看详细错误**:
   ```matlab
   % 直接调用函数看错误
   init_simulation()
   ```

4. **重新克隆仓库**:
   ```bash
   git clone https://github.com/wuvi/simulink_test.git
   cd simulink_test/road-roller-simulator
   ```

---

## 🎓 学习资源

- **完整文档**: 查看 `README.md`
- **快速指南**: 查看 `docs/quick_start_guide.md`
- **基本示例**: 运行 `examples/example_basic.m`
- **优化示例**: 运行 `examples/example_optimization.m`

---

**记住**: 最简单的方式就是运行 `startup` 脚本！ 🚀
