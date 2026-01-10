import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('App builds and shows Home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Home'), findsOneWidget);
  });
}