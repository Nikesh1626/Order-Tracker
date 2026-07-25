import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_tracker/main.dart';
import 'package:order_tracker/screens/orders_list_screen.dart';

void main() {
  testWidgets('OrderTrackerApp launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: OrderTrackerApp(),
      ),
    );

    // Verify that the Orders List screen is displayed.
    // Note: We avoid pumpAndSettle here because the screen contains a pull-to-refresh
    // and network calls which might keep the test hanging if we wait indefinitely.
    await tester.pump();

    expect(find.byType(OrdersListScreen), findsOneWidget);
  });
}
