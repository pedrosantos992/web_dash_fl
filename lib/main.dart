import 'package:flutter/material.dart';
import 'package:web_dash_fl/pages/home.dart';
import 'package:web_dash_fl/pages/settings_page.dart';
import 'pages/analytics_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MyHomePage(title: "flutter demo"),
      routes: {
        '/analytics': (context) => const AnalyticsPage(),
        '/settings': (context) =>
            SettingsPage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
