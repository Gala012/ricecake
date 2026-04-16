import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rice_cake/lang/lang.dart';

void main() {
  testWidgets('Lang nav label renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text(Lang.navHome))));
    expect(find.text(Lang.navHome), findsOneWidget);
  });
}
