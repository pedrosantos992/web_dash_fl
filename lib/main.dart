import 'package:flutter/material.dart';
import 'package:web_dash_fl/pages/home.dart';
import 'pages/analytics_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: "flutter demo"),
      routes: {
        '/analytics': (context) => const AnalyticsPage(),
      },
      initialRoute: '/', // Set the initial route
      debugShowCheckedModeBanner: false,
    );
  }
}
