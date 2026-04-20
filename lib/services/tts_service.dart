import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// 语音播报服务
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal() {
    _init();
  }

  late FlutterTts _tts;
  
  Future<void> _init() async {
    _tts = FlutterTts();
    
    // 设置中文语音
    await _tts.setLanguage('zh-CN');
    await _tts.setSpeechRate(0.5); // 语速
    await _tts.setVolume(1.0);     // 音量
    await _tts.setPitch(1.0);      // 音调
  }
  
  /// 播放欢迎语音
  Future<void> speakWelcome() async {
    await _tts.speak('欢迎使用跟着减，您的有氧减脂语音私教');
  }
  
  /// 播放开始运动语音
  Future<void> speakWorkoutStart(String workoutName) async {
    await _tts.speak('开始$workoutName训练，请做好准备');
  }
  
  /// 播放动作提示
  Future<void> speakActionPrompt(String actionName, int count) async {
    await _tts.speak('$actionName，第$count次');
  }
  
  /// 播放休息提醒
  Future<void> speakRestReminder(int seconds) async {
    await _tts.speak('休息${seconds}秒，调整呼吸');
  }
  
  /// 播放完成提示
  Future<void> speakWorkoutComplete(int calories, int duration) async {
    await _tts.speak('训练完成，消耗${calories}卡路里，用时${duration}分钟');
  }
  
  /// 播放心率提醒
  Future<void> speakHeartRateAlert(int heartRate) async {
    await _tts.speak('您的心率为$heartRate，请注意调整运动强度');
  }
  
  /// 播放错误提示
  Future<void> speakError(String message) async {
    await _tts.speak('系统提示：$message');
  }
  
  /// 停止语音
  Future<void> stop() async {
    await _tts.stop();
  }
  
  /// 设置语速
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }
  
  /// 设置音量
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }
}