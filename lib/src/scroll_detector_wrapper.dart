import 'package:flutter/material.dart';
import 'global_ui_overlay_controller.dart';

class ScrollDetectorWrapper extends StatelessWidget {
  final Widget child;

  const ScrollDetectorWrapper({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          GlobalUIOverlay.onScrollUpdate(notification.metrics.pixels);
        }
        return false;
      },
      child: child,
    );
  }
}
