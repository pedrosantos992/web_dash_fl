import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Dark mode',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        widget.toggleTheme(value); // Toggle theme mode
                      });
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
