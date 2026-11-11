import 'package:flutter_test/flutter_test.dart';
import 'package:social_media/main.dart';

void main() {
  testWidgets('Social Media login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const SocialMediaApp());

    expect(find.text('SOCIAL MEDIA'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('Enter Username or Email'), findsOneWidget);
    expect(find.text('Developed by BRAVO'), findsOneWidget);
  });
}
