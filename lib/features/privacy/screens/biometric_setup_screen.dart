import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/privacy/providers/biometric_provider.dart';

class BiometricSetupScreen extends ConsumerWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.biometricSetup)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fingerprint,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          s.protectProfilesBiometric,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s.biometricDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          biometricAvailable.when(
            data: (available) {
              if (!available) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s.biometricNotSupported,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SwitchListTile(
                title: Text(s.biometricProtection),
                subtitle: Text(s.biometricSubtitle),
                value: biometricEnabled,
                onChanged: (value) async {
                  if (value) {
                    final auth = LocalAuthentication();
                    final authenticated = await auth.authenticate(
                      localizedReason: s.biometricAuthReason,
                    );
                    if (authenticated) {
                      ref
                          .read(biometricEnabledProvider.notifier)
                          .setEnabled(true);
                    }
                  } else {
                    ref
                        .read(biometricEnabledProvider.notifier)
                        .setEnabled(false);
                  }
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => ListTile(
              title: Text(s.biometricError),
              subtitle: Text(s.biometricErrorSub),
            ),
          ),
        ],
      ),
    );
  }
}
