import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta_api/talanta_api.dart';

final notificationsProvider = FutureProvider.autoDispose<ActivityPage>(
  (ref) => ref.read(apiProvider).activity.listNotifications(limit: 50),
);

/// The badge on the Activity tab. Zero when it cannot be loaded.
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  try {
    final result = await ref.read(apiProvider).activity.getUnreadCount();
    return result.count.toInt();
  } on Object {
    return 0;
  }
});
