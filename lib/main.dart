import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_fit/routes/app_router.dart';
import 'package:follow_fit/theme/app_theme.dart';
import 'package:follow_fit/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化Hive数据库
  await initHive();
  
  // 初始化权限和设置
  await initApp();
  
  runApp(
    const ProviderScope(
      child: FollowFitApp(),
    ),
  );
}

class FollowFitApp extends ConsumerWidget {
  const FollowFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: '跟着减',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      locale: const Locale('zh', 'CN'),
    );
  }
}

Future<void> initHive() async {
  // Hive数据库初始化
  print('Initializing Hive database...');
}

Future<void> initApp() async {
  // 应用初始化
  print('Initializing app...');
}