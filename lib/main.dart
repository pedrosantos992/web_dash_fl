import 'package:flutter/material.dart';
import 'package:web_dash_fl/pages/home.dart';
import 'pages/about_page.dart'; // Import the AboutPage from another file

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
        '/about': (context) => const AboutPage(),
      },
      initialRoute: '/', // Set the initial route
      debugShowCheckedModeBanner: false,
    );
  }
}
