import 'dart:async';
import 'package:flutter/material.dart';

enum OverlayEffectType {
  none,
  scrollHide,
  fadeOnInactivity,
  slideOnScroll,
  scaleOnScroll,
}

class OverlayEffect {
  final OverlayEffectType type;
  final Duration duration;
  final Duration inactivityDuration;

  const OverlayEffect({
    this.type = OverlayEffectType.none,
    this.duration = const Duration(milliseconds: 300),
    this.inactivityDuration = const Duration(seconds: 3),
  });

  static const OverlayEffect scrollHide = OverlayEffect(
    type: OverlayEffectType.scrollHide,
  );

  static const OverlayEffect fadeOnInactivity = OverlayEffect(
    type: OverlayEffectType.fadeOnInactivity,
    inactivityDuration: Duration(seconds: 5),
  );

  static const OverlayEffect slideOnScroll = OverlayEffect(
    type: OverlayEffectType.slideOnScroll,
  );

  static const OverlayEffect scaleOnScroll = OverlayEffect(
    type: OverlayEffectType.scaleOnScroll,
  );

  static const OverlayEffect none = OverlayEffect(type: OverlayEffectType.none);
}
