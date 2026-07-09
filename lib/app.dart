import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_theme.dart';
import 'package:biorhythms_flutter/features/about/screens/about_screen.dart';
import 'package:biorhythms_flutter/features/about/screens/feedback_screen.dart';
import 'package:biorhythms_flutter/features/female_mode/screens/female_mode_screen.dart';
import 'package:biorhythms_flutter/features/home/screens/compatibility_screen.dart';
import 'package:biorhythms_flutter/features/home/screens/home_screen.dart';
import 'package:biorhythms_flutter/features/home/screens/year_overview_screen.dart';
import 'package:biorhythms_flutter/features/info/screens/info_article_detail_screen.dart';
import 'package:biorhythms_flutter/features/info/screens/info_screen.dart';
import 'package:biorhythms_flutter/features/legal/screens/eula_screen.dart';
import 'package:biorhythms_flutter/features/legal/screens/privacy_screen.dart';
import 'package:biorhythms_flutter/features/onboarding/providers/has_seen_onboarding_provider.dart';
import 'package:biorhythms_flutter/features/onboarding/screens/onboarding_screen.dart';
import 'package:biorhythms_flutter/features/premium/screens/paywall_screen.dart';
import 'package:biorhythms_flutter/features/privacy/screens/biometric_setup_screen.dart';
import 'package:biorhythms_flutter/features/settings/providers/locale_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/theme_provider.dart';
import 'package:biorhythms_flutter/features/settings/screens/notification_time_screen.dart';
import 'package:biorhythms_flutter/features/settings/screens/profile_management_screen.dart';
import 'package:biorhythms_flutter/features/settings/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider).value ?? false;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (hasSeenOnboarding) return null;
      if (state.uri.toString() == '/onboarding') return null;
      return '/onboarding';
    },
    errorBuilder: (context, state) => const _RouterErrorScreen(),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final currentLocation = state.uri.toString();
          int currentIndex = 0;
          if (currentLocation.startsWith('/info')) {
            currentIndex = 1;
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/');
                    break;
                  case 1:
                    context.go('/info');
                    break;
                }
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: AppStrings.of(context).homeTab,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.info_outline),
                  selectedIcon: const Icon(Icons.info),
                  label: AppStrings.of(context).infoTab,
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/info',
            builder: (context, state) => const InfoScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => InfoArticleDetailScreen(
                  articleId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'profiles',
            builder: (context, state) => const ProfileManagementScreen(),
          ),
          GoRoute(
            path: 'time',
            builder: (context, state) => const NotificationTimeScreen(),
          ),
          GoRoute(
            path: 'biometric',
            builder: (context, state) => const BiometricSetupScreen(),
          ),
          GoRoute(
            path: 'female',
            builder: (context, state) => const FemaleModeScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/compatibility',
        builder: (context, state) => const CompatibilityScreen(),
      ),
      GoRoute(
        path: '/year-overview',
        builder: (context, state) => const YearOverviewScreen(),
      ),
      GoRoute(
        path: '/legal/eula',
        builder: (context, state) => const EulaScreen(),
      ),
      GoRoute(
        path: '/legal/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
        routes: [
          GoRoute(
            path: 'feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),
        ],
      ),
    ],
  );
});

class BiorhythmsApp extends ConsumerWidget {
  const BiorhythmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final locale = ref.watch(localeProvider).valueOrNull ?? const Locale('ru');
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class _RouterErrorScreen extends StatelessWidget {
  const _RouterErrorScreen();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(s.pageNotFound),
            TextButton(
              onPressed: () => context.go('/'),
              child: Text(s.goHome),
            ),
          ],
        ),
      ),
    );
  }
}
