import 'package:flutter_test/flutter_test.dart';

import 'package:flutterquiz/main.dart'; // Make sure this points to your main.dart

void main() {
  testWidgets('QuizApp smoke test', (WidgetTester tester) async {
    
    await tester.pumpWidget(const QuizApp()); 

   
    expect(find.text('Flutter Quiz App'), findsOneWidget);
    expect(find.text('Quiz App Coming Soon!'), findsNothing); 


  });
}

