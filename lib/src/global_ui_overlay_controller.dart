import 'dart:async';
import 'package:flutter/material.dart';
import 'overlay_config.dart';
import 'overlay_effect.dart';

class GlobalUIOverlay {
  static OverlayEntry? _overlayEntry;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static GlobalUIOverlayConfig? _config;
  static bool _initialized = false;
  static bool _isVisible = true;
  static bool _isScrolling = false;
  static Timer? _scrollStopTimer;
  static Timer? _displayDelayTimer;
  static Timer? _inactivityTimer;
  static double _scrollOffset = 0;
  static double _slideOffset = 0;
  static double _scale = 1.0;

  /// Initialize the overlay with configuration
  static void initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalUIOverlayConfig config,
  }) {
    if (_initialized) return;

    _navigatorKey = navigatorKey;
    _config = config;

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final overlay = navigator.overlay;
    if (overlay == null) return;

    _initialized = true;

    // Handle display delay
    if (config.displayDelay != null) {
      _isVisible = false;
      _displayDelayTimer = Timer(config.displayDelay!, () {
        _isVisible = true;
        _config?.onDisplay?.call();
        _overlayEntry?.markNeedsBuild();
      });
    } else {
      _config?.onDisplay?.call();
    }

    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlay(context));

    overlay.insert(_overlayEntry!);

    // Start inactivity timer if effect is enabled
    if (config.effect.type == OverlayEffectType.fadeOnInactivity) {
      _startInactivityTimer();
    }
  }

  static Widget _buildOverlay(BuildContext context) {
    if (!_isVisible || _config == null) {
      return const SizedBox.shrink();
    }

    Widget overlayWidget = GestureDetector(
      onTap: () {
        _config?.onTap?.call();
        _resetInactivityTimer();
      },
      child: _config!.child,
    );

    // Apply effects
    switch (_config!.effect.type) {
      case OverlayEffectType.slideOnScroll:
        overlayWidget = Transform.translate(
          offset: Offset(0, _slideOffset),
          child: overlayWidget,
        );
        break;
      case OverlayEffectType.scaleOnScroll:
        overlayWidget = Transform.scale(scale: _scale, child: overlayWidget);
        break;
      case OverlayEffectType.fadeOnInactivity:
        overlayWidget = AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: _config!.effect.duration,
          child: overlayWidget,
        );
        break;
      default:
        break;
    }

    return _config!.alignment.positionWidget(
      Material(color: Colors.transparent, child: overlayWidget),
    );
  }

  /// Hide overlay (called from pages)
  static void hide() {
    _isVisible = false;
    _config?.onHide?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry?.markNeedsBuild();
    });
  }

  /// Show overlay (called from pages)
  static void show() {
    _isVisible = true;
    _config?.onDisplay?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry?.markNeedsBuild();
    });
  }

  /// Handle scroll events
  static void onScrollUpdate(double offset) {
    if (!_config!.enableScrollEffect) return;

    final delta = offset - _scrollOffset;
    _scrollOffset = offset;

    switch (_config!.effect.type) {
      case OverlayEffectType.scrollHide:
        _handleScrollHide();
        break;
      case OverlayEffectType.slideOnScroll:
        _handleSlideEffect(delta);
        break;
      case OverlayEffectType.scaleOnScroll:
        _handleScaleEffect();
        break;
      default:
        break;
    }

    _resetInactivityTimer();
  }

  static void _handleScrollHide() {
    if (!_isScrolling) {
      _isScrolling = true;
      _isVisible = false;
      _config?.onHide?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }

    _scrollStopTimer?.cancel();
    _scrollStopTimer = Timer(_config!.effect.duration, () {
      _isScrolling = false;
      _isVisible = true;
      _slideOffset = 0;
      _scale = 1.0;
      _config?.onDisplay?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    });
  }

  static void _handleSlideEffect(double delta) {
    _slideOffset = delta.clamp(-50.0, 50.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry?.markNeedsBuild();
    });

    _scrollStopTimer?.cancel();
    _scrollStopTimer = Timer(const Duration(milliseconds: 200), () {
      _slideOffset = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    });
  }

  static void _handleScaleEffect() {
    _scale = 0.8;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry?.markNeedsBuild();
    });

    _scrollStopTimer?.cancel();
    _scrollStopTimer = Timer(const Duration(milliseconds: 200), () {
      _scale = 1.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    });
  }

  static void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_config!.effect.inactivityDuration, () {
      _isVisible = false;
      _config?.onHide?.call();
      _overlayEntry?.markNeedsBuild();
    });
  }

  static void _resetInactivityTimer() {
    if (_config?.effect.type == OverlayEffectType.fadeOnInactivity) {
      _isVisible = true;
      _startInactivityTimer();
      _overlayEntry?.markNeedsBuild();
    }
  }

  /// Dispose overlay
  static void dispose() {
    _displayDelayTimer?.cancel();
    _scrollStopTimer?.cancel();
    _inactivityTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _initialized = false;
    _navigatorKey = null;
    _isVisible = true;
    _isScrolling = false;
    _scrollOffset = 0;
    _slideOffset = 0;
    _scale = 1.0;
    _config?.onDispose?.call();
    _config = null;
  }
}
