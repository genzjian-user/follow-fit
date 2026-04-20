import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:follow_fit/services/gps_service.dart';

/// 运动历史记录
class WorkoutRecord {
  final String id;
  final String workoutType;
  final DateTime startTime;
  final DateTime endTime;
  final double duration; // 分钟
  final double calories;
  final double distance; // 米
  final double avgHeartRate;
  final double maxHeartRate;
  final Map<String, dynamic>? trackData; // GPS轨迹数据
  final Map<String, dynamic>? heartRateData; // 心率数据
  final Map<String, dynamic> metadata;
  
  WorkoutRecord({
    required this.id,
    required this.workoutType,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.calories,
    required this.distance,
    required this.avgHeartRate,
    required this.maxHeartRate,
    this.trackData,
    this.heartRateData,
    this.metadata = const {},
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutType': workoutType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'calories': calories,
      'distance': distance,
      'avgHeartRate': avgHeartRate,
      'maxHeartRate': maxHeartRate,
      'trackData': trackData,
      'heartRateData': heartRateData,
      'metadata': metadata,
    };
  }
  
  factory WorkoutRecord.fromJson(Map<String, dynamic> json) {
    return WorkoutRecord(
      id: json['id'],
      workoutType: json['workoutType'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration']?.toDouble() ?? 0.0,
      calories: json['calories']?.toDouble() ?? 0.0,
      distance: json['distance']?.toDouble() ?? 0.0,
      avgHeartRate: json['avgHeartRate']?.toDouble() ?? 0.0,
      maxHeartRate: json['maxHeartRate']?.toDouble() ?? 0.0,
      trackData: json['trackData'],
      heartRateData: json['heartRateData'],
      metadata: json['metadata'] ?? {},
    );
  }
}

/// 用户运动统计数据
class UserStats {
  double totalCalories = 0.0;
  double totalDistance = 0.0;
  double totalDuration = 0.0;
  int totalWorkouts = 0;
  double avgCaloriesPerWorkout = 0.0;
  double avgDistancePerWorkout = 0.0;
  double avgDurationPerWorkout = 0.0;
  DateTime? firstWorkoutDate;
  DateTime? lastWorkoutDate;
  
  Map<String, dynamic> toJson() {
    return {
      'totalCalories': totalCalories,
      'totalDistance': totalDistance,
      'totalDuration': totalDuration,
      'totalWorkouts': totalWorkouts,
      'avgCaloriesPerWorkout': avgCaloriesPerWorkout,
      'avgDistancePerWorkout': avgDistancePerWorkout,
      'avgDurationPerWorkout': avgDurationPerWorkout,
      'firstWorkoutDate': firstWorkoutDate?.toIso8601String(),
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
    };
  }
}

/// 本地存储服务
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  List<WorkoutRecord> _workoutRecords = [];
  File? _storageFile;
  
  /// 初始化存储
  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final storagePath = '${directory.path}/follow_fit_storage.json';
      _storageFile = File(storagePath);
      
      if (await _storageFile!.exists()) {
        final content = await _storageFile!.readAsString();
        final json = jsonDecode(content);
        
        if (json['workoutRecords'] != null) {
          _workoutRecords = (json['workoutRecords'] as List)
              .map((item) => WorkoutRecord.fromJson(item))
              .toList();
        }
      }
      
      // 如果文件不存在，创建初始数据
      if (_workoutRecords.isEmpty) {
        await _createSampleData();
      }
      
      print('Storage initialized: ${_workoutRecords.length} records loaded');
    } catch (e) {
      print('Error initializing storage: $e');
      // 创建空记录
      _workoutRecords = [];
    }
  }
  
  /// 创建示例数据
  Future<void> _createSampleData() async {
    final now = DateTime.now();
    _workoutRecords = [
      WorkoutRecord(
        id: '1',
        workoutType: '户外跑步',
        startTime: now.subtract(const Duration(days: 2, hours: 1)),
        endTime: now.subtract(const Duration(days: 2)),
        duration: 45.0,
        calories: 320.0,
        distance: 5000.0,
        avgHeartRate: 135.0,
        maxHeartRate: 152.0,
        metadata: {
          'weather': '晴天',
          'temperature': 22,
        },
      ),
      WorkoutRecord(
        id: '2',
        workoutType: '室内有氧',
        startTime: now.subtract(const Duration(days: 1, hours: 2)),
        endTime: now.subtract(const Duration(days: 1, hours: 1)),
        duration: 60.0,
        calories: 280.0,
        distance: 0.0,
        avgHeartRate: 125.0,
        maxHeartRate: 140.0,
        metadata: {
          'equipment': '跑步机',
          'program': '爬坡训练',
        },
      ),
      WorkoutRecord(
        id: '3',
        workoutType: '步行',
        startTime: now.subtract(const Duration(hours: 3)),
        endTime: now.subtract(const Duration(hours: 2, minutes: 30)),
        duration: 30.0,
        calories: 150.0,
        distance: 2500.0,
        avgHeartRate: 110.0,
        maxHeartRate: 125.0,
        metadata: {
          'location': '公园',
          'companion': '朋友',
        },
      ),
    ];
    
    await _saveToFile();
  }
  
  /// 保存到文件
  Future<void> _saveToFile() async {
    if (_storageFile == null) return;
    
    final data = {
      'workoutRecords': _workoutRecords.map((record) => record.toJson()).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
    
    try {
      await _storageFile!.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving to file: $e');
    }
  }
  
  /// 添加运动记录
  Future<void> addWorkoutRecord(WorkoutRecord record) async {
    _workoutRecords.add(record);
    _workoutRecords.sort((a, b) => b.startTime.compareTo(a.startTime));
    await _saveToFile();
  }
  
  /// 添加GPS运动轨迹记录
  Future<void> addWorkoutFromTrack(WorkoutTrack track, String workoutType) async {
    final record = WorkoutRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutType: workoutType,
      startTime: track.startTime,
      endTime: track.endTime ?? DateTime.now(),
      duration: track.endTime != null 
          ? track.endTime!.difference(track.startTime).inMinutes.toDouble()
          : 0.0,
      calories: track.totalCalories,
      distance: track.totalDistance,
      avgHeartRate: track.avgSpeed * 10, // 模拟心率计算
      maxHeartRate: track.maxSpeed * 10, // 模拟心率计算
      trackData: track.toJson(),
      metadata: {
        'source': 'gps_track',
        'avgSpeed': track.avgSpeed,
        'maxSpeed': track.maxSpeed,
      },
    );
    
    await addWorkoutRecord(record);
  }
  
  /// 获取所有运动记录
  List<WorkoutRecord> getAllWorkoutRecords() {
    return List.from(_workoutRecords);
  }
  
  /// 按日期范围获取运动记录
  List<WorkoutRecord> getWorkoutRecordsByDateRange(DateTime start, DateTime end) {
    return _workoutRecords.where((record) {
      return record.startTime.isAfter(start) && record.startTime.isBefore(end);
    }).toList();
  }
  
  /// 按类型获取运动记录
  List<WorkoutRecord> getWorkoutRecordsByType(String workoutType) {
    return _workoutRecords
        .where((record) => record.workoutType == workoutType)
        .toList();
  }
  
  /// 获取指定ID的运动记录
  WorkoutRecord? getWorkoutRecordById(String id) {
    return _workoutRecords.firstWhere(
      (record) => record.id == id,
      orElse: () => throw Exception('Record not found'),
    );
  }
  
  /// 获取用户运动统计数据
  UserStats getUserStats() {
    final stats = UserStats();
    
    if (_workoutRecords.isEmpty) return stats;
    
    for (var record in _workoutRecords) {
      stats.totalCalories += record.calories;
      stats.totalDistance += record.distance;
      stats.totalDuration += record.duration;
      stats.totalWorkouts++;
      
      if (stats.firstWorkoutDate == null || 
          record.startTime.isBefore(stats.firstWorkoutDate!)) {
        stats.firstWorkoutDate = record.startTime;
      }
      
      if (stats.lastWorkoutDate == null || 
          record.startTime.isAfter(stats.lastWorkoutDate!)) {
        stats.lastWorkoutDate = record.startTime;
      }
    }
    
    if (stats.totalWorkouts > 0) {
      stats.avgCaloriesPerWorkout = stats.totalCalories / stats.totalWorkouts;
      stats.avgDistancePerWorkout = stats.totalDistance / stats.totalWorkouts;
      stats.avgDurationPerWorkout = stats.totalDuration / stats.totalWorkouts;
    }
    
    return stats;
  }
  
  /// 获取周统计数据
  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    
    final weekRecords = getWorkoutRecordsByDateRange(weekStart, weekEnd);
    
    double weeklyCalories = 0.0;
    double weeklyDistance = 0.0;
    double weeklyDuration = 0.0;
    
    for (var record in weekRecords) {
      weeklyCalories += record.calories;
      weeklyDistance += record.distance;
      weeklyDuration += record.duration;
    }
    
    return {
      'startDate': weekStart,
      'endDate': weekEnd,
      'totalCalories': weeklyCalories,
      'totalDistance': weeklyDistance,
      'totalDuration': weeklyDuration,
      'workoutCount': weekRecords.length,
      'dailyAverageCalories': weeklyDuration > 0 ? weeklyCalories / 7 : 0,
    };
  }
  
  /// 获取运动类型分布
  Map<String, int> getWorkoutTypeDistribution() {
    final distribution = <String, int>{};
    
    for (var record in _workoutRecords) {
      distribution[record.workoutType] = 
          (distribution[record.workoutType] ?? 0) + 1;
    }
    
    return distribution;
  }
  
  /// 获取最近N次运动记录
  List<WorkoutRecord> getRecentWorkouts(int count) {
    final sorted = List.from(_workoutRecords)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    
    return sorted.take(count).toList();
  }
  
  /// 删除运动记录
  Future<void> deleteWorkoutRecord(String id) async {
    _workoutRecords.removeWhere((record) => record.id == id);
    await _saveToFile();
  }
  
  /// 清除所有数据（谨慎使用）
  Future<void> clearAllData() async {
    _workoutRecords.clear();
    await _saveToFile();
  }
  
  /// 导出数据为JSON
  Future<String> exportData() async {
    final data = {
      'appName': '跟着减',
      'exportTime': DateTime.now().toIso8601String(),
      'workoutRecords': _workoutRecords.map((record) => record.toJson()).toList(),
      'userStats': getUserStats().toJson(),
    };
    
    return jsonEncode(data);
  }
}