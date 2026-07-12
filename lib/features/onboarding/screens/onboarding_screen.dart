import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/data/models/person.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/onboarding/providers/has_seen_onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pages = [
      _OnboardingPageData(
        title: s.onboardingWelcomeTitle,
        description: s.onboardingWelcomeBody,
        icon: Icons.auto_awesome,
      ),
      _OnboardingPageData(
        title: s.onboardingCycleTitle,
        description: s.onboardingCycleBody,
        icon: Icons.show_chart,
      ),
      _OnboardingPageData(
        title: s.onboardingPrivacyTitle,
        description: s.onboardingPrivacyBody,
        icon: Icons.lock_outline,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          page.icon,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPage
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: Text(
                    _currentPage < pages.length - 1
                        ? s.next
                        : s.addFirstProfile,
                  ),
                  onPressed: () {
                    if (_currentPage < pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _showAddProfileDialog(s);
                    }
                  },
                ),
              ),
            ),
            if (_currentPage < pages.length - 1)
              TextButton(
                onPressed: _finishOnboarding,
                child: Text(s.skip),
              )
            else
              const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showAddProfileDialog(AppStringsLocale s) async {
    final nameController = TextEditingController();
    DateTime selectedDate = DateTime(2000, 1, 1);

    try {
      await showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(s.addProfileDialog),
            content: Column(
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
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: Localizations.localeOf(ctx),
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
                        DateFormat('d MMMM yyyy', Localizations.localeOf(ctx).languageCode).format(selectedDate),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _finishOnboarding();
                },
                child: Text(s.skip),
              ),
              FilledButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) return;
                  ref.read(personRepositoryProvider).add(
                    Person(
                      id: '',
                      name: nameController.text.trim(),
                      birthDate: selectedDate,
                    ),
                  );
                  Navigator.of(ctx).pop();
                  _finishOnboarding();
                },
                child: Text(s.save),
              ),
            ],
          ),
        ),
      );
    } finally {
      nameController.dispose();
    }
  }

  void _finishOnboarding() {
    ref.read(hasSeenOnboardingProvider.notifier).complete();
    if (mounted) {
      context.go('/');
    }
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
