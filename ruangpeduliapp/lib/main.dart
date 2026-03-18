import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruangpeduliapp/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Hide status bar and navigation bar for immersive splash
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const RuangPeduliApp());
}

class RuangPeduliApp extends StatelessWidget {
  const RuangPeduliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruang Peduli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF43D5E),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}