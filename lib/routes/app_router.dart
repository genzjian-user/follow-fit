import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:follow_fit/screens/home_screen.dart';
import 'package:follow_fit/screens/workout_screen.dart';
import 'package:follow_fit/screens/heart_rate_screen.dart';
import 'package:follow_fit/screens/ai_chat_screen.dart';
import 'package:follow_fit/screens/history_screen.dart';
import 'package:follow_fit/screens/profile_screen.dart';
import 'package:follow_fit/screens/splash_screen.dart';
import 'package:follow_fit/screens/login_screen.dart';
import 'package:follow_fit/screens/workout_detail_screen.dart';

// 路由配置
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // 启动页
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // 登录页
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // 主页（底部导航栏）
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // 首页
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // 运动页面
          GoRoute(
            path: '/workout',
            name: 'workout',
            builder: (context, state) => const WorkoutScreen(),
          ),
          
          // 心率监测
          GoRoute(
            path: '/heart-rate',
            name: 'heartRate',
            builder: (context, state) => const HeartRateScreen(),
          ),
          
          // AI聊天
          GoRoute(
            path: '/ai-chat',
            name: 'aiChat',
            builder: (context, state) => const AiChatScreen(),
          ),
          
          // 历史记录
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          
          // 个人中心
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // 运动详情页
      GoRoute(
        path: '/workout/:id',
        name: 'workoutDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WorkoutDetailScreen(workoutId: id);
        },
      ),
    ],
    redirect: (context, state) {
      // 登录状态检查
      final isAuthenticated = false; // 这里应该从状态管理获取
      
      if (state.fullPath == '/splash') {
        return null; // 允许进入启动页
      }
      
      if (!isAuthenticated && state.fullPath != '/login') {
        return '/login'; // 未登录重定向到登录页
      }
      
      if (isAuthenticated && state.fullPath == '/login') {
        return '/home'; // 已登录不能访问登录页
      }
      
      return null; // 允许正常访问
    },
  );
});

// 主布局（底部导航栏）
class MainLayout extends StatefulWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});
  
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  
  final List<String> _routePaths = [
    '/home',
    '/workout',
    '/heart-rate',
    '/ai-chat',
    '/history',
  ];
  
  final List<String> _routeNames = [
    '首页',
    '运动',
    '心率',
    'AI',
    '历史',
  ];
  
  final List<IconData> _routeIcons = [
    Icons.home,
    Icons.directions_run,
    Icons.favorite,
    Icons.chat,
    Icons.history,
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routePaths[index]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: List.generate(
          _routeNames.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_routeIcons[index]),
            label: _routeNames[index],
          ),
        ),
      ),
    );
  }
}