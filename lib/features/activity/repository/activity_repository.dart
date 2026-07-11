import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/activity_item.dart';

abstract final class MockActivityData {
  static List<ActivityItem> seed() => const [
        ActivityItem(
          id: 'act_lunch',
          kind: ActivityKind.transaction,
          label: 'Lunch',
          amount: -150,
          icon: Icons.restaurant_rounded,
          timestamp: 'Today, 1:15 PM',
          iconBackgroundColor: Color(0xFFFFF4D6),
        ),
      ];
}

/// In-memory Activity timeline — live updates during session.
class ActivityRepository {
  ActivityRepository() {
    _items = List<ActivityItem>.from(MockActivityData.seed());
  }

  late List<ActivityItem> _items;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<ActivityItem> get items => List.unmodifiable(_items);

  void add(ActivityItem item) {
    _items.insert(0, item);
    _version.value++;
  }

  void addInteraction({
    required String label,
    String timestamp = 'Today',
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    add(
      ActivityItem(
        id: 'act_${DateTime.now().microsecondsSinceEpoch}',
        kind: ActivityKind.interaction,
        label: label,
        icon: icon,
        timestamp: timestamp,
        iconBackgroundColor: const Color(0xFFE8F2F0),
      ),
    );
  }
}
