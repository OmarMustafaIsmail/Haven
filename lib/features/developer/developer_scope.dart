import 'package:flutter/material.dart';

import '../shell/app_shell.dart';
import 'dev_time_config.dart';

/// Provides [HavenAppServices] + [DevTimeController] below the shell.
class DeveloperScope extends InheritedWidget {
  const DeveloperScope({
    super.key,
    required this.services,
    required this.devTime,
    required super.child,
  });

  final HavenAppServices services;
  final DevTimeController devTime;

  static DeveloperScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DeveloperScope>();
    assert(scope != null, 'DeveloperScope not found');
    return scope!;
  }

  static DeveloperScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DeveloperScope>();
  }

  @override
  bool updateShouldNotify(DeveloperScope oldWidget) =>
      services != oldWidget.services || devTime != oldWidget.devTime;
}
