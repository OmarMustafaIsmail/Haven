import 'package:flutter/material.dart';

import 'features/shell/app_shell.dart';
import 'theme/haven_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HavenApp());
}

class HavenApp extends StatelessWidget {
  const HavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haven',
      debugShowCheckedModeBanner: false,
      theme: HavenTheme.light,
      home: const HavenBootstrap(),
    );
  }
}
