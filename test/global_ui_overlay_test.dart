import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_ui_overlay/global_ui_overlay.dart';

void main() {
  group('GlobalUIOverlay Tests', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      navigatorKey = GlobalKey<NavigatorState>();
      // Reset overlay state before each test
      GlobalUIOverlay.dispose();
    });

    tearDown(() {
      GlobalUIOverlay.dispose();
    });

    testWidgets('should initialize overlay with default config', (
      WidgetTester tester,
    ) async {
      bool onDisplayCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: const Icon(Icons.chat, key: Key('overlay_icon')),
                    onDisplay: () => onDisplayCalled = true,
                  ),
                );
              });
              return const Scaffold(body: Center(child: Text('Home')));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify overlay is displayed
      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);
      expect(onDisplayCalled, isTrue);
    });

    testWidgets('should position overlay at bottom right by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: Container(
                      key: const Key('overlay_widget'),
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final finder = find.byKey(const Key('overlay_widget'));
      expect(finder, findsOneWidget);

      final positioned = tester.widget<Positioned>(
        find.ancestor(of: finder, matching: find.byType(Positioned)),
      );

      expect(positioned.bottom, isNotNull);
      expect(positioned.right, isNotNull);
    });

    testWidgets('should position overlay at top left when configured', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: Container(
                      key: const Key('overlay_widget'),
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ),
                    alignment: const OverlayAlignmentConfig(
                      position: OverlayPosition.topLeft,
                    ),
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final finder = find.byKey(const Key('overlay_widget'));
      expect(finder, findsOneWidget);

      final positioned = tester.widget<Positioned>(
        find.ancestor(of: finder, matching: find.byType(Positioned)),
      );

      expect(positioned.top, isNotNull);
      expect(positioned.left, isNotNull);
    });

    testWidgets('should hide overlay when hide() is called', (
      WidgetTester tester,
    ) async {
      bool onHideCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: const Icon(Icons.chat, key: Key('overlay_icon')),
                    onHide: () => onHideCalled = true,
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially visible
      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);

      // Hide overlay
      GlobalUIOverlay.hide();
      await tester.pumpAndSettle();

      // Widget exists but should be replaced with SizedBox.shrink
      // Check for SizedBox.shrink instead
      expect(find.byType(SizedBox), findsWidgets);
      expect(onHideCalled, isTrue);

      // Verify icon is no longer visible by checking widget tree
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final hasShrinkBox = sizedBoxes.any(
        (box) => box.width == 0.0 && box.height == 0.0,
      );
      expect(hasShrinkBox, isTrue);
    });

    testWidgets('should show overlay after hide() then show()', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: const Icon(Icons.chat, key: Key('overlay_icon')),
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initially visible
      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);

      // Hide
      GlobalUIOverlay.hide();
      await tester.pumpAndSettle();

      // Verify hidden (SizedBox.shrink present)
      final sizedBoxesHidden = tester.widgetList<SizedBox>(
        find.byType(SizedBox),
      );
      final hasShrinkBoxHidden = sizedBoxesHidden.any(
        (box) => box.width == 0.0 && box.height == 0.0,
      );
      expect(hasShrinkBoxHidden, isTrue);

      // Show again
      GlobalUIOverlay.show();
      await tester.pumpAndSettle();

      // Verify visible again
      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);
    });

    testWidgets('should call onTap callback when overlay is tapped', (
      WidgetTester tester,
    ) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: Container(
                      key: const Key('overlay_widget'),
                      width: 50,
                      height: 50,
                      color: Colors.green,
                    ),
                    onTap: () => onTapCalled = true,
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap overlay
      await tester.tap(find.byKey(const Key('overlay_widget')));
      await tester.pumpAndSettle();

      expect(onTapCalled, isTrue);
    });

    testWidgets('should delay display when displayDelay is set', (
      WidgetTester tester,
    ) async {
      bool onDisplayCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: const Icon(Icons.chat, key: Key('overlay_icon')),
                    displayDelay: const Duration(seconds: 1),
                    onDisplay: () => onDisplayCalled = true,
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pump();

      // Should be hidden initially (SizedBox.shrink)
      final sizedBoxesInitial = tester.widgetList<SizedBox>(
        find.byType(SizedBox),
      );
      final hasShrinkBoxInitial = sizedBoxesInitial.any(
        (box) => box.width == 0.0 && box.height == 0.0,
      );
      expect(hasShrinkBoxInitial, isTrue);
      expect(onDisplayCalled, isFalse);

      // Wait for delay
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Should be visible now
      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);
      expect(onDisplayCalled, isTrue);
    });

    testWidgets(
      'should handle scroll events when ScrollDetectorWrapper is used',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  GlobalUIOverlay.initialize(
                    navigatorKey: navigatorKey,
                    config: GlobalUIOverlayConfig(
                      child: const Icon(Icons.chat, key: Key('overlay_icon')),
                      effect: OverlayEffect.scrollHide,
                      enableScrollEffect: true,
                    ),
                  );
                });
                return Scaffold(
                  body: ScrollDetectorWrapper(
                    child: ListView.builder(
                      itemCount: 50,
                      itemBuilder: (context, index) =>
                          ListTile(title: Text('Item $index')),
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially visible
        expect(find.byKey(const Key('overlay_icon')), findsOneWidget);

        // Scroll down
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pump();

        // Should be hidden during scroll (SizedBox.shrink)
        final sizedBoxesScrolling = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );
        final hasShrinkBoxScrolling = sizedBoxesScrolling.any(
          (box) => box.width == 0.0 && box.height == 0.0,
        );
        expect(hasShrinkBoxScrolling, isTrue);

        // Wait for scroll to stop
        await tester.pumpAndSettle(const Duration(milliseconds: 400));

        // Should be visible again
        expect(find.byKey(const Key('overlay_icon')), findsOneWidget);
      },
    );

    testWidgets('should dispose overlay cleanly', (WidgetTester tester) async {
      bool onDisposeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: const Icon(Icons.chat, key: Key('overlay_icon')),
                    onDispose: () => onDisposeCalled = true,
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('overlay_icon')), findsOneWidget);

      // Dispose overlay
      GlobalUIOverlay.dispose();
      await tester.pumpAndSettle();

      // After dispose, overlay entry is removed completely
      expect(find.byKey(const Key('overlay_icon')), findsNothing);
      expect(onDisposeCalled, isTrue);
    });

    testWidgets('should apply custom margins correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GlobalUIOverlay.initialize(
                  navigatorKey: navigatorKey,
                  config: GlobalUIOverlayConfig(
                    child: Container(
                      key: const Key('overlay_widget'),
                      width: 50,
                      height: 50,
                      color: Colors.purple,
                    ),
                    alignment: const OverlayAlignmentConfig(
                      position: OverlayPosition.bottomRight,
                      margin: EdgeInsets.only(bottom: 200, right: 50),
                    ),
                  ),
                );
              });
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.byKey(const Key('overlay_widget')),
          matching: find.byType(Positioned),
        ),
      );

      expect(positioned.bottom, equals(200));
      expect(positioned.right, equals(50));
    });

    test('OverlayEffect constants should have correct types', () {
      expect(
        OverlayEffect.scrollHide.type,
        equals(OverlayEffectType.scrollHide),
      );
      expect(
        OverlayEffect.fadeOnInactivity.type,
        equals(OverlayEffectType.fadeOnInactivity),
      );
      expect(
        OverlayEffect.slideOnScroll.type,
        equals(OverlayEffectType.slideOnScroll),
      );
      expect(
        OverlayEffect.scaleOnScroll.type,
        equals(OverlayEffectType.scaleOnScroll),
      );
      expect(OverlayEffect.none.type, equals(OverlayEffectType.none));
    });

    test('OverlayPosition enum should have all 9 positions', () {
      expect(OverlayPosition.values.length, equals(9));
      expect(OverlayPosition.values, contains(OverlayPosition.topLeft));
      expect(OverlayPosition.values, contains(OverlayPosition.topCenter));
      expect(OverlayPosition.values, contains(OverlayPosition.topRight));
      expect(OverlayPosition.values, contains(OverlayPosition.centerLeft));
      expect(OverlayPosition.values, contains(OverlayPosition.center));
      expect(OverlayPosition.values, contains(OverlayPosition.centerRight));
      expect(OverlayPosition.values, contains(OverlayPosition.bottomLeft));
      expect(OverlayPosition.values, contains(OverlayPosition.bottomCenter));
      expect(OverlayPosition.values, contains(OverlayPosition.bottomRight));
    });
  });
}
