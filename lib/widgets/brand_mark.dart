import 'package:flutter/material.dart';

/// Selo da marca "constancia." (assets/logo.png). A arte já traz o
/// nome embutido, então esse widget só cuida do tamanho e do recorte.
class BrandMark extends StatelessWidget {
  final double logoSize;

  const BrandMark({super.key, this.logoSize = 32});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(logoSize * 0.28),
      child: Image.asset(
        'assets/logo.png',
        width: logoSize,
        height: logoSize,
        fit: BoxFit.cover,
      ),
    );
  }
}
