import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/widgets/glass_card.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPlan = 'yearly';
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pricingAsync = ref.watch(premiumPricingProvider);
    final isDark = theme.brightness == Brightness.dark;

    return pricingAsync.when(
      data: (pricing) => _buildPaywall(context, s, theme, colorScheme, pricing, isDark),
      loading: () => _buildLoadingScaffold(context, colorScheme, isDark),
      error: (e, _) => _buildPaywall(
          context,
          s,
          theme,
          colorScheme,
          const PremiumPricing(),
          isDark,
        ),
    );
  }

  Widget _buildLoadingScaffold(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1A1B2E),
                    const Color(0xFF0E0F1A),
                    const Color(0xFF07080E),
                  ]
                : [
                    const Color(0xFFF0EFF6),
                    const Color(0xFFFAFAFC),
                    const Color(0xFFF5F5FA),
                  ],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildPaywall(
    BuildContext context,
    AppStringsLocale s,
    ThemeData theme,
    ColorScheme colorScheme,
    PremiumPricing pricing,
    bool isDark,
  ) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1A1B2E),
                    const Color(0xFF0E0F1A),
                    const Color(0xFF07080E),
                  ]
                : [
                    const Color(0xFFF0EFF6),
                    const Color(0xFFFAFAFC),
                    const Color(0xFFF5F5FA),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(s.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      GlassCard(
                        borderRadius: 40,
                        blurIntensity: 8,
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.auto_awesome,
                          size: 56,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        s.premiumTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.premiumSubtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _FeatureRow(
                              icon: Icons.people_outline,
                              text: s.featureUnlimitedProfiles,
                            ),
                            const SizedBox(height: 14),
                            _FeatureRow(
                              icon: Icons.calendar_view_week,
                              text: s.feature30Days,
                            ),
                            const SizedBox(height: 14),
                            _FeatureRow(
                              icon: Icons.woman_outlined,
                              text: s.featureFemaleMode,
                            ),
                            const SizedBox(height: 14),
                            _FeatureRow(
                              icon: Icons.fingerprint,
                              text: s.featureBiometric,
                            ),
                            const SizedBox(height: 14),
                            _FeatureRow(
                              icon: Icons.download_outlined,
                              text: s.featureExport,
                            ),
                            const SizedBox(height: 14),
                            _FeatureRow(
                              icon: Icons.compare_arrows,
                              text: s.featureCompatibility,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _PlanCard(
                              title: s.monthly,
                              price: pricing.monthlyPrice,
                              subtitle: '/${s.month.toLowerCase()}',
                              isSelected: _selectedPlan == 'monthly',
                              onTap: () =>
                                  setState(() => _selectedPlan = 'monthly'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PlanCard(
                              title: s.yearly,
                              price: pricing.yearlyPrice,
                              subtitle: pricing.monthlyPerMonth,
                              badge: s.badge,
                              isSelected: _selectedPlan == 'yearly',
                              onTap: () =>
                                  setState(() => _selectedPlan = 'yearly'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          onPressed: _isPurchasing ? null : _purchase,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isPurchasing
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Text(
                                  _selectedPlan == 'yearly'
                                      ? s.trialButtonText(pricing.trialDays)
                                      : s.subscribeButton,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        borderRadius: 12,
                        blurIntensity: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(
                          _selectedPlan == 'yearly'
                              ? s.yearlySubtextText(pricing.yearlyPrice)
                              : s.monthlySubtextText(pricing.monthlyPrice),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _LinkText(text: s.privacyLink),
                          Text(' · ', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                          _LinkText(text: s.termsLink),
                          Text(' · ', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                          _LinkText(text: s.restoreLink),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _purchase() async {
    setState(() => _isPurchasing = true);
    try {
      final initiated =
          await ref.read(isPremiumProvider.notifier).purchasePlan(_selectedPlan);
      if (!mounted) return;
      if (initiated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).premiumActivated)),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).storeUnavailable)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).purchaseError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.15)
              : (theme.brightness == Brightness.dark
                  ? colorScheme.surface.withOpacity(0.06)
                  : colorScheme.surface.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? colorScheme.primary.withOpacity(0.6) : colorScheme.surface.withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            Text(price,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            Text(subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 4),
            Text(title, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _LinkText extends ConsumerStatefulWidget {
  final String text;

  const _LinkText({required this.text});

  @override
  ConsumerState<_LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends ConsumerState<_LinkText> {
  bool _isRestoring = false;

  Future<void> _restorePurchases() async {
    setState(() => _isRestoring = true);
    try {
      final notifier = ref.read(isPremiumProvider.notifier);
      await notifier.restorePurchases();
      if (mounted) {
        final isPremium = ref.read(isPremiumProvider).valueOrNull ?? false;
        final s = AppStrings.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPremium ? s.premiumActivated : s.noPurchasesFound,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isRestore = widget.text == s.restoreLink;
    final isPrivacy = widget.text == s.privacyLink;
    final isTerms = widget.text == s.termsLink;
    return TextButton(
      onPressed: isRestore
          ? _isRestoring ? null : _restorePurchases
          : isPrivacy
              ? () => context.push('/legal/privacy')
              : isTerms
                  ? () => context.push('/legal/eula')
                  : null,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _isRestoring
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Text(
              widget.text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
    );
  }
}
