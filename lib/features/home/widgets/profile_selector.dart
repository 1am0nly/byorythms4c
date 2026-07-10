import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/features/home/providers/avatar_provider.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';

class ProfileSelector extends ConsumerWidget {
  const ProfileSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personsAsync = ref.watch(personsProvider);
    final persons = personsAsync.valueOrNull ?? [];
    final selectedPerson = ref.watch(selectedPersonProvider);

    if (persons.isEmpty) return const SizedBox.shrink();

    final selectedAvatar = selectedPerson != null
        ? ref.watch(avatarProvider(selectedPerson.id))
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedAvatar != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(selectedAvatar, style: const TextStyle(fontSize: 16)),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedPerson?.id,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              style: Theme.of(context).textTheme.labelLarge,
              onChanged: (value) async {
                if (value != null) {
                  await ref.read(selectedPersonIdProvider.notifier).select(value);
                }
              },
              items: persons.map((p) {
                final avatar = ref.watch(avatarProvider(p.id));
                return DropdownMenuItem<String>(
                  value: p.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (avatar != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(avatar, style: const TextStyle(fontSize: 16)),
                        ),
                      Text(p.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
