import 'package:flutter/material.dart';

void main() {
  runApp(const SmcTradingApp());
}

class SmcTradingApp extends StatelessWidget {
  const SmcTradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMC Trading Journal',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.green,
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.redAccent,
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMC Trading Journal'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: const Center(
        child: Text(
          'Selamat datang di SMC Trading Journal!\nAplikasi sedang disiapkan.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
    );
  }
}
