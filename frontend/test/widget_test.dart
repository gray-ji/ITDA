import 'package:flutter_test/flutter_test.dart';
import 'package:itda_app/app.dart';

void main() {
  testWidgets('ITDA 앱이 정상적으로 실행된다', (WidgetTester tester) async {
    await tester.pumpWidget(const ITDAApp());

    // 주웠어요 탭
    expect(find.text('주웠어요'), findsOneWidget);
    expect(find.text('잃어버렸어요'), findsOneWidget);
    expect(find.text('검정색 카드지갑을 주웠어요'), findsOneWidget);
    expect(find.text('갈색 곰돌이 인형을 주웠어요'), findsOneWidget);

    // 잃어버렸어요 탭 선택
    await tester.tap(find.text('잃어버렸어요'));
    await tester.pump();

    // 잃어버렸어요 탭
    expect(find.text('에어팟 케이스를 찾습니다'), findsOneWidget);
    expect(find.text('회색 후드집업을 잃어버렸어요'), findsOneWidget);
  });
}