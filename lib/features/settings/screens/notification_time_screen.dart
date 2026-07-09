import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/settings/providers/notification_provider.dart';

class NotificationTimeScreen extends ConsumerStatefulWidget {
  const NotificationTimeScreen({super.key});

  @override
  ConsumerState<NotificationTimeScreen> createState() =>
      _NotificationTimeScreenState();
}

class _NotificationTimeScreenState
    extends ConsumerState<NotificationTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final hour = ref.watch(notificationHourProvider).valueOrNull ?? 9;
    final minute = ref.watch(notificationMinuteProvider).valueOrNull ?? 0;
    final selectedTime = TimeOfDay(hour: hour, minute: minute);

    return Scaffold(
      appBar: AppBar(title: Text(s.notificationTime)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              s.pickNotificationTime,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              selectedTime.format(context),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(s.changeTime),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  ref
                      .read(notificationHourProvider.notifier)
                      .setTime(picked.hour);
                  ref
                      .read(notificationMinuteProvider.notifier)
                      .setTime(picked.minute);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
