import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach/main.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const GolfCoachApp());
    expect(find.text('Golf Coach'), findsOneWidget);
  });
}