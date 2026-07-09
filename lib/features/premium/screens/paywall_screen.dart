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
    final pricing = ref.watch(premiumPricingProvider);
    final isDark = theme.brightness == Brightness.dark;

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
      await ref.read(isPremiumProvider.notifier).purchasePlan(_selectedPlan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).premiumActivated)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
                  ? Colors.white.withOpacity(0.06)
                  : Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? colorScheme.primary.withOpacity(0.6) : Colors.white.withOpacity(0.15),
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
                  style: const TextStyle(
                    color: Colors.white,
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

class _LinkText extends ConsumerWidget {
  final String text;

  const _LinkText({required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final isRestore = text == s.restoreLink;
    final isPrivacy = text == s.privacyLink;
    final isTerms = text == s.termsLink;
    return TextButton(
      onPressed: isRestore
          ? () async {
              final restored = ref.read(isPremiumProvider.notifier);
              await restored.restorePurchases();
              if (context.mounted) {
                final isPremium = ref.read(isPremiumProvider).valueOrNull ?? false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isPremium
                          ? AppStrings.of(context).premiumActivated
                          : AppStrings.of(context).noPurchasesFound,
                    ),
                  ),
                );
              }
            }
          : isPrivacy
              ? () => context.push('/legal/privacy')
              : isTerms
                  ? () => context.push('/legal/eula')
                  : () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
