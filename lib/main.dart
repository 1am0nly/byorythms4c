import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:local_auth/local_auth.dart';
import 'app.dart';
import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';
import 'data/database/providers.dart';
import 'features/onboarding/providers/has_seen_onboarding_provider.dart';
import 'features/premium/providers/purchase_provider.dart';
import 'features/settings/providers/locale_provider.dart';
import 'features/settings/providers/theme_provider.dart';
import 'features/settings/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer();
  final dao = container.read(settingsDaoProvider);
  final savedLocale = await dao.get('locale') ?? 'ru';
  await initializeDateFormatting(savedLocale);
  if (savedLocale != 'en') {
    await initializeDateFormatting('en');
  }

  await container.read(hasSeenOnboardingProvider.future);
  await container.read(themeModeProvider.future);
  await container.read(localeProvider.future);
  await container.read(isPremiumProvider.future);

  final notifService = container.read(notificationServiceProvider);
  await notifService.initialize();

  final s = AppStringsLocale(savedLocale);

  // ВАЖНО: Автопуш через periodicallyShow убран (промпт 41/43).
  // Оставлена только ручная кнопка "Показать сводку сейчас" с реальными данными.
  Future<void> startApp() async {
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const BiorhythmsApp(),
      ),
    );
  }

  final biometricEnabled = await dao.get('biometricEnabled');
  if (biometricEnabled == 'true') {
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: BiometricLockApp(
          s: s,
          container: container,
          onSuccess: startApp,
        ),
      ),
    );
  } else {
    await startApp();
  }
}

class BiometricLockApp extends StatefulWidget {
  final AppStringsLocale s;
  final ProviderContainer container;
  final VoidCallback onSuccess;

  const BiometricLockApp({
    super.key,
    required this.s,
    required this.container,
    required this.onSuccess,
  });

  @override
  State<BiometricLockApp> createState() => _BiometricLockAppState();
}

class _BiometricLockAppState extends State<BiometricLockApp> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: widget.s.biometricAccessReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (authenticated) {
        widget.onSuccess();
      } else {
        setState(() {
          _errorMessage = widget.s.accessDenied;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${widget.s.biometricError}: $e';
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.s.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      widget.s.biometricAccessReason,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 40),
                  if (_isAuthenticating)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _authenticate,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(widget.s.unlock),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
