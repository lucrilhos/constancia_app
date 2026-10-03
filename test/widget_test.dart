import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constancia/main.dart';
import 'package:constancia/widgets/animated_wordmark.dart';

void main() {
  testWidgets('Tela de cadastro abre com a marca e o formulário',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ConstanciaApp());
    await tester.pump();

    expect(find.text('Crie sua conta'), findsOneWidget);
    expect(find.text('Criar minha conta'), findsOneWidget);

    // A marca deixou de ser um PNG e passou a ser o letreiro animado.
    expect(find.byType(AnimatedWordmark), findsOneWidget);
  });

  testWidgets('O letreiro desenha a marca letra a letra e termina com o ponto',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: AnimatedWordmark(fontSize: 32))),
    ));
    await tester.pump();

    // 'constancia' tem 10 letras, mais o ponto final: 11 Text de um caractere.
    expect(find.byType(Text), findsNWidgets(11));
    expect(find.text('.'), findsOneWidget);

    // A animação roda uma vez e termina — se ela ficasse em laço, o
    // pumpAndSettle estouraria o tempo limite.
    await tester.pumpAndSettle();
  });
}
