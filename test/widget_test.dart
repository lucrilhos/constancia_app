import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constancia/main.dart';

void main() {
  testWidgets('Tela de cadastro abre com a marca e o formulário',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ConstanciaApp());
    await tester.pump();

    expect(find.text('Crie sua conta'), findsOneWidget);
    expect(find.text('Criar minha conta'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
