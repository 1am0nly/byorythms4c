import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/core/widgets/glass_card.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/female_mode/providers/cycle_provider.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/referral_provider.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';
import 'package:biorhythms_flutter/features/privacy/providers/biometric_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/locale_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/notification_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/theme_provider.dart';
import 'package:biorhythms_flutter/features/settings/services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final personsAsync = ref.watch(personsProvider);
    final persons = personsAsync.valueOrNull ?? [];
    final selectedId = ref.watch(selectedPersonIdProvider);
    final selectedName = persons.isNotEmpty
        ? (persons.firstWhere(
            (p) => p.id == selectedId,
            orElse: () => persons.first,
          ).name)
        : '—';
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final notifEnabled = ref.watch(notificationEnabledProvider).valueOrNull ?? true;
    final notifHour = ref.watch(notificationHourProvider).valueOrNull ?? 9;
    final notifMinute = ref.watch(notificationMinuteProvider).valueOrNull ?? 0;
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final femaleEnabled = ref.watch(femaleCycleEnabledProvider);
    final referralCodeAsync = ref.watch(referralCodeProvider);
    final referralCode = referralCodeAsync.value ?? '';
    final referralCount = ref.watch(referralCountProvider);
    final currentLocale = ref.watch(localeProvider).valueOrNull ?? const Locale('ru');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SettingsSection(
            title: s.profileSection,
            children: [
              ListTile(
                title: Text(s.currentProfile),
                subtitle: Text(selectedName),
                trailing: persons.length > 1
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onSelected: (id) {
                          ref.read(selectedPersonIdProvider.notifier).select(id);
                        },
                        itemBuilder: (_) => persons.map((p) {
                          return PopupMenuItem(value: p.id, child: Text(p.name));
                        }).toList(),
                      )
                    : null,
              ),
              ListTile(
                title: Text(s.profileManagement),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/profiles'),
              ),
              ListTile(
                title: Text(s.compatibility),
                subtitle: Text(s.compatibilitySub),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/compatibility'),
              ),
            ],
          ),
          if (!isPremium)
            GlassCard(
              borderRadius: 16,
              blurIntensity: 10,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: EdgeInsets.zero,
              tintColor: colorScheme.primary.withOpacity(0.08),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.auto_awesome, color: colorScheme.primary),
                ),
                title: Text(s.premiumCard, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.premiumSub),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    s.tryLabel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                onTap: () => context.push('/paywall'),
              ),
            )
          else
            _SettingsSection(
              title: s.premiumSection,
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.workspace_premium, color: colorScheme.primary),
                  ),
                  title: Text(s.premiumActive),
                  subtitle: _PremiumDaysLeft(daysLabel: s.days),
                  trailing: TextButton(
                    onPressed: () => context.push('/paywall'),
                    child: Text(s.manage),
                  ),
                ),
              ],
            ),
          _SettingsSection(
            title: s.femaleMode.toUpperCase(),
            children: [
              SwitchListTile(
                title: Text(femaleEnabled ? s.femaleOff : s.femaleOn),
                subtitle: Text(s.cycleSub),
                value: femaleEnabled,
                onChanged: (v) async {
                  if (!isPremium) {
                    context.push('/paywall');
                    return;
                  }
                  ref
                      .read(femaleCycleEnabledProvider.notifier)
                      .setEnabled(v);
                },
              ),
              if (femaleEnabled)
                ListTile(
                  title: Text(s.cycleSettings),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings/female'),
                ),
            ],
          ),
          _SettingsSection(
            title: s.biometricSection,
            children: [
              SwitchListTile(
                title: Text(s.biometricSubTitle),
                subtitle: Text(biometricEnabled ? s.biometricOn : s.biometricOff),
                value: biometricEnabled,
                onChanged: (v) async {
                  if (!isPremium) {
                    context.push('/paywall');
                    return;
                  }
                  ref
                      .read(biometricEnabledProvider.notifier)
                      .setEnabled(v);
                },
              ),
              ListTile(
                title: Text(s.biometricSetupTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/biometric'),
              ),
            ],
          ),
          _SettingsSection(
            title: s.notificationsSection,
            children: [
              SwitchListTile(
                title: Text(s.dailyPush),
                value: notifEnabled,
                onChanged: (v) {
                  ref.read(notificationEnabledProvider.notifier).setEnabled(v);
                },
              ),
              ListTile(
                title: Text(s.time),
                subtitle: Text(
                  '${notifHour.toString().padLeft(2, '0')}:${notifMinute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/time'),
              ),
              ListTile(
                title: Text(s.forWhom),
                subtitle: Text(selectedName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              if (notifEnabled)
                ListTile(
                  title: Text('Тестовый пуш сейчас'),
                  subtitle: Text('Проверить, что уведомления приходят'),
                  leading: Icon(Icons.notifications_active, color: colorScheme.primary),
                  onTap: () {
                    ref.read(notificationServiceProvider).showTestNotificationNow();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Тестовое уведомление отправлено — проверь шторку')),
                    );
                  },
                ),
            ],
          ),
          _SettingsSection(
            title: 'Отображаемые циклы',
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();
                  return Column(
                    children: BiorhythmType.values.map((type) {
                      final isEnabled = enabledCycles.contains(type);
                      final color = AppColors.colorForType(type);
                      return SwitchListTile(
                        title: Text(type.title),
                        subtitle: Text(s.cycleVisibilitySub),
                        value: isEnabled,
                        activeColor: color,
                        onChanged: (v) {
                          if (v) {
                            ref.read(enabledCyclesProvider.notifier).toggle(type);
                          } else if (enabledCycles.length > 1) {
                            ref.read(enabledCyclesProvider.notifier).toggle(type);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          _SettingsSection(
            title: s.inviteFriend.toUpperCase(),
            children: [
              ListTile(
                title: Text(s.yourReferralCode),
                subtitle: Text(referralCode),
                trailing: TextButton(
                  onPressed: () => ReferralService.share(
                    referralCode,
                    subject: '${s.appTitle} — ${s.inviteFriend}',
                    text: s.shareInviteText(referralCode),
                  ),
                  child: Text(s.share),
                ),
              ),
              ListTile(
                title: Text(s.friendsInvited),
                subtitle: Text(s.premiumDaysEarned.replaceFirst('{count}', '${referralCount * 7}')),
              ),
            ],
          ),
          _SettingsSection(
            title: s.theme.toUpperCase(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.auto_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (set) {
                    ref.read(themeModeProvider.notifier).setTheme(set.first);
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык / Language'),
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'ru', label: Text('Рус')),
                    ButtonSegment(value: 'en', label: Text('EN')),
                  ],
                  selected: {currentLocale.languageCode},
                  onSelectionChanged: (set) {
                    final newLocale = set.first == 'en'
                        ? const Locale('en')
                        : const Locale('ru');
                    ref.read(localeProvider.notifier).setLocale(newLocale);
                  },
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: s.aboutSection,
            children: [
              ListTile(
                title: Text(s.biorhythmEncyclopedia),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/info'),
              ),
              ListTile(
                title: Text(s.eula),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/legal/eula'),
              ),
              ListTile(
                title: Text(s.privacyPolicy),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/legal/privacy'),
              ),
              ListTile(
                title: Text(s.feedback),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/about/feedback'),
              ),
              ListTile(
                title: Text(s.aboutDeveloper),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/about'),
              ),
              ListTile(
                title: Text(s.version),
                subtitle: const Text(AppStrings.appVersion),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 6),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GlassCard(
          borderRadius: 16,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _PremiumDaysLeft extends ConsumerWidget {
  final String daysLabel;

  const _PremiumDaysLeft({required this.daysLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(premiumDaysRemainingProvider);
    final expiryAsync = ref.watch(premiumExpiryProvider);
    final expiry = expiryAsync.valueOrNull;

    if (days <= 0) return const Text('—');

    final dateStr = expiry != null
        ? DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(expiry)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$days $daysLabel'),
        if (dateStr.isNotEmpty)
          Text(
            'до $dateStr',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
