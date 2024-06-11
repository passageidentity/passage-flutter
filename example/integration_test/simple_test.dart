import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('simple test', (WidgetTester tester) async {
    await tester.pumpAndSettle();

    expect(2+2, 4);
  });
}
