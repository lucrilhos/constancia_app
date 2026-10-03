import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Letreiro animado da marca `constancia.`
///
/// Substitui o antigo selo em PNG. As letras entram escalonadas, deslizando de
/// baixo para cima, e o ponto final — o detalhe que assina a marca — chega por
/// último, em laranja e com um leve exagero de escala. A animação roda uma vez,
/// quando a tela monta.
///
/// O texto é desenhado letra a letra, mas cada uma usa o mesmo tamanho de fonte
/// e a mesma altura de linha, então as caixas têm altura idêntica e os glifos
/// ficam alinhados na mesma base.
class AnimatedWordmark extends StatefulWidget {
  /// Altura da fonte do letreiro. O ponto final acompanha proporcionalmente.
  final double fontSize;

  const AnimatedWordmark({super.key, this.fontSize = 32});

  @override
  State<AnimatedWordmark> createState() => _AnimatedWordmarkState();
}

class _AnimatedWordmarkState extends State<AnimatedWordmark>
    with SingleTickerProviderStateMixin {
  static const String _palavra = 'constancia';

  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1150),
  )..forward();

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  /// Cada letra ocupa uma fatia da linha do tempo, começando um pouco depois
  /// da anterior. As fatias se sobrepõem, para o efeito sair contínuo e não
  /// como letras piscando uma de cada vez.
  Animation<double> _fatiaDaLetra(int indice) {
    final inicio = (indice / (_palavra.length + 2)) * 0.70;
    return CurvedAnimation(
      parent: _controle,
      curve: Interval(inicio, inicio + 0.30, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estilo = GoogleFonts.manrope(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      letterSpacing: -widget.fontSize * 0.028,
      height: 1.0,
    );

    return Semantics(
      label: 'constancia.',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _palavra.length; i++)
            _LetraQueSobe(
              animacao: _fatiaDaLetra(i),
              deslocamento: widget.fontSize * 0.42,
              child: Text(_palavra[i], style: estilo),
            ),
          _PontoDaMarca(
            controle: _controle,
            estilo: estilo.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

/// Uma letra que entra deslizando de baixo enquanto aparece.
class _LetraQueSobe extends StatelessWidget {
  final Animation<double> animacao;
  final double deslocamento;
  final Widget child;

  const _LetraQueSobe({
    required this.animacao,
    required this.deslocamento,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animacao,
      child: child,
      builder: (context, filho) {
        return Opacity(
          opacity: animacao.value,
          child: Transform.translate(
            offset: Offset(0, deslocamento * (1 - animacao.value)),
            child: filho,
          ),
        );
      },
    );
  }
}

/// O ponto final da marca: chega por último, cresce passando um pouco do
/// tamanho e assenta. É o elemento que dá o acento da identidade.
class _PontoDaMarca extends StatelessWidget {
  final AnimationController controle;
  final TextStyle estilo;

  const _PontoDaMarca({required this.controle, required this.estilo});

  @override
  Widget build(BuildContext context) {
    final escala = CurvedAnimation(
      parent: controle,
      curve: const Interval(0.62, 1.0, curve: Curves.elasticOut),
    );

    return AnimatedBuilder(
      animation: escala,
      child: Text('.', style: estilo),
      builder: (context, filho) {
        return Transform.scale(
          scale: escala.value,
          alignment: Alignment.bottomCenter,
          child: filho,
        );
      },
    );
  }
}
