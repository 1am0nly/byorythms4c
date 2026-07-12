import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/data/models/person.dart';
import 'package:biorhythms_flutter/features/home/providers/avatar_provider.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';

class ProfileManagementScreen extends ConsumerWidget {
  const ProfileManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final personsAsync = ref.watch(personsProvider);
    final persons = personsAsync.valueOrNull ?? [];
    final maxProfiles = ref.watch(maxProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.profileManagement)),
      floatingActionButton: persons.length >= maxProfiles
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showAddEditDialog(context, ref, s),
            ),
      body: persons.isEmpty
          ? Center(child: Text(s.noProfiles))
          : ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                final avatar = ref.watch(avatarProvider(person.id));
                return Dismissible(
                  key: Key(person.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(s.deleteProfileTitle),
                        content: Text(s.deleteProfileConfirm.replaceFirst('{name}', person.name)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(s.cancel),
                          ),
                          FilledButton(
                            onPressed: () {
                              ref.read(personRepositoryProvider).delete(person.id);
                              Navigator.of(ctx).pop(true);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(ctx).colorScheme.error,
                            ),
                            child: Text(s.delete),
                          ),
                        ],
                      ),
                    ) ?? false;
                  },
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(avatar ?? person.name[0].toUpperCase()),
                    ),
                    title: Text(person.name),
                    subtitle: Text(
                      DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(person.birthDate),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showAddEditDialog(
                        context,
                        ref,
                        s,
                        existing: person,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddEditDialog(
    BuildContext context,
    WidgetRef ref,
    AppStringsLocale s, {
    Person? existing,
  }) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    DateTime selectedDate = existing?.birthDate ?? DateTime(2000, 1, 1);
    String selectedEmoji = existing != null
        ? ref.read(avatarProvider(existing.id)) ?? ''
        : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing != null ? s.editProfile : s.addProfileDialog),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: s.name,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (existing != null) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: kAvatarEmojis.map((emoji) {
                      final isSelected = selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () => setState(() => selectedEmoji = emoji),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.primary)
                                : null,
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: Localizations.localeOf(context),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: s.birthDate,
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(selectedDate),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                if (existing != null) {
                  ref.read(personRepositoryProvider).update(
                    existing.copyWith(
                      name: nameController.text.trim(),
                      birthDate: selectedDate,
                    ),
                  );
                  if (selectedEmoji.isNotEmpty) {
                    await ref.read(avatarProvider(existing.id).notifier).setAvatar(selectedEmoji);
                  }
                } else {
                  final newId = await ref.read(personRepositoryProvider).add(
                    Person(
                      id: '',
                      name: nameController.text.trim(),
                      birthDate: selectedDate,
                    ),
                  );
                  if (selectedEmoji.isNotEmpty) {
                    await ref.read(avatarProvider('p_$newId').notifier).setAvatar(selectedEmoji);
                  }
                }
                Navigator.of(ctx).pop();
              },
              child: Text(s.save),
            ),
          ],
        ),
      ),
    );
  }
}
