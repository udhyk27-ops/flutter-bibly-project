import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '말씀과 찬양',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B5CE7),
          brightness: Brightness.light,
        ),
        fontFamily: 'NanumGothic',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B5CE7),
          brightness: Brightness.dark,
        ),
        fontFamily: 'NanumGothic',
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}