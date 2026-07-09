import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';

class PremiumGate extends ConsumerWidget {
  final Widget child;
  final String feature;

  const PremiumGate({
    super.key,
    required this.child,
    required this.feature,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
    if (isPremium) return child;

    return Stack(
      children: [
        Opacity(opacity: 0.4, child: AbsorbPointer(child: child)),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.push('/paywall'),
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_open,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Premium: $feature',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PremiumLockedFeature extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String description;

  const PremiumLockedFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
    if (isPremium) return const SizedBox.shrink();

    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Premium',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        onTap: () => context.push('/paywall'),
      ),
    );
  }
}
