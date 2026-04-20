import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// GPS位置点
class GpsPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double speed;
  final DateTime timestamp;
  
  GpsPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.speed,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 运动轨迹记录
class WorkoutTrack {
  List<GpsPoint> points = [];
  DateTime startTime = DateTime.now();
  DateTime? endTime;
  double totalDistance = 0.0; // 米
  double totalCalories = 0.0;
  double avgSpeed = 0.0;
  double maxSpeed = 0.0;
  
  void addPoint(GpsPoint point) {
    points.add(point);
    
    // 计算距离
    if (points.length > 1) {
      final lastPoint = points[points.length - 2];
      final distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        point.latitude,
        point.longitude,
      );
      totalDistance += distance;
    }
    
    // 更新最大速度
    if (point.speed > maxSpeed) {
      maxSpeed = point.speed;
    }
  }
  
  void finish() {
    endTime = DateTime.now();
    
    // 计算平均速度
    if (points.isNotEmpty) {
      final totalSpeed = points.fold(0.0, (sum, point) => sum + point.speed);
      avgSpeed = totalSpeed / points.length;
    }
    
    // 估算卡路里消耗（MET算法简化）
    // 假设运动强度为中等（MET=7），体重70kg
    final durationInHours = (endTime!.difference(startTime).inMinutes / 60);
    totalCalories = 7 * 70 * durationInHours;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalDistance': totalDistance,
      'totalCalories': totalCalories,
      'avgSpeed': avgSpeed,
      'maxSpeed': maxSpeed,
      'points': points.map((point) => point.toJson()).toList(),
    };
  }
}

/// GPS运动记录服务
class GpsService {
  StreamSubscription<Position>? _positionStream;
  WorkoutTrack? _currentTrack;
  
  // 单例模式
  static final GpsService _instance = GpsService._internal();
  factory GpsService() => _instance;
  GpsService._internal();
  
  /// 检查GPS权限
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  /// 开始记录运动轨迹
  Future<void> startWorkout() async {
    if (!await checkPermission()) {
      throw Exception('需要位置权限才能开始运动记录');
    }
    
    _currentTrack = WorkoutTrack();
    
    // 监听位置变化
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, // 每10米记录一次
    );
    
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (_currentTrack != null) {
        final gpsPoint = GpsPoint(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          accuracy: position.accuracy,
          speed: position.speed,
          timestamp: DateTime.now(),
        );
        _currentTrack!.addPoint(gpsPoint);
      }
    });
  }
  
  /// 停止记录并保存
  Future<WorkoutTrack> stopWorkout() async {
    if (_currentTrack == null) {
      throw Exception('没有正在进行的运动');
    }
    
    _positionStream?.cancel();
    _currentTrack!.finish();
    
    final track = _currentTrack!;
    _currentTrack = null;
    
    return track;
  }
  
  /// 获取当前位置
  Future<GpsPoint> getCurrentLocation() async {
    if (!await checkPermission()) {
      throw Exception('需要位置权限');
    }
    
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    
    return GpsPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
      speed: position.speed,
      timestamp: DateTime.now(),
    );
  }
  
  /// 计算两点间距离
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
  
  /// 获取运动历史记录（模拟数据）
  List<WorkoutTrack> getWorkoutHistory() {
    return [
      WorkoutTrack()
        ..points = [
          GpsPoint(
            latitude: 31.2304,
            longitude: 121.4737,
            altitude: 10.0,
            accuracy: 5.0,
            speed: 2.0,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]
        ..totalDistance = 5000.0
        ..totalCalories = 300.0
        ..avgSpeed = 5.0
        ..maxSpeed = 8.0,
    ];
  }
}