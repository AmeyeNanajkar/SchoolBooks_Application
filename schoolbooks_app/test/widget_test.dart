import 'package:flutter_test/flutter_test.dart';

import 'package:schoolbooks_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolBooksApp());
    await tester.pumpAndSettle();
  });
}
