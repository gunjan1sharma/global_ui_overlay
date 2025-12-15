import 'package:flutter/material.dart';

enum OverlayPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class OverlayAlignmentConfig {
  final OverlayPosition position;
  final EdgeInsets margin;

  const OverlayAlignmentConfig({
    this.position = OverlayPosition.bottomRight,
    EdgeInsets? margin,
  }) : margin = margin ?? const EdgeInsets.all(16);

  // Default margins for each position
  static EdgeInsets defaultMarginFor(OverlayPosition position) {
    switch (position) {
      case OverlayPosition.topLeft:
        return const EdgeInsets.only(top: 80, left: 16);
      case OverlayPosition.topCenter:
        return const EdgeInsets.only(top: 80);
      case OverlayPosition.topRight:
        return const EdgeInsets.only(top: 80, right: 16);
      case OverlayPosition.centerLeft:
        return const EdgeInsets.only(left: 16);
      case OverlayPosition.center:
        return EdgeInsets.zero;
      case OverlayPosition.centerRight:
        return const EdgeInsets.only(right: 16);
      case OverlayPosition.bottomLeft:
        return const EdgeInsets.only(bottom: 96, left: 16);
      case OverlayPosition.bottomCenter:
        return const EdgeInsets.only(bottom: 96);
      case OverlayPosition.bottomRight:
        return const EdgeInsets.only(bottom: 96, right: 16);
    }
  }

  Positioned positionWidget(Widget child) {
    final effectiveMargin = margin;

    switch (position) {
      case OverlayPosition.topLeft:
        return Positioned(
          top: effectiveMargin.top,
          left: effectiveMargin.left,
          child: child,
        );
      case OverlayPosition.topCenter:
        return Positioned(
          top: effectiveMargin.top,
          left: 0,
          right: 0,
          child: Center(child: child),
        );
      case OverlayPosition.topRight:
        return Positioned(
          top: effectiveMargin.top,
          right: effectiveMargin.right,
          child: child,
        );
      case OverlayPosition.centerLeft:
        return Positioned(
          left: effectiveMargin.left,
          top: 0,
          bottom: 0,
          child: Center(child: child),
        );
      case OverlayPosition.center:
        return Positioned.fill(child: Center(child: child));
      case OverlayPosition.centerRight:
        return Positioned(
          right: effectiveMargin.right,
          top: 0,
          bottom: 0,
          child: Center(child: child),
        );
      case OverlayPosition.bottomLeft:
        return Positioned(
          bottom: effectiveMargin.bottom,
          left: effectiveMargin.left,
          child: child,
        );
      case OverlayPosition.bottomCenter:
        return Positioned(
          bottom: effectiveMargin.bottom,
          left: 0,
          right: 0,
          child: Center(child: child),
        );
      case OverlayPosition.bottomRight:
        return Positioned(
          bottom: effectiveMargin.bottom,
          right: effectiveMargin.right,
          child: child,
        );
    }
  }
}
