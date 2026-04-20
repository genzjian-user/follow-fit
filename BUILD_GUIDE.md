# 跟着减 - 构建指南

## 项目概述
**跟着减**是一个有氧减脂语音私教APP，采用Flutter跨平台开发，支持以下核心功能：
- 🎤 语音播报指导
- 🗺️ GPS运动轨迹记录  
- 💓 蓝牙心率监测
- 🤖 AI健身聊天
- 📊 运动历史统计

## 在线构建选项

### 方案1：使用 Codemagic（推荐）
**步骤：**
1. **创建GitHub仓库**
   - 访问: https://github.com/new
   - 仓库名: `follow-fit-app`
   - 设为私有
   - 上传所有项目文件

2. **配置Codemagic**
   - 注册: https://codemagic.io/signup
   - 连接GitHub账号
   - 选择 `follow-fit-app` 仓库
   - 点击 **"Start new workflow"**

3. **自动构建**
   - Codemagic会自动检测Flutter项目
   - 使用预设配置 (`.codemagic.yaml`)
   - 点击 **"Start new build"**

4. **下载APK**
   - 构建完成后下载 `app-release.apk`
   - 安装到Android手机（需开启"未知来源安装"）

### 方案2：使用 GitHub Actions
1. 在项目根目录创建 `.github/workflows/flutter-build.yml`
2. 使用GitHub Actions的Flutter模板
3. 自动触发构建

### 方案3：本地构建（需要Flutter环境）
```bash
# 1. 安装Flutter SDK
# 2. 配置环境变量
# 3. 构建APK
cd 跟着减
flutter pub get
flutter build apk --release

# 输出文件: build/app/outputs/flutter-apk/app-release.apk
```

## 项目结构
```
跟着减/
├── lib/                    # Dart源代码
│   ├── main.dart          # 应用入口
│   ├── screens/           # 页面
│   ├── services/          # 核心服务
│   │   ├── tts_service.dart      # 语音播报
│   │   ├── gps_service.dart      # GPS记录
│   │   ├── bluetooth_service.dart # 蓝牙心率
│   │   ├── ai_service.dart       # AI聊天
│   │   └── storage_service.dart  # 本地存储
│   ├── models/            # 数据模型
│   ├── providers/         # 状态管理
│   ├── routes/            # 路由配置
│   ├── utils/             # 工具类
│   └── widgets/           # 自定义组件
├── android/               # Android配置
├── .codemagic.yaml        # 在线构建配置
├── pubspec.yaml           # 依赖配置
└── BUILD_GUIDE.md         # 本文件
```

## 核心依赖
已在 `pubspec.yaml` 中配置：
- **语音**: `flutter_tts`, `just_audio`
- **定位**: `location`, `geolocator`
- **蓝牙**: `flutter_blue_plus`
- **地图**: `flutter_map`
- **存储**: `hive`, `shared_preferences`
- **图表**: `fl_chart`
- **UI**: `riverpod`, `go_router`, `lottie`

## Android配置
- **应用ID**: `com.follow.fit`
- **最低SDK**: 23 (Android 6.0)
- **目标SDK**: 34 (Android 14)
- **所需权限**: 位置、蓝牙、存储等

## 注意事项
1. **首次运行**需要授予位置、蓝牙权限
2. **心率监测**需要蓝牙心率设备
3. **语音播报**需要网络连接（语音合成）
4. **存储权限**用于保存运动历史

## 测试安装
1. 将APK文件传输到Android手机
2. 手机设置 → 安全 → 允许未知来源安装
3. 安装并运行应用
4. 按照引导完成权限授权

## 技术支持
如需进一步帮助，请联系开发团队或查阅项目文档。