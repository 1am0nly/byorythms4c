import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurIntensity;
  final Color? tintColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blurIntensity = 12,
    this.tintColor,
    this.borderColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTint = tintColor ??
        (isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.6));
    final effectiveBorder = borderColor ??
        (isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.5));
    final effectiveShadow = boxShadow ?? [
      BoxShadow(
        color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ];

    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                decoration: BoxDecoration(
                  color: effectiveTint,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: effectiveBorder),
                  boxShadow: effectiveShadow,
                ),
                child: padding != null
                    ? Padding(padding: padding!, child: child)
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
