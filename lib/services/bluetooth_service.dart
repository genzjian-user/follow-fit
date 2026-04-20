import 'dart:async';
import 'dart:convert';

/// 心率数据点
class HeartRateData {
  final int heartRate; // 心率值
  final DateTime timestamp;
  final int? rrInterval; // RR间期（可选）
  final int? energyExpended; // 能量消耗（可选）
  final List<int>? contactStatus; // 接触状态
  
  HeartRateData({
    required this.heartRate,
    required this.timestamp,
    this.rrInterval,
    this.energyExpended,
    this.contactStatus,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'timestamp': timestamp.toIso8601String(),
      'rrInterval': rrInterval,
      'energyExpended': energyExpended,
      'contactStatus': contactStatus,
    };
  }
}

/// 蓝牙设备信息
class BluetoothDevice {
  final String id;
  final String name;
  final String? manufacturer;
  final bool isConnected;
  final bool isHeartRateSupported;
  
  BluetoothDevice({
    required this.id,
    required this.name,
    this.manufacturer,
    this.isConnected = false,
    this.isHeartRateSupported = false,
  });
}

/// 心率区间定义
class HeartRateZone {
  final String name;
  final int min;
  final int max;
  final String description;
  final Color color;
  
  HeartRateZone({
    required this.name,
    required this.min,
    required this.max,
    required this.description,
    required this.color,
  });
}

/// 蓝牙心率服务（模拟实现，实际需要flutter_blue_plus）
class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();
  
  bool _isScanning = false;
  bool _isConnected = false;
  Timer? _heartRateTimer;
  List<HeartRateData> _heartRateHistory = [];
  StreamController<HeartRateData> _heartRateStream = StreamController.broadcast();
  
  /// 心率区间定义
  List<HeartRateZone> get heartRateZones => [
    HeartRateZone(
      name: '热身区',
      min: 50,
      max: 100,
      description: '轻度活动，适合热身',
      color: Color(0xFF4CAF50),
    ),
    HeartRateZone(
      name: '燃脂区',
      min: 100,
      max: 130,
      description: '最佳燃脂区间',
      color: Color(0xFF2196F3),
    ),
    HeartRateZone(
      name: '有氧区',
      min: 130,
      max: 150,
      description: '提高心肺功能',
      color: Color(0xFFFF9800),
    ),
    HeartRateZone(
      name: '极限区',
      min: 150,
      max: 180,
      description: '高强度训练',
      color: Color(0xFFF44336),
    ),
  ];
  
  /// 开始扫描设备
  Future<List<BluetoothDevice>> startScan() async {
    _isScanning = true;
    
    // 模拟扫描过程
    await Future.delayed(const Duration(seconds: 2));
    
    _isScanning = false;
    
    return [
      BluetoothDevice(
        id: 'device_001',
        name: '小米手环7',
        manufacturer: 'Xiaomi',
        isHeartRateSupported: true,
      ),
      BluetoothDevice(
        id: 'device_002',
        name: '华为手表GT3',
        manufacturer: 'Huawei',
        isHeartRateSupported: true,
      ),
      BluetoothDevice(
        id: 'device_003',
        name: 'Apple Watch Series 8',
        manufacturer: 'Apple',
        isHeartRateSupported: true,
      ),
    ];
  }
  
  /// 连接设备
  Future<bool> connectDevice(String deviceId) async {
    if (_isConnected) {
      await disconnectDevice();
    }
    
    // 模拟连接过程
    await Future.delayed(const Duration(seconds: 3));
    
    _isConnected = true;
    
    // 开始模拟心率数据
    _startHeartRateSimulation();
    
    return true;
  }
  
  /// 断开连接
  Future<void> disconnectDevice() async {
    _heartRateTimer?.cancel();
    _heartRateTimer = null;
    _isConnected = false;
  }
  
  /// 开始心率监测
  Stream<HeartRateData> startHeartRateMonitoring() {
    if (!_isConnected) {
      throw Exception('请先连接设备');
    }
    
    return _heartRateStream.stream;
  }
  
  /// 模拟心率数据生成
  void _startHeartRateSimulation() {
    int baseHeartRate = 70;
    int variation = 0;
    
    _heartRateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 模拟心率波动
      variation = (variation + 1) % 20;
      int heartRate = baseHeartRate + (variation > 10 ? 20 - variation : variation);
      
      // 偶尔模拟高强度运动
      if (DateTime.now().second % 30 == 0) {
        heartRate = 140 + variation;
      }
      
      final data = HeartRateData(
        heartRate: heartRate,
        timestamp: DateTime.now(),
        rrInterval: 60000 ~/ heartRate, // 计算RR间期
      );
      
      _heartRateHistory.add(data);
      
      // 保持最近1000条记录
      if (_heartRateHistory.length > 1000) {
        _heartRateHistory.removeAt(0);
      }
      
      _heartRateStream.add(data);
    });
  }
  
  /// 获取实时心率
  int getCurrentHeartRate() {
    if (_heartRateHistory.isEmpty) return 0;
    return _heartRateHistory.last.heartRate;
  }
  
  /// 获取心率历史
  List<HeartRateData> getHeartRateHistory() {
    return List.from(_heartRateHistory);
  }
  
  /// 获取心率统计
  Map<String, dynamic> getHeartRateStats() {
    if (_heartRateHistory.isEmpty) {
      return {
        'avg': 0,
        'min': 0,
        'max': 0,
        'zoneDistribution': {},
      };
    }
    
    int total = 0;
    int min = 300;
    int max = 0;
    
    final zoneCount = Map<String, int>();
    
    for (var data in _heartRateHistory) {
      final hr = data.heartRate;
      total += hr;
      if (hr < min) min = hr;
      if (hr > max) max = hr;
      
      // 统计心率区间
      for (var zone in heartRateZones) {
        if (hr >= zone.min && hr < zone.max) {
          zoneCount[zone.name] = (zoneCount[zone.name] ?? 0) + 1;
          break;
        }
      }
    }
    
    return {
      'avg': total ~/ _heartRateHistory.length,
      'min': min,
      'max': max,
      'zoneDistribution': zoneCount,
    };
  }
  
  /// 获取当前心率区间
  HeartRateZone? getCurrentZone() {
    final currentHR = getCurrentHeartRate();
    for (var zone in heartRateZones) {
      if (currentHR >= zone.min && currentHR < zone.max) {
        return zone;
      }
    }
    return null;
  }
  
  /// 判断心率是否在安全范围内
  bool isHeartRateSafe(int heartRate, int age) {
    final maxHeartRate = 220 - age;
    return heartRate <= maxHeartRate;
  }
  
  /// 计算建议心率范围
  Map<String, int> getRecommendedHeartRate(int age) {
    final maxHeartRate = 220 - age;
    return {
      'fatBurningMin': (maxHeartRate * 0.5).round(),
      'fatBurningMax': (maxHeartRate * 0.7).round(),
      'aerobicMin': (maxHeartRate * 0.7).round(),
      'aerobicMax': (maxHeartRate * 0.85).round(),
      'maxSafe': maxHeartRate,
    };
  }
}