import 'dart:async';
import 'dart:convert';

/// AI聊天消息
class AiMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? type; // text, workout_suggestion, nutrition_advice, etc.
  final Map<String, dynamic>? metadata;
  
  AiMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = 'text',
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'metadata': metadata,
    };
  }
  
  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      metadata: json['metadata'],
    );
  }
}

/// AI服务（模拟实现，实际需要集成AI API）
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();
  
  List<AiMessage> _conversationHistory = [];
  StreamController<AiMessage> _messageStream = StreamController.broadcast();
  
  /// 获取对话历史
  List<AiMessage> getConversationHistory() {
    return List.from(_conversationHistory);
  }
  
  /// 发送消息并获取AI回复
  Future<AiMessage> sendMessage(String userMessage) async {
    // 添加用户消息
    final userMsg = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _conversationHistory.add(userMsg);
    _messageStream.add(userMsg);
    
    // 分析用户意图
    final intent = _analyzeIntent(userMessage);
    
    // 模拟AI思考过程
    await Future.delayed(const Duration(seconds: 1));
    
    // 生成AI回复
    final aiReply = _generateAiResponse(userMessage, intent);
    
    // 添加AI回复
    _conversationHistory.add(aiReply);
    _messageStream.add(aiReply);
    
    return aiReply;
  }
  
  /// 分析用户意图
  String _analyzeIntent(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('锻炼') || 
        lowerMessage.contains('训练') || 
        lowerMessage.contains('运动') ||
        lowerMessage.contains('健身')) {
      return 'workout';
    } else if (lowerMessage.contains('饮食') || 
               lowerMessage.contains('营养') || 
               lowerMessage.contains('吃饭') ||
               lowerMessage.contains('食谱')) {
      return 'nutrition';
    } else if (lowerMessage.contains('心率') || 
               lowerMessage.contains('心跳') ||
               lowerMessage.contains('心')) {
      return 'heart_rate';
    } else if (lowerMessage.contains('体重') || 
               lowerMessage.contains('减肥') ||
               lowerMessage.contains('减脂')) {
      return 'weight_loss';
    } else if (lowerMessage.contains('计划') || 
               lowerMessage.contains('安排') ||
               lowerMessage.contains('日程')) {
      return 'planning';
    } else {
      return 'general';
    }
  }
  
  /// 生成AI回复
  AiMessage _generateAiResponse(String userMessage, String intent) {
    String response = '';
    String type = 'text';
    Map<String, dynamic> metadata = {};
    
    switch (intent) {
      case 'workout':
        response = _generateWorkoutResponse(userMessage);
        type = 'workout_suggestion';
        metadata = {
          'intent': 'workout',
          'category': _extractWorkoutCategory(userMessage),
        };
        break;
        
      case 'nutrition':
        response = _generateNutritionResponse(userMessage);
        type = 'nutrition_advice';
        metadata = {
          'intent': 'nutrition',
        };
        break;
        
      case 'heart_rate':
        response = _generateHeartRateResponse(userMessage);
        type = 'health_advice';
        metadata = {
          'intent': 'heart_rate',
        };
        break;
        
      case 'weight_loss':
        response = _generateWeightLossResponse(userMessage);
        type = 'motivation';
        metadata = {
          'intent': 'weight_loss',
        };
        break;
        
      case 'planning':
        response = _generatePlanningResponse(userMessage);
        type = 'plan_suggestion';
        metadata = {
          'intent': 'planning',
        };
        break;
        
      default:
        response = _generateGeneralResponse(userMessage);
        type = 'text';
        break;
    }
    
    return AiMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
      type: type,
      metadata: metadata,
    );
  }
  
  /// 生成锻炼建议
  String _generateWorkoutResponse(String message) {
    final responses = [
      '根据您的情况，我建议进行30分钟的有氧运动，如快走或慢跑，配合10分钟的力量训练。',
      '今天适合进行HIIT训练，20秒高强度运动后休息10秒，重复8组。记得运动前热身！',
      '我为您推荐一套有氧燃脂训练：开合跳30秒、高抬腿30秒、深蹲20次，休息30秒后重复3组。',
      '针对您的目标，建议每周进行3-5次中等强度运动，每次30-45分钟，保持心率在燃脂区间。',
      '今天的训练建议：跑步机30分钟（速度6-8km/h），然后进行核心训练（平板支撑、仰卧起坐）。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 生成营养建议
  String _generateNutritionResponse(String message) {
    final responses = [
      '建议摄入高蛋白食物，如鸡胸肉、鱼类、豆制品，搭配大量蔬菜和适量复合碳水。',
      '运动后30分钟内是补充营养的黄金期，可以喝蛋白粉或吃一根香蕉补充能量。',
      '每天保证充足水分，每公斤体重摄入30-40毫升水，运动时适当增加。',
      '减脂期间建议控制碳水摄入，增加膳食纤维，避免高糖分食物和加工食品。',
      '早餐要丰富，午餐要均衡，晚餐要清淡。建议少食多餐，避免暴饮暴食。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 生成心率建议
  String _generateHeartRateResponse(String message) {
    final responses = [
      '最佳燃脂心率区间为您最大心率的60%-70%，可以在此区间保持较长时间的运动。',
      '运动时心率过高时建议适当降低强度，保持在有氧区间更安全有效。',
      '静息心率越低通常代表心肺功能越好，正常成年人在60-100次/分钟。',
      '运动后心率应在10分钟内恢复到接近静息水平，如恢复缓慢可能运动强度过大。',
      '建议使用心率监测设备，确保运动时心率在安全有效的范围内。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 生成减重建议
  String _generateWeightLossResponse(String message) {
    final responses = [
      '健康的减重速度是每周0.5-1公斤，过快减重可能影响健康。',
      '减脂的关键是热量缺口，建议每天比正常摄入少300-500大卡。',
      '有氧运动燃脂，力量训练增肌，两者结合效果最佳。',
      '记录饮食和运动可以帮助您更好地控制进度和调整计划。',
      '不要只看体重变化，关注体脂率和身体围度的变化更科学。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 生成计划建议
  String _generatePlanningResponse(String message) {
    final responses = [
      '建议制定周训练计划：周一、周三、周五有氧运动，周二、周四力量训练，周末休息或轻度活动。',
      '可以尝试3-2-1计划：每周3次有氧、2次力量、1次灵活性训练。',
      '根据您的时间安排，建议早上进行30分钟有氧，晚上进行20分钟力量训练。',
      '计划应包含热身（5-10分钟）、主运动（20-40分钟）、冷身（5-10分钟）三个阶段。',
      '建议每4-6周调整一次训练计划，避免身体适应导致效果下降。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 生成一般回复
  String _generateGeneralResponse(String message) {
    final responses = [
      '我理解您的需求，让我为您提供专业的健身建议。',
      '很高兴为您服务！我是您的专属健身助手。',
      '健康的生活方式需要坚持和科学的方法，我会陪伴您一起进步！',
      '每个人的身体状况和目标都不同，我会根据您的情况提供个性化建议。',
      '运动不仅能改善体型，还能提升精神状态和生活质量。',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }
  
  /// 提取锻炼类别
  String _extractWorkoutCategory(String message) {
    if (message.contains('有氧') || message.contains('跑步') || message.contains('游泳')) {
      return 'cardio';
    } else if (message.contains('力量') || message.contains('举重') || message.contains('器械')) {
      return 'strength';
    } else if (message.contains('拉伸') || message.contains('瑜伽') || message.contains('柔韧')) {
      return 'flexibility';
    } else {
      return 'general';
    }
  }
  
  /// 获取消息流
  Stream<AiMessage> get messageStream => _messageStream.stream;
  
  /// 清除对话历史
  void clearConversation() {
    _conversationHistory.clear();
  }
  
  /// 保存对话历史
  Future<void> saveConversation() async {
    // 这里可以实现本地保存逻辑
    print('Conversation saved: ${_conversationHistory.length} messages');
  }
  
  /// 获取运动统计数据（与运动模块隔离）
  Map<String, dynamic> getWorkoutStats() {
    // 模拟数据，实际应从运动模块获取
    return {
      'totalWorkouts': 15,
      'totalCalories': 4500,
      'totalDistance': 42.5,
      'avgHeartRate': 132,
      'bestWorkout': '2024-01-15',
    };
  }
}