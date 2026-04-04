import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/weather_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EssenceApp());
}

class EssenceApp extends StatelessWidget {
  const EssenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WeatherProvider())],
      child: MaterialApp(
        title: 'Essense.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.bgDeep,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          textTheme: GoogleFonts.montserratTextTheme(),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentPurple,
            surface: AppColors.bgDeep,
          ),
        ),
        home: const SplashScreen(),
        routes: {'/home': (context) => const MainShell()},
      ),
    );
  }
}
