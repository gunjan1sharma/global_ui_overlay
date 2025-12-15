# 🌐 Global UI Overlay

**A lightweight, production-ready Flutter package to display global overlay widgets across your app with precise positioning, scroll-aware effects, and lifecycle callbacks.**

Designed for **FABs, chat heads, support buttons, banners, or any persistent UI element** that must float above your app reliably.

---

## ✅ pub.dev Quality Checklist (Passed)

- ✅ Clean public API
- ✅ Null-safe & memory-safe
- ✅ No HTML in README (pub.dev compatible)
- ✅ Clear usage & examples
- ✅ MIT licensed
- ✅ Zero dependencies
- ✅ Optimized for production apps

---

## ✨ Features

- 📍 **9 positioning options** (top/center/bottom × left/center/right)
- 🎭 **Scroll-aware visual effects**

  - Hide on scroll
  - Fade on inactivity
  - Slide on scroll
  - Scale on scroll

- ⏱ **Delayed display support**
- 🔔 **Lifecycle callbacks** (tap, show, hide, dispose)
- 🧠 **Global scroll detection**
- ⚡ **Minimal performance overhead**
- 🧹 **Automatic cleanup & memory-safe disposal**

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  global_ui_overlay: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start (Minimal Setup)

### 1️⃣ Create a global `NavigatorKey`

```dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```

---

### 2️⃣ Wrap your app with `ScrollDetectorWrapper`

This enables scroll-based effects globally.

```dart
MaterialApp(
  navigatorKey: navigatorKey,
  builder: (context, child) {
    return ScrollDetectorWrapper(child: child!);
  },
  home: HomePage(),
);
```

---

### 3️⃣ Initialize the overlay (once)

```dart
GlobalUIOverlay.initialize(
  navigatorKey: navigatorKey,
  config: GlobalUIOverlayConfig(
    child: FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.chat),
    ),
    alignment: OverlayAlignmentConfig(
      position: OverlayPosition.bottomRight,
    ),
    effect: OverlayEffect.scrollHide,
    enableScrollEffect: true,
  ),
);
```

That’s it — the overlay is now live across your app.

---

## ⚙️ Configuration Guide (Detailed)

### 🔹 `GlobalUIOverlayConfig`

| Property             | Type                     | Description                                |
| -------------------- | ------------------------ | ------------------------------------------ |
| `child`              | `Widget`                 | **Required.** Widget to display as overlay |
| `alignment`          | `OverlayAlignmentConfig` | Position + margin configuration            |
| `displayDelay`       | `Duration?`              | Delay before showing overlay               |
| `effect`             | `OverlayEffect`          | Visual behavior (scroll, fade, etc.)       |
| `enableScrollEffect` | `bool`                   | Enable scroll-based effects                |
| `onTap`              | `VoidCallback?`          | Called when overlay is tapped              |
| `onDisplay`          | `VoidCallback?`          | Called when overlay appears                |
| `onHide`             | `VoidCallback?`          | Called when overlay hides                  |
| `onDispose`          | `VoidCallback?`          | Called on cleanup                          |

---

### 📍 Positioning (`OverlayAlignmentConfig`)

```dart
OverlayAlignmentConfig(
  position: OverlayPosition.bottomRight,
  margin: EdgeInsets.only(bottom: 96, right: 16),
)
```

Available positions:

- `topLeft`, `topCenter`, `topRight`
- `centerLeft`, `center`, `centerRight`
- `bottomLeft`, `bottomCenter`, `bottomRight`

---

### 🎭 Effects (`OverlayEffect`)

| Effect                           | Behavior                  |
| -------------------------------- | ------------------------- |
| `OverlayEffect.none`             | No animation              |
| `OverlayEffect.scrollHide`       | Hides while scrolling     |
| `OverlayEffect.fadeOnInactivity` | Fades after inactivity    |
| `OverlayEffect.slideOnScroll`    | Slides slightly on scroll |
| `OverlayEffect.scaleOnScroll`    | Scales down during scroll |

Example:

```dart
effect: OverlayEffect.fadeOnInactivity,
enableScrollEffect: true,
```

---

## 🚫 Hiding Overlay on Specific Screens

Hide overlay on login, splash, or onboarding screens.

```dart
@override
void initState() {
  super.initState();
  GlobalUIOverlay.hide();
}

@override
void dispose() {
  GlobalUIOverlay.show();
  super.dispose();
}
```

---

## 🧹 Cleanup (Important)

Dispose when your app shuts down:

```dart
@override
void dispose() {
  GlobalUIOverlay.dispose();
  super.dispose();
}
```

---

## 🧠 Best Practices

- Initialize **only once**
- Always provide `navigatorKey`
- Use `ScrollDetectorWrapper` for scroll effects
- Hide overlay explicitly on sensitive screens
- Prefer lightweight widgets (FABs, icons)

---

## 🛡 License

**MIT License**

```
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👤 Author & Contact

**Gunjan Sharma**
Senior Flutter Engineer

- 🔗 LinkedIn: [https://www.linkedin.com/in/gunjan1sharma/](https://www.linkedin.com/in/gunjan1sharma/)
- 💻 GitHub: [https://github.com/gunjan1sharma](https://github.com/gunjan1sharma)
- 📧 Email: [gunjan.sharmo@gmail.com](gunjan.sharmo@gmail.com)

---

## ⭐ Support

If this package helps you:

- Star the repo ⭐
- Report issues
- Suggest improvements

---

**Built for teams that care about clean architecture, UX polish, and production reliability.**
