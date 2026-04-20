import 'package:flutter_riverpod/flutter_riverpod.dart';

// 主题模式提供者
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// 路由提供者
final routerProvider = Provider<Object>((ref) {
  // 这里返回路由配置，实际应用中会使用GoRouter等
  return Object();
});

// 用户设置提供者
final userSettingsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'voiceEnabled': true,
    'voiceSpeed': 1.0,
    'voiceVolume': 1.0,
    'gpsEnabled': true,
    'bluetoothEnabled': true,
    'autoStartWorkout': false,
    'darkMode': false,
  };
});

// 当前训练状态提供者
final workoutStateProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'isActive': false,
    'startTime': null,
    'workoutType': '',
    'currentAction': '',
    'currentCount': 0,
    'totalCount': 0,
    'heartRate': 0,
    'distance': 0.0,
    'calories': 0,
  };
});

// 设备连接状态提供者
final deviceConnectionProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'heartRateMonitor': false,
    'gpsAvailable': true,
    'bluetoothEnabled': false,
  };
});

// 初始化Hive数据库
Future<void> initHive() async {
  // 这里初始化Hive数据库
  await Future.delayed(const Duration(milliseconds: 100));
}

// 初始化应用
Future<void> initApp() async {
  // 这里初始化应用设置和权限
  await Future.delayed(const Duration(milliseconds: 100));
}