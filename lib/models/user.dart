class User {
  String id;
  String name;
  double weight; // 公斤
  double height; // 厘米
  int age;
  String email;
  DateTime createdAt;
  DateTime? updatedAt;
  
  User({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    required this.email,
    required this.createdAt,
    this.updatedAt,
  });
  
  // 计算BMI
  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }
  
  // 获取BMI评级
  String get bmiRating {
    final bmiValue = bmi;
    if (bmiValue < 18.5) {
      return '偏瘦';
    } else if (bmiValue < 24) {
      return '正常';
    } else if (bmiValue < 28) {
      return '超重';
    } else {
      return '肥胖';
    }
  }
  
  // 从Map创建
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      weight: (map['weight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      age: map['age'] ?? 0,
      email: map['email'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
  
  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'height': height,
      'age': age,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class WorkoutRecord {
  String id;
  String userId;
  String workoutType;
  DateTime startTime;
  DateTime endTime;
  double distance; // 米
  int duration; // 秒
  int calories;
  List<HeartRateData> heartRates;
  List<GpsPoint> route;
  
  WorkoutRecord({
    required this.id,
    required this.userId,
    required this.workoutType,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.heartRates,
    required this.route,
  });
  
  // 获取平均速度 (米/秒)
  double get averageSpeed {
    if (duration <= 0) return 0;
    return distance / duration;
  }
  
  // 获取平均心率
  double get averageHeartRate {
    if (heartRates.isEmpty) return 0;
    final total = heartRates.map((hr) => hr.value).reduce((a, b) => a + b);
    return total / heartRates.length;
  }
  
  factory WorkoutRecord.fromMap(Map<String, dynamic> map) {
    final heartRates = (map['heartRates'] as List<dynamic>? ?? [])
        .map((hr) => HeartRateData.fromMap(hr))
        .toList();
    
    final route = (map['route'] as List<dynamic>? ?? [])
        .map((point) => GpsPoint.fromMap(point))
        .toList();
    
    return WorkoutRecord(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      workoutType: map['workoutType'] ?? '',
      startTime: DateTime.parse(map['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(map['endTime'] ?? DateTime.now().toIso8601String()),
      distance: (map['distance'] ?? 0).toDouble(),
      duration: map['duration'] ?? 0,
      calories: map['calories'] ?? 0,
      heartRates: heartRates,
      route: route,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'workoutType': workoutType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'calories': calories,
      'heartRates': heartRates.map((hr) => hr.toMap()).toList(),
      'route': route.map((point) => point.toMap()).toList(),
    };
  }
}

class HeartRateData {
  DateTime timestamp;
  int value; // BPM
  
  HeartRateData({
    required this.timestamp,
    required this.value,
  });
  
  factory HeartRateData.fromMap(Map<String, dynamic> map) {
    return HeartRateData(
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      value: map['value'] ?? 0,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
    };
  }
}

class GpsPoint {
  double latitude;
  double longitude;
  double altitude;
  DateTime timestamp;
  double? speed;
  
  GpsPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.timestamp,
    this.speed,
  });
  
  factory GpsPoint.fromMap(Map<String, dynamic> map) {
    return GpsPoint(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      altitude: (map['altitude'] ?? 0).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      speed: (map['speed'] ?? 0).toDouble(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'timestamp': timestamp.toIso8601String(),
      'speed': speed,
    };
  }
}