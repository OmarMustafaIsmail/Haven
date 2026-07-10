import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven/features/home/cubit/home_cubit.dart';
import 'package:haven/features/home/screens/home_screen.dart';
import 'package:haven/features/home/service/home_service.dart';

void main() {
  testWidgets('Home screen loads mock data for Omar', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Good afternoon, Omar.'), findsOneWidget);
    expect(find.text('42,350 EGP'), findsOneWidget);
    expect(
      find.text("You're doing great! Nothing needs your attention right now."),
      findsOneWidget,
    );
  });
}
