import 'package:flutter/material.dart';

/// Selo da marca "constancia." (assets/logo.png). A arte já traz o
/// nome embutido, então esse widget só cuida do tamanho e do recorte.
class BrandMark extends StatelessWidget {
  final double logoSize;

  const BrandMark({super.key, this.logoSize = 32});

  @override
  Widget build(BuildContext context) {
    // A arte tem 2000x2000 px. Sem cacheWidth/cacheHeight o Flutter decodifica
    // a imagem inteira na memória (~15 MB) só para desenhá-la a 30-48 px.
    // Pedimos a decodificação já no tamanho de tela, multiplicado pela
    // densidade do dispositivo para não perder nitidez.
    final densidade = MediaQuery.of(context).devicePixelRatio;
    final ladoEmPixels = (logoSize * densidade).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(logoSize * 0.28),
      child: Image.asset(
        'assets/logo.png',
        width: logoSize,
        height: logoSize,
        cacheWidth: ladoEmPixels,
        cacheHeight: ladoEmPixels,
        fit: BoxFit.cover,
      ),
    );
  }
}
