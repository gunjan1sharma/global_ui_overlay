import 'package:flutter/material.dart';
import 'overlay_alignment.dart';
import 'overlay_effect.dart';

class GlobalUIOverlayConfig {
  final Widget child;
  final OverlayAlignmentConfig alignment;
  final Duration? displayDelay;
  final OverlayEffect effect;
  final VoidCallback? onTap;
  final VoidCallback? onDisplay;
  final VoidCallback? onHide;
  final VoidCallback? onDispose;
  final bool enableScrollEffect;
  final List<Type>? excludedScreens;

  const GlobalUIOverlayConfig({
    required this.child,
    this.alignment = const OverlayAlignmentConfig(),
    this.displayDelay,
    this.effect = OverlayEffect.none,
    this.onTap,
    this.onDisplay,
    this.onHide,
    this.onDispose,
    this.enableScrollEffect = false,
    this.excludedScreens,
  });
}
