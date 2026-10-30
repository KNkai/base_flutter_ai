import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter_ai/core/widgets/app_button.dart';
import 'package:base_flutter_ai/core/widgets/app_empty_view.dart';
import 'package:base_flutter_ai/core/widgets/app_error_view.dart';
import 'package:base_flutter_ai/core/widgets/app_loading_indicator.dart';

void main() {
  group('Core Widgets Tests', () {
    testWidgets('AppLoadingIndicator renders spinner and optional message', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLoadingIndicator(message: 'Loading please wait...'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading please wait...'), findsOneWidget);
    });

    testWidgets(
      'AppErrorView renders message and responds to retry button tap',
      (tester) async {
        var retried = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppErrorView(
                title: 'Error Occurred',
                message: 'Failed to connect to host',
                onRetry: () => retried = true,
              ),
            ),
          ),
        );

        expect(find.text('Error Occurred'), findsOneWidget);
        expect(find.text('Failed to connect to host'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);

        await tester.tap(find.text('Try Again'));
        expect(retried, isTrue);
      },
    );

    testWidgets('AppEmptyView renders empty title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyView(
              title: 'No Items Found',
              message: 'Try modifying your search filter',
            ),
          ),
        ),
      );

      expect(find.text('No Items Found'), findsOneWidget);
      expect(find.text('Try modifying your search filter'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('AppButton handles tap and displays loading state', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppButton(text: 'Submit', onPressed: () => tapped = true),
                const AppButton(text: 'Loading Button', isLoading: true),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      await tester.tap(find.text('Submit'));
      expect(tapped, isTrue);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
