import 'dart:convert';

// 格式化时间显示
String formatDuration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;
  
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

// 格式化距离
String formatDistance(double meters) {
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)}米';
  } else {
    return '${(meters / 1000).toStringAsFixed(2)}公里';
  }
}

// 格式化卡路里
String formatCalories(int calories) {
  if (calories < 1000) {
    return '$calories大卡';
  } else {
    return '${(calories / 1000).toStringAsFixed(1)}千卡';
  }
}

// 格式化心率
String formatHeartRate(int bpm) {
  return '$bpm BPM';
}

// 根据心率获取强度等级
String getHeartRateIntensity(int bpm, int age) {
  final maxHeartRate = 220 - age;
  final percentage = (bpm / maxHeartRate) * 100;
  
  if (percentage < 50) {
    return '热身';
  } else if (percentage < 60) {
    return '轻松';
  } else if (percentage < 70) {
    return '燃脂';
  } else if (percentage < 80) {
    return '有氧';
  } else if (percentage < 90) {
    return '无氧';
  } else {
    return '极限';
  }
}

// 计算消耗的卡路里
int calculateCalories(double weight, double distance, int duration) {
  // 简单公式: 每公斤每公里消耗1大卡
  final baseCalories = weight * (distance / 1000);
  
  // 加上时间因素: 每分钟额外消耗0.1大卡/公斤
  final timeFactor = weight * 0.1 * (duration / 60);
  
  return (baseCalories + timeFactor).round();
}

// 安全JSON解析
Map<String, dynamic> safeJsonParse(String jsonString) {
  try {
    return jsonDecode(jsonString);
  } catch (e) {
    return {};
  }
}

// 验证邮箱格式
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  return emailRegex.hasMatch(email);
}

// 验证密码强度
bool isStrongPassword(String password) {
  // 至少8位，包含字母和数字
  if (password.length < 8) return false;
  
  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
  final hasDigit = RegExp(r'[0-9]').hasMatch(password);
  
  return hasLetter && hasDigit;
}

// 生成唯一ID
String generateId() {
  return DateTime.now().microsecondsSinceEpoch.toString();
}

// 获取当前时间戳
int currentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}