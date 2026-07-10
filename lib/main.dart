import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/cubit/home_cubit.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/service/home_service.dart';
import 'theme/haven_theme.dart';

void main() {
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
      home: BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const HomeScreen(),
      ),
    );
  }
}
