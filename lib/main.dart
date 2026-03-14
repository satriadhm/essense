import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const EssenceApp());
}

class EssenceApp extends StatelessWidget {
  const EssenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESSENCE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgDeep,
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentPurple,
          surface: AppColors.bgDeep,
        ),
      ),
      home: const MainShell(),
    );
  }
}

