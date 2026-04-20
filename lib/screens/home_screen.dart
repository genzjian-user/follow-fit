import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跟着减'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 跳转到设置页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎卡片
            _buildWelcomeCard(context),
            const SizedBox(height: 20),
            
            // 今日状态
            _buildTodayStatsCard(context),
            const SizedBox(height: 20),
            
            // 快速开始
            _buildQuickStartCard(context),
            const SizedBox(height: 20),
            
            // 训练计划
            _buildWorkoutPlanCard(context),
            const SizedBox(height: 20),
            
            // 最新进展
            _buildRecentProgressCard(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '欢迎回来，用户',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '今天也要坚持运动哦！',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTodayStatsCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日数据',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  '0',
                  '卡路里',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
                _buildStatItem(
                  context,
                  '0',
                  '步数',
                  Icons.directions_walk,
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  '0',
                  '分钟',
                  Icons.timer,
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  '--',
                  '心率',
                  Icons.favorite,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String value, String label, 
                         IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickStartCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快速开始',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickStartButton(
                  context,
                  '户外跑步',
                  Icons.directions_run,
                  Colors.green,
                ),
                _buildQuickStartButton(
                  context,
                  '室内有氧',
                  Icons.fitness_center,
                  Colors.blue,
                ),
                _buildQuickStartButton(
                  context,
                  '力量训练',
                  Icons.sports_gymnastics,
                  Colors.orange,
                ),
                _buildQuickStartButton(
                  context,
                  '瑜伽拉伸',
                  Icons.self_improvement,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickStartButton(BuildContext context, String title, 
                               IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // 开始相应类型的训练
        _showStartWorkoutDialog(context, title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWorkoutPlanCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '本周训练计划',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 查看完整计划
                  },
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPlanItem('周一', '户外跑步', '30分钟', 0.8),
            const Divider(height: 20),
            _buildPlanItem('周二', '力量训练', '45分钟', 0.4),
            const Divider(height: 20),
            _buildPlanItem('周三', '休息日', '休息', 1.0),
            const Divider(height: 20),
            _buildPlanItem('周四', '室内有氧', '40分钟', 0.0),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlanItem(String day, String activity, String duration, double progress) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$activity · $duration',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (progress > 0 && progress < 1.0)
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        if (progress >= 1.0)
          const Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }
  
  Widget _buildRecentProgressCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最新进展',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: Text('暂无最近运动记录'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showStartWorkoutDialog(BuildContext context, String workoutType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('开始$workoutType'),
        content: Text('确定要开始$workoutType训练吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 跳转到运动页面
            },
            child: const Text('开始训练'),
          ),
        ],
      ),
    );
  }
}