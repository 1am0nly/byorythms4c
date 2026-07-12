import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/widgets/glass_card.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/home/widgets/biorhythm_chart.dart';
import 'package:biorhythms_flutter/features/home/widgets/biorhythm_dots.dart';
import 'package:biorhythms_flutter/features/home/widgets/chart_export.dart';
import 'package:biorhythms_flutter/features/home/widgets/daily_summary.dart';
import 'package:biorhythms_flutter/features/home/widgets/profile_selector.dart';
import 'package:biorhythms_flutter/features/home/widgets/statistics_card.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _chartRepaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final focusDate = ref.watch(focusDateProvider);
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
    final isToday = focusDate == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dateFormat = DateFormat('d MMMM', Localizations.localeOf(context).languageCode);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppStrings.appTitle),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isPremium
                    ? colorScheme.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPremium ? Icons.workspace_premium : Icons.workspace_premium_outlined,
                size: 18,
                color: isPremium
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (isPremium)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _shareChart(context),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_view_month_outlined),
            onPressed: () => context.push('/year-overview'),
            tooltip: s.yearOverviewTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              GlassCard(
                borderRadius: 20,
                blurIntensity: 10,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ProfileSelector(),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: focusDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          locale: Localizations.localeOf(context),
                        );
                        if (!mounted) return;
                        if (picked != null) {
                          ref.read(focusDateProvider.notifier).state = picked;
                        }
                      },
                      child: Text(
                        isToday ? '${AppStrings.today}, ${dateFormat.format(focusDate)}' : dateFormat.format(focusDate),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                borderRadius: 20,
                blurIntensity: 10,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        final current = ref.read(focusDateProvider);
                        ref.read(focusDateProvider.notifier).state =
                            current.subtract(const Duration(days: 1));
                      },
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity == null) return;
                        if (details.primaryVelocity! < 0) {
                          final current = ref.read(focusDateProvider);
                          ref.read(focusDateProvider.notifier).state =
                              current.add(const Duration(days: 1));
                        } else if (details.primaryVelocity! > 0) {
                          final current = ref.read(focusDateProvider);
                          ref.read(focusDateProvider.notifier).state =
                              current.subtract(const Duration(days: 1));
                        }
                      },
                      child: Text(
                        DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(focusDate),
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        final current = ref.read(focusDateProvider);
                        ref.read(focusDateProvider.notifier).state =
                            current.add(const Duration(days: 1));
                      },
                    ),
                  ],
                ),
              ),
              if (!isToday)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    icon: const Icon(Icons.today, size: 16),
                    label: Text(s.today),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(focusDateProvider.notifier).state = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              const GlassCard(
                borderRadius: 20,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                child: DailySummary(),
              ),
              const SizedBox(height: 12),
              const GlassCard(
                borderRadius: 20,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                tintColor: Color(0x0AFFFFFF),
                child: StatisticsCard(),
              ),
              const SizedBox(height: 12),
              GlassCard(
                borderRadius: 20,
                blurIntensity: 10,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 320,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity == null) return;
                      if (details.primaryVelocity! < 0) {
                        HapticFeedback.lightImpact();
                        final current = ref.read(focusDateProvider);
                        ref.read(focusDateProvider.notifier).state =
                            current.add(const Duration(days: 1));
                      } else if (details.primaryVelocity! > 0) {
                        HapticFeedback.lightImpact();
                        final current = ref.read(focusDateProvider);
                        ref.read(focusDateProvider.notifier).state =
                            current.subtract(const Duration(days: 1));
                      }
                    },
                    child: BiorhythmChart(repaintKey: _chartRepaintKey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const GlassCard(
                borderRadius: 20,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: BiorhythmDots(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _shareChart(BuildContext context) {
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM yyyy', locale).format(DateTime.now());
    ChartExporter.shareAsPng(
      _chartRepaintKey,
      subject: s.shareSubjectWithDate(dateStr),
    );
  }
}
