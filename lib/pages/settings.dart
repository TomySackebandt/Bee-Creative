import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              AdaptiveTheme.of(context).theme.appBarTheme.backgroundColor,
          title: const Text('Creation Details'),
        ),
        body: Column(children: [
          Text("Change theme"),
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: Icon(Icons.sunny))
        ]));
  }
}
